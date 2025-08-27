import 'package:cloud_firestore/cloud_firestore.dart';

class VoterDetails {
  final String id;
  final int serialNo;
  final String name;
  final String guardianName;
  final String houseName;
  final String gender; // Male, Female, Third
  final int age;
  final String voterId;
  final String pollingStation;
  final String religion;
  final String caste;
  final String voteType;
  final bool isSureVote;
  final bool isStayingOutside;
  final String stayingLocation;
  final String stayingStatus;
  final String influencer;
  final String education;
  final String occupation;
  final String mobileNo;
  final String state;
  final String district;
  final String block;
  final String panchayath;
  final String assembly;
  final String locBodyType;
  final String party;
  final String voterConcern;
  final bool voted;

  // Fields for record management
  final int bhagNo;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? updatedBy;

  VoterDetails({
    required this.id,
    required this.serialNo,
    required this.name,
    required this.guardianName,
    required this.houseName,
    required this.gender,
    required this.age,
    required this.voterId,
    required this.pollingStation,
    required this.religion,
    required this.caste,
    required this.voteType,
    required this.isSureVote,
    required this.isStayingOutside,
    required this.stayingLocation,
    this.stayingStatus = '',
    required this.influencer,
    required this.education,
    required this.occupation,
    required this.mobileNo,
    required this.state,
    required this.district,
    required this.block,
    required this.panchayath,
    required this.assembly,
    required this.locBodyType,
    required this.party,
    required this.voterConcern,
    this.voted = false,
    required this.bhagNo,
    required this.createdAt,
    this.updatedAt,
    this.updatedBy,
  });

  /// Create VoterDetails from JSON (API or Firestore)
  factory VoterDetails.fromJson(Map<String, dynamic> json, String documentId) {
    return VoterDetails(
      id: documentId,
      serialNo: json['serial_no'] ?? 0,
      name: json['name'] ?? '',
      guardianName: json['guardian_name'] ?? '',
      houseName: json['house_name'] ?? '',
      gender: json['gender'] ?? '',
      age: json['age'] ?? 0,
      voterId: json['voter_id'] ?? '',
      pollingStation: json['polling_station'] ?? '',
      religion: json['religion'] ?? '',
      caste: json['caste'] ?? '',
      voteType: json['vote_type'] ?? '',
      isSureVote: json['is_sure_vote'] ?? false,
      isStayingOutside: json['is_staying_outside'] ?? false,
      stayingLocation: json['staying_location'] ?? '',
      stayingStatus: json['staying_status'] ?? '',
      influencer: json['influencer'] ?? '',
      education: json['education'] ?? '',
      occupation: json['occupation'] ?? '',
      mobileNo: json['mobile_no']?.toString() ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      block: json['block'] ?? '',
      panchayath: json['panchayath'] ?? '',
      assembly: json['assembly'] ?? '',
      locBodyType: json['loc_body_type'] ?? '',
      party: json['party'] ?? '',
      voterConcern: json['voter_concern'] ?? '',
      voted: json['voted'] ?? false,
      bhagNo: json['bhag_no'] ?? 0,
      createdAt:
          json['created_at'] != null
              ? (json['created_at'] is Timestamp
                  ? (json['created_at'] as Timestamp).toDate()
                  : DateTime.parse(json['created_at'].toString()))
              : DateTime.now(),
      updatedAt:
          json['updated_at'] != null
              ? (json['updated_at'] is Timestamp
                  ? (json['updated_at'] as Timestamp).toDate()
                  : DateTime.parse(json['updated_at'].toString()))
              : null,
      updatedBy: json['updated_by'],
    );
  }

  /// Convert to JSON (Firebase-style keys)
  Map<String, dynamic> toJson() {
    return {
      'serial_no': serialNo,
      'name': name,
      'guardian_name': guardianName,
      'house_name': houseName,
      'gender': gender,
      'age': age,
      'voter_id': voterId,
      'polling_station': pollingStation,
      'religion': religion,
      'caste': caste,
      'vote_type': voteType,
      'is_sure_vote': isSureVote,
      'is_staying_outside': isStayingOutside,
      'staying_location': stayingLocation,
      'staying_status': stayingStatus,
      'influencer': influencer,
      'education': education,
      'occupation': occupation,
      'mobile_no': mobileNo,
      'state': state,
      'district': district,
      'block': block,
      'panchayath': panchayath,
      'assembly': assembly,
      'loc_body_type': locBodyType,
      'party': party,
      'voter_concern': voterConcern,
      'voted': voted,
      'bhag_no': bhagNo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'updated_by': updatedBy,
    };
  }
}
