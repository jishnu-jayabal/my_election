class VoterConcern {
  final String name;
  VoterConcern({required this.name});

  factory VoterConcern.fromJson(Map<String, dynamic> json) {
    return VoterConcern(name: json['name']);
  }

   Map<String, dynamic> toJson() {
    return {'name':name};
   }

}
