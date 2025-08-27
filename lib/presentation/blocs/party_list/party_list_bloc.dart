import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/political_groups.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'party_list_event.dart';
part 'party_list_state.dart';

class PartyListBloc extends Bloc<PartyListEvent, PartyListState> {
    final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  PartyListBloc() : super(PartyListInitial()) {
    on<PartyListEvent>((event, emit) {
      // TODO: implement event handler
    });
      on<FetchPartyListEvent>((event, emit) async {
      try {
        emit(PartyListLoading());
        List<PoliticalGroups> politicalGroups = await _apiBridge
            .getPoliticalGroups(
            );
        emit(PartyListSuccess(politicalGroups : politicalGroups));
      } catch (e) {
        emit(PartyListFailed(msg: e.toString()));
      }
    });
  }
  
}
