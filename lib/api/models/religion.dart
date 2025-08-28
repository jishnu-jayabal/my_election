class Religion {
  final String name;
  final String value;
  final String color;
  final int id;
  final List<String> castes;

  Religion({
    required this.name,
    required this.value,
    required this.id,
    required this.color,
    required this.castes,
  });

  // Factory constructor to create a Religion instance from JSON
  factory Religion.fromJson(Map<String, dynamic> json) {
    return Religion(
      name: json['name'] as String,
      castes:
          json['caste'] != null ? (json['caste'] as List).cast<String>() : [],
      value: json['value'] as String,
      color: json['color'] as String,
      id: json['id'] as int,
    );
  }

  // Method to convert Religion instance to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value, 'color': color, 'id': id};
  }

  // Optional: Override toString for better debugging
  @override
  String toString() {
    return 'Religion(name: $name, value: $value ,color: $color, id:$id)';
  }
}
