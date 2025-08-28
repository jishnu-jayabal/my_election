import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/education.dart';
import 'package:election_mantra/api/models/gender.dart';
import 'package:election_mantra/api/models/staying_status.dart';
import 'package:election_mantra/api/models/voter_cocern.dart';
import 'package:election_mantra/api/models/voter_type.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'startup_event.dart';
part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  StartupBloc() : super(StartupInitial()) {
    on<FetchStartupEvent>((event, emit) async {
      try {
        emit(StartupLoading());
        List<Education> education = await _apiBridge.getEducation();
        List<Gender> genders = await _apiBridge.getGender();
        List<VoterType> voterType = await _apiBridge.getVoterType();
        List<VoterConcern> voterConcern = await _apiBridge.getVoterConcern();
        List<StayingStatus> stayingStatus = await _apiBridge.getStayingStatus();
        emit(
          StartupSuccess(
            education: education,
            genders: genders,
            voterType: voterType,
            voterConcern: voterConcern,
            stayingStatus: stayingStatus,
          ),
        );
      } catch (e) {
        emit(StartupFailed(msg: e.toString()));
      }
    });
  }
}
