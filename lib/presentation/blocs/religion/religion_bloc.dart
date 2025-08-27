import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/religion.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'religion_event.dart';
part 'religion_state.dart';

class ReligionBloc extends Bloc<ReligionEvent, ReligionState> {
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  ReligionBloc() : super(ReligionInitial()) {
    on<ReligionEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchReligionEvent>((event, emit) async {
      try {
        emit(ReligionLoading());
        List<Religion> religion = await _apiBridge.getReligions();
        emit(ReligionSuccess(religions: religion));
      } catch (e) {
        emit(ReligionFailed(msg: e.toString()));
      }
    });
  }
}
