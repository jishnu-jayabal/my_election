class StayingStatus {
  final String name;
  final String type;
  StayingStatus({required this.name,required this.type});

  factory StayingStatus.fromJson(Map<String, dynamic> json) {
    return StayingStatus(name: json['name'] ,type: json['type']);
  }

   Map<String, dynamic> toJson() {
    return {'name':name};
   }

}
