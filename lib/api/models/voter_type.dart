class VoterType {
  final String name;
  VoterType({required this.name});

  factory VoterType.fromJson(Map<String, dynamic> json) {
    return VoterType(name: json['name']);
  }

   Map<String, dynamic> toJson() {
    return {'name':name};
   }

}
