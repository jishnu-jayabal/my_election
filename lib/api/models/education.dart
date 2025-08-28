class Education {
  final String name;
  Education({required this.name});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(name: json['name']);
  }

   Map<String, dynamic> toJson() {
    return {'name':name};
   }

}
