class PoliticalGroups {
  final int id;
  final String name;
  final String symbol; // optional, if you have a party symbol
  final String abbreviation;
  final String color;

  PoliticalGroups({
    required this.id,
    required this.name,
    required this.symbol,
    required this.abbreviation,
    required this.color
  });

  factory PoliticalGroups.fromJson(Map<String, dynamic> json) {
    return PoliticalGroups(
      id: json['id'],
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name': name,
      'symbol': symbol,
      'abbreviation': abbreviation,
      'color':color
    };
  }
}
