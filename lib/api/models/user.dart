class User {
  final String id;        // Firebase UID
  final String name;
  final int? boothNo;      // from authorized users
  final int? wardNo;
  final int? constituencyNo;

  User({
    required this.id,
    required this.name,
    required this.boothNo,
    required this.wardNo,
    required this.constituencyNo
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        boothNo: json['bhag_no'] as int?,
        wardNo: json['ward_no'] as int?,
        constituencyNo: json['constituency_no'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bhag_no': boothNo,
        'ward_no':wardNo,
        'constituency_no':constituencyNo
      };
}
