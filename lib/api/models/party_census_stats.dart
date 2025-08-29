class PartyCountDetail {
  final String party;
  final int count;
  final double percentage;
  final String? color; // Optional color for UI

  const PartyCountDetail({
    required this.party,
    required this.count,
    required this.percentage,
    this.color,
  });

  // Factory method to create from JSON
  factory PartyCountDetail.fromJson(Map<String, dynamic> json) {
    return PartyCountDetail(
      party: json['party'] ?? '',
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      color: json['color'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'party': party,
      'count': count,
      'percentage': percentage,
      if (color != null) 'color': color,
    };
  }

  // Copy with method for immutability
  PartyCountDetail copyWith({
    String? party,
    int? count,
    double? percentage,
    String? color,
  }) {
    return PartyCountDetail(
      party: party ?? this.party,
      count: count ?? this.count,
      percentage: percentage ?? this.percentage,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'PartyCountDetail(party: $party, count: $count, percentage: $percentage%, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PartyCountDetail &&
        other.party == party &&
        other.count == count &&
        other.percentage == percentage &&
        other.color == color;
  }

  @override
  int get hashCode {
    return Object.hash(party, count, percentage, color);
  }
}


class PartyCensusStats {
  final Map<String, PartyCountDetail> total;
  final Map<String, PartyCountDetail> voted;
  final Map<String, PartyCountDetail> notVoted;

  const PartyCensusStats({
    required this.total,
    required this.voted,
    required this.notVoted,
  });

  // Factory method to create from JSON
  factory PartyCensusStats.fromJson(Map<String, dynamic> json) {
    return PartyCensusStats(
      total: _parsePartyDetailMap(json['total']),
      voted: _parsePartyDetailMap(json['voted']),
      notVoted: _parsePartyDetailMap(json['not_voted']),
    );
  }

  // Helper method to parse the map
  static Map<String, PartyCountDetail> _parsePartyDetailMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data.map((key, value) {
        return MapEntry(
          key,
          PartyCountDetail.fromJson(value is Map<String, dynamic> 
            ? value 
            : {'party': key} // Fallback if value is not a map
          ),
        );
      });
    }
    return {};
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'total': total.map((key, value) => MapEntry(key, value.toJson())),
      'voted': voted.map((key, value) => MapEntry(key, value.toJson())),
      'not_voted': notVoted.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  // Get total count across all parties
  int get totalVoters {
    return total.values.fold(0, (sum, detail) => sum + detail.count);
  }

  // Get total voted count
  int get totalVoted {
    return voted.values.fold(0, (sum, detail) => sum + detail.count);
  }

  // Get total not voted count
  int get totalNotVoted {
    return notVoted.values.fold(0, (sum, detail) => sum + detail.count);
  }

  // Get detail for a specific party
  PartyCountDetail? getPartyDetail(String partyName, {String category = 'total'}) {
    switch (category) {
      case 'voted':
        return voted[partyName];
      case 'not_voted':
        return notVoted[partyName];
      default:
        return total[partyName];
    }
  }

  // Get voting percentage for a party
  double getPartyVotingPercentage(String partyName) {
    final totalDetail = total[partyName];
    final votedDetail = voted[partyName];
    
    if (totalDetail == null || votedDetail == null || totalDetail.count == 0) {
      return 0.0;
    }
    
    return (votedDetail.count / totalDetail.count) * 100;
  }

  // Get all parties across categories
  Set<String> get allParties {
    return {...total.keys, ...voted.keys, ...notVoted.keys};
  }

  // Copy with method
  PartyCensusStats copyWith({
    Map<String, PartyCountDetail>? total,
    Map<String, PartyCountDetail>? voted,
    Map<String, PartyCountDetail>? notVoted,
  }) {
    return PartyCensusStats(
      total: total ?? this.total,
      voted: voted ?? this.voted,
      notVoted: notVoted ?? this.notVoted,
    );
  }

  @override
  String toString() {
    return 'PartyCensusStats(\n'
        '  Total: ${total.length} parties, $totalVoters voters\n'
        '  Voted: ${voted.length} parties, $totalVoted voters\n'
        '  Not Voted: ${notVoted.length} parties, $totalNotVoted voters\n'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PartyCensusStats &&
        _mapsEqual(other.total, total) &&
        _mapsEqual(other.voted, voted) &&
        _mapsEqual(other.notVoted, notVoted);
  }

  bool _mapsEqual(Map<String, PartyCountDetail> a, Map<String, PartyCountDetail> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(total.keys),
      Object.hashAll(total.values),
      Object.hashAll(voted.keys),
      Object.hashAll(voted.values),
      Object.hashAll(notVoted.keys),
      Object.hashAll(notVoted.values),
    );
  }
}