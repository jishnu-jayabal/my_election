import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/core/api_bridge.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'update_voter_event.dart';
part 'update_voter_state.dart';

class UpdateVoterBloc extends Bloc<UpdateVoterEvent, UpdateVoterState> {
   final ApiBridge _apiBridge = GetIt.I<ApiBridge>();
  UpdateVoterBloc() : super(UpdateVoterInitial()) {
    on<UpdateVoterDetailsEvent>((event, emit) async {
      try {
        emit(UpdateVoterLoading());
        await _apiBridge.updateVoter(event.voterDetails);
        emit(UpdateVoterSuccess(voterUpdated: event.voterDetails));
      } catch(e){
        emit(UpdateVoterFailed(msg: e.toString()));
      }
    });
  }
}
