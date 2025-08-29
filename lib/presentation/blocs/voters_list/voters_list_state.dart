// voters_list_state.dart
part of 'voters_list_bloc.dart';

@immutable
sealed class VotersListState {}

class VotersListInitial extends VotersListState {}

class VotersListLoading extends VotersListState {}

class VotersListFailure extends VotersListState {
  final String msg;
  VotersListFailure({required this.msg});
}

class VotersListSuccess extends VotersListState {
  final List<VoterDetails> voters;

  VotersListSuccess({required List<VoterDetails> voters})
    : voters = List.unmodifiable(voters); // ensures immutable

  VotersListSuccess copyWith({List<VoterDetails>? voters}) {
    return VotersListSuccess(
      voters: voters != null ? List.unmodifiable(voters) : this.voters,
    );
  }

  @override
  List<Object?> get props => [voters];

  // Optional: helper to check if voters changed
  bool hasChanged(VotersListSuccess other) {
    if (voters.length != other.voters.length) return true;
    for (int i = 0; i < voters.length; i++) {
      if (voters[i] != other.voters[i]) return true;
    }
    return false;
  }
}
