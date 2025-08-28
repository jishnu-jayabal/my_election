class Gender {
  final String name;
  Gender({required this.name});

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(name: json['name']);
  }

   Map<String, dynamic> toJson() {
    return {'name':name};
   }

}
