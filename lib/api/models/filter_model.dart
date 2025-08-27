class FilterModel {
  final String? status;
  final String? affiliation;
  final String? ageGroup;
  final String? religion;

  FilterModel({
    this.status,
    this.affiliation,
    this.ageGroup,
    this.religion,
  });

  factory FilterModel.initial() => FilterModel();

  static const _sentinel = Object();

  FilterModel copyWith({
    Object? status = _sentinel,
    Object? affiliation = _sentinel,
    Object? ageGroup = _sentinel,
    Object? religion = _sentinel,
  }) {
    return FilterModel(
      status: status == _sentinel ? this.status : status as String?,
      affiliation: affiliation == _sentinel ? this.affiliation : affiliation as String?,
      ageGroup: ageGroup == _sentinel ? this.ageGroup : ageGroup as String?,
      religion: religion == _sentinel ? this.religion : religion as String?,
    );
  }

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (status != null) params['status'] = status!;
    if (affiliation != null) params['affiliation'] = affiliation!;
    if (ageGroup != null) params['age_group'] = ageGroup!;
    if (religion != null) params['religion'] = religion!;
    return params;
  }

  bool get hasActiveFilters {
    return status != null ||
        affiliation != null ||
        ageGroup != null ||
        religion != null;
  }

  FilterModel clearAll() => FilterModel();

  @override
  String toString() {
    return 'FilterModel(status: $status, affiliation: $affiliation, ageGroup: $ageGroup, religion: $religion)';
  }
}
