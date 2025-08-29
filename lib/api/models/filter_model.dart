class FilterModel {
  final String? status;
  final String? voted;
  final String? affiliation;
  final String? ageGroup;
  final String? religion;
  final String? gender;

  FilterModel({
    this.status,
    this.affiliation,
    this.ageGroup,
    this.religion,
    this.gender,
    this.voted
  });

  factory FilterModel.initial() => FilterModel();

  static const _sentinel = Object();

  FilterModel copyWith({
    Object? status = _sentinel,
    Object? voted = _sentinel,
    Object? affiliation = _sentinel,
    Object? ageGroup = _sentinel,
    Object? religion = _sentinel,
    Object? gender = _sentinel,
  }) {
    return FilterModel(
      status: status == _sentinel ? this.status : status as String?,
      voted: voted == _sentinel ? this.voted : voted as String?,
      affiliation: affiliation == _sentinel ? this.affiliation : affiliation as String?,
      ageGroup: ageGroup == _sentinel ? this.ageGroup : ageGroup as String?,
      religion: religion == _sentinel ? this.religion : religion as String?,
      gender: gender == _sentinel ? this.gender : gender as String?,
    );
  }

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (status != null) params['status'] = status!;
    if (voted != null) params['voted'] = voted!;
    if (affiliation != null) params['affiliation'] = affiliation!;
    if (ageGroup != null) params['age_group'] = ageGroup!;
    if (religion != null) params['religion'] = religion!;
    if (gender != null) params['gender'] = religion!;
    return params;
  }

  bool get hasActiveFilters {
    return status != null ||
        affiliation != null ||
        ageGroup != null ||
        religion != null ||
        gender != null;
  }

  FilterModel clearAll() => FilterModel();

  @override
  String toString() {
    return 'FilterModel(status: $status, affiliation: $affiliation, ageGroup: $ageGroup, religion: $religion, gender $gender)';
  }
}
