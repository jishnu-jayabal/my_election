import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:meta/meta.dart';

part 'house_list_event.dart';
part 'house_list_state.dart';

class HouseListBloc extends Bloc<HouseListEvent, HouseListState> {

  /// Full master list of voters (never filtered)
  List<VoterDetails> _allVoters = [];

  /// Currently visible house mapping (filtered or full)
  Map<String, List<VoterDetails>> _currentHouseWise = {};

  /// Tracks which houses are expanded
  Map<String, bool> expandedState = {};

  HouseListBloc() : super(HouseListInitial()) {
    /// Initialize house list with voters
    on<FetchHouseListEventLocal>((event, emit) {
      
      _allVoters = List.from(event.voters);
      _currentHouseWise = _groupByHouse(_allVoters);
      expandedState = {for (var key in _currentHouseWise.keys) key: false};

      emit(
        HouseListSuccess(houseWise: _currentHouseWise, expandedState: expandedState),
      );
    });

    /// Search within house names
    on<SearchHouseListEvent>((event, emit) {
      final query = event.searchTerm?.trim().toLowerCase() ?? "";

      final filtered = _allVoters.where((voter) {
        return voter.houseName.toLowerCase().contains(query);
      }).toList();

      _currentHouseWise = _groupByHouse(filtered);

      // Preserve expansion state for filtered houses
      final newExpandedState = {
        for (var key in _currentHouseWise.keys)
          key: expandedState[key] ?? false,
      };

      emit(
        HouseListSuccess(houseWise: _currentHouseWise, expandedState: newExpandedState),
      );
    });

    /// Toggle a house tile expansion
    on<ToggleHouseExpansionEvent>((event, emit) {
      if (!expandedState.containsKey(event.houseName)) return;
      expandedState[event.houseName] = !(expandedState[event.houseName] ?? false);

      emit(
        HouseListSuccess(
          houseWise: _currentHouseWise,
          expandedState: Map.from(expandedState),
        ),
      );
    });

    /// Update a voter in the house list (only visible houses)
    on<UpdateVoterInHouseListEvent>((event, emit) {
      // Update master list
      final index = _allVoters.indexWhere((v) => v.id == event.voter.id);
      if (index != -1) _allVoters[index] = event.voter;

      // Update only currently visible houses
      _currentHouseWise = {
        for (var house in _currentHouseWise.keys)
          house: _currentHouseWise[house]!
              .map((v) => v.id == event.voter.id ? event.voter : v)
              .toList()
      };

      emit(
        HouseListSuccess(
          houseWise: _currentHouseWise,
          expandedState: expandedState,
        ),
      );
    });
  }

  /// Groups voters by house name
  Map<String, List<VoterDetails>> _groupByHouse(List<VoterDetails> voters) {
    final Map<String, List<VoterDetails>> grouped = {};
    for (var voter in voters) {
      final house = voter.houseName.trim().isEmpty ? "Unknown House" : voter.houseName;
      grouped.putIfAbsent(house, () => []);
      grouped[house]!.add(voter);
    }

    // Sort members by serial number
    for (var list in grouped.values) {
      list.sort((a, b) => a.serialNo.compareTo(b.serialNo));
    }

    return grouped;
  }
}
