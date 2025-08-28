import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/filter_model.dart';

class FilterCubit extends Cubit<FilterModel> {
  FilterCubit() : super(FilterModel.initial());

  void updateFilter({
    String? status,
    String? affiliation,
    String? ageGroup,
    String? religion,
    String? gender,
  }) {
    emit(
      state.copyWith(
        status: status ?? state.status,
        affiliation: affiliation ?? state.affiliation,
        ageGroup: ageGroup ?? state.ageGroup,
        religion: religion ?? state.religion,
        gender: gender ?? state.gender,
      ),
    );
  }

  void resetAll() => emit(FilterModel.initial());
  void updateStatus(String? status) {
    emit(state.copyWith(status: status));
  }

  void updateAffiliation(String? affiliation) {
    emit(state.copyWith(affiliation: affiliation));
  }

  void updateAgeGroup(String? ageGroup) {
    emit(state.copyWith(ageGroup: ageGroup));
  }

  void updateReligion(String? religion) {
    emit(state.copyWith(religion: religion));
  }

  void updateGender(String? gender) {
    emit(state.copyWith(gender: gender));
  }

  void clearAllFilters() {
    emit(FilterModel.initial());
  }

  void clearFilter(FilterType filterType) {
    switch (filterType) {
      case FilterType.status:
        emit(state.copyWith(status: null));
        break;
      case FilterType.affiliation:
        emit(state.copyWith(affiliation: null));
        break;
      case FilterType.ageGroup:
        emit(state.copyWith(ageGroup: null));
        break;
      case FilterType.religion:
        emit(state.copyWith(religion: null));
        break;
      case FilterType.gender:
        emit(state.copyWith(gender: null));
        break;
    }
  }

  bool get hasActiveFilters => state.hasActiveFilters;

  FilterModel get currentFilters => state;
}

enum FilterType { status, affiliation, ageGroup, religion , gender }
