import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/filter_model.dart';
// filter_state.dart
import 'package:election_mantra/api/models/filter_model.dart';

class FilterState {
  final FilterModel temporaryFilters;
  final FilterModel appliedFilters;

  FilterState({required this.temporaryFilters, required this.appliedFilters});

  factory FilterState.initial() {
    return FilterState(
      temporaryFilters: FilterModel.initial(),
      appliedFilters: FilterModel.initial(),
    );
  }

  FilterState copyWith({
    FilterModel? temporaryFilters,
    FilterModel? appliedFilters,
  }) {
    return FilterState(
      temporaryFilters: temporaryFilters ?? this.temporaryFilters,
      appliedFilters: appliedFilters ?? this.appliedFilters,
    );
  }
} // Import the new state

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterState.initial());

  void updateTemporaryFilter({
    String? status,
    String? affiliation,
    String? ageGroup,
    String? religion,
    String? gender,
  }) {
    emit(
      state.copyWith(
        temporaryFilters: state.temporaryFilters.copyWith(
          status: status ?? state.temporaryFilters.status,
          affiliation: affiliation ?? state.temporaryFilters.affiliation,
          ageGroup: ageGroup ?? state.temporaryFilters.ageGroup,
          religion: religion ?? state.temporaryFilters.religion,
          gender: gender ?? state.temporaryFilters.gender,
        ),
      ),
    );
  }

  void applyTemporaryFilters() {
    emit(state.copyWith(appliedFilters: state.temporaryFilters));
  }

  void resetTemporaryFilters() {
    emit(state.copyWith(temporaryFilters: FilterModel.initial()));
  }

  void resetAll() => emit(FilterState.initial());

  void clearTemporaryFilter(FilterType filterType) {
    final updatedTemporary = _clearFilter(state.temporaryFilters, filterType);
    emit(state.copyWith(temporaryFilters: updatedTemporary));
  }

  void clearAppliedFilter(FilterType filterType) {
    final updatedApplied = _clearFilter(state.appliedFilters, filterType);
    emit(state.copyWith(appliedFilters: updatedApplied));
  }

  void clearAllAppliedFilters() {
    emit(state.copyWith(appliedFilters: FilterModel.initial()));
  }

  FilterModel _clearFilter(FilterModel filters, FilterType filterType) {
    switch (filterType) {
      case FilterType.status:
        return filters.copyWith(status: null);
      case FilterType.affiliation:
        return filters.copyWith(affiliation: null);
      case FilterType.ageGroup:
        return filters.copyWith(ageGroup: null);
      case FilterType.religion:
        return filters.copyWith(religion: null);
      case FilterType.gender:
        return filters.copyWith(gender: null);
    }
  }

  // In your FilterCubit, add this method:
  void updateAffiliation(String? affiliation) {
    emit(
      state.copyWith(
        temporaryFilters: state.temporaryFilters.copyWith(
          affiliation: affiliation,
        ),
      ),
    );
  }

  bool get hasActiveAppliedFilters => state.appliedFilters.hasActiveFilters;
  FilterModel get currentAppliedFilters => state.appliedFilters;
  FilterModel get currentTemporaryFilters => state.temporaryFilters;
}

enum FilterType { status, affiliation, ageGroup, religion, gender }
