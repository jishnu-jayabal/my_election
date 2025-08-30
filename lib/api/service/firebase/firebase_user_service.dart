import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election_mantra/api/models/age_group_stats.dart';
import 'package:election_mantra/api/models/education.dart';
import 'package:election_mantra/api/models/filter_model.dart';
import 'package:election_mantra/api/models/gender.dart';
import 'package:election_mantra/api/models/party_census_stats.dart';
import 'package:election_mantra/api/models/political_groups.dart';
import 'package:election_mantra/api/models/religion.dart';
import 'package:election_mantra/api/models/religion_group_stats.dart';
import 'package:election_mantra/api/models/staying_status.dart';
import 'package:election_mantra/api/models/user.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/api/models/voter_cocern.dart';
import 'package:election_mantra/api/models/voter_type.dart';
import 'package:election_mantra/api/models/voters_census_stats.dart';
import 'package:election_mantra/api/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class FirebaseUserService implements UserRepository {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;

  @override
  Future<void> sendOtp({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        throw Exception(e.message ?? "OTP verification failed");
      },
      codeSent: (verificationId, _) {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  @override
  Future<void> verifyOtp({required String otp, bool forReauth = false}) async {
    if (_verificationId == null) {
      throw Exception("Verification ID is null. OTP might not be sent yet.");
    }

    final credential = fb_auth.PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    final user = _auth.currentUser;

    if (forReauth) {
      if (user == null) {
        throw Exception("No user logged in for re-authentication.");
      }
      await user.reauthenticateWithCredential(credential);
    } else {
      await _auth.signInWithCredential(credential);
    }

    final phone = getCurrentPhoneNumber();
    if (phone == null) {
      throw Exception("No phone number found for user");
    }

    final doc =
        await _firestore.collection('authorized_users').doc(phone).get();

    if (!doc.exists || doc.data() == null) {
      await signOut();
      throw Exception("This phone number is not authorized.");
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  String? getCurrentUserId() => _auth.currentUser?.uid;

  @override
  String? getCurrentPhoneNumber() => _auth.currentUser?.phoneNumber;

  @override
  Future<User?> getUserProfile() async {
    final phoneNumber = getCurrentPhoneNumber();
    final uid = getCurrentUserId();
    if (phoneNumber == null) return null;

    final doc =
        await _firestore.collection('authorized_users').doc(phoneNumber).get();
    if (!doc.exists || doc.data() == null) return null;

    final data = doc.data()!;
    return User(
      id: uid!,
      name: data['name'] as String,
      location_name: data['location_name'] as String,
      boothNo: data['bhag_no'],
      constituencyNo: data['constituency_no'],
      wardNo: data['ward_no'],
    );
  }

  @override
  Future<List<VoterDetails>> getVoters({
    int? boothId,
    int? wardId,
    int? constituencyId,
    int? limit = 100,
    String? searchTerm,
  }) async {
    Query query = _firestore.collection('records');

    // ⚡ Match Firestore fields correctly
    if (boothId != null) {
      query = query.where('bhag_no', isEqualTo: boothId).orderBy('serial_no');
    }
    if (constituencyId != null) {
      query = query
          .where('assembly', isEqualTo: constituencyId)
          .orderBy('serial_no');
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();

    // wardId not available currently

    return snapshot.docs
        .map(
          (doc) =>
              VoterDetails.fromJson(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  @override
  Future<void> updateVoter(VoterDetails voterDetails) async {
    try {
      final collection = _firestore.collection('records');

      if (voterDetails.id.isNotEmpty) {
        // Update existing voter
        await collection
            .doc(voterDetails.id)
            .set(voterDetails.toJson(), SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception("Failed to save voter details: $e");
    }
  }

  @override
  Future<List<VoterDetails>> getVotersByFilter({
    int? boothId,
    int? wardId,
    int? constituencyId,
    required FilterModel filter,
  }) async {
    try {
      Query query = _firestore.collection('records');

      // Apply location filters (only one can be active due to index constraints)
      if (boothId != null) {
        query = query.where('bhag_no', isEqualTo: boothId);
      } else if (constituencyId != null) {
        query = query.where('assembly', isEqualTo: constituencyId);
        // For assembly queries, you'll need separate assembly-based indexes
      }

      // Apply filters in optimal order for index usage
      if (filter.affiliation != null) {
        query = query.where('party', isEqualTo: filter.affiliation);
      }

      if (filter.religion != null) {
        query = query.where('religion', isEqualTo: filter.religion);
      }

      // ✅ Gender
      if (filter.gender != null && filter.gender!.isNotEmpty) {
        query = query.where('gender', isEqualTo: filter.gender);
      }

      if (filter.voted != null) {
        if (filter.voted == 'voted') {
          query = query.where('voted', isEqualTo: true);
        } else if (filter.voted == 'not voted') {
          query = query.where('voted', isEqualTo: false);
        }
      }

      // Status filter - handle carefully
      if (filter.status != null) {
        if (filter.status == 'completed') {
          query = query.where('updated_by', isNotEqualTo: '');
        } else if (filter.status == 'pending') {
          query = query.where('updated_by', isEqualTo: '');
        }
      }

      // Age filter - MOST EXPENSIVE, apply last
      if (filter.ageGroup != null && filter.ageGroup != 'Unknown') {
        final ageRange = _getAgeRange(filter.ageGroup!);
        if (ageRange != null) {
          query = query
              .where('age', isGreaterThanOrEqualTo: ageRange['min'])
              .where('age', isLessThanOrEqualTo: ageRange['max']);
        }
      } else if (filter.ageGroup == 'Unknown') {
        query = query.where('age', isNull: true);
      }

      // Always order by serial_no for consistent pagination
      query = query.orderBy('serial_no');

      final snapshot = await query.get();

      return snapshot.docs
          .map(
            (doc) => VoterDetails.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch filtered voters: $e');
    }
  }

  // Get List of Groups/Political Parties
  @override
  Future<List<PoliticalGroups>> getPoliticalGroups() async {
    final snapshot = await _firestore.collection('political_groups').get();

    final groups =
        snapshot.docs
            .map((doc) => PoliticalGroups.fromJson(doc.data()))
            .toList();

    // Sort by `id` field (assuming it's an int)
    groups.sort((a, b) => a.id.compareTo(b.id));

    return groups;
  }

  @override
  Future<List<Religion>> getReligions() async {
    final snapshot = await _firestore.collection('religion').get();

    final groups =
        snapshot.docs.map((doc) => Religion.fromJson(doc.data())).toList();

    // Sort by `id` field (assuming it's an int)
    groups.sort((a, b) => a.id.compareTo(b.id));

    return groups;
  }

  @override
  Future<List<Education>> getEducation() async {
    final snapshot = await _firestore.collection('education').get();

    final groups =
        snapshot.docs.map((doc) => Education.fromJson(doc.data())).toList();

    return groups;
  }

  @override
  Future<List<Gender>> getGender() async {
    final snapshot = await _firestore.collection('gender').get();

    final groups =
        snapshot.docs.map((doc) => Gender.fromJson(doc.data())).toList();

    return groups;
  }

  @override
  Future<List<VoterType>> getVoterType() async {
    final snapshot = await _firestore.collection('votetype').get();

    final groups =
        snapshot.docs.map((doc) => VoterType.fromJson(doc.data())).toList();

    return groups;
  }

  @override
  Future<List<VoterConcern>> getVoterConcern() async {
    final snapshot = await _firestore.collection('voterconcern').get();

    final groups =
        snapshot.docs.map((doc) => VoterConcern.fromJson(doc.data())).toList();

    return groups;
  }

  @override
  Future<List<StayingStatus>> getStayingStatus() async {
    final snapshot = await _firestore.collection('stayingstatus').get();

    final groups =
        snapshot.docs.map((doc) => StayingStatus.fromJson(doc.data())).toList();

    return groups;
  }

  //Get Party Count By Voter Preference regardless whether they have voted or not
  @override
  Future<PartyCensusStats> getPartySupportCount({
    int? boothId,
    int? wardId,
    int? constituencyId,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection('records');

    if (boothId != null) {
      query = query.where('bhag_no', isEqualTo: boothId);
    }
    if (wardId != null) {
      query = query.where('ward_no', isEqualTo: wardId);
    }
    if (constituencyId != null) {
      query = query.where('assembly', isEqualTo: constituencyId);
    }

    // Get total count
    final totalSnap = await query.count().get();
    final total = totalSnap.count;

    if (total == 0) return PartyCensusStats(total: {}, voted: {}, notVoted: {});

    final allParties = await getPoliticalGroups();

    final totalMap = <String, PartyCountDetail>{};
    final votedMap = <String, PartyCountDetail>{};
    final notVotedMap = <String, PartyCountDetail>{};

    // Count for each party using Firebase queries
    for (final party in allParties) {
      // Total count for this party
      final partyQuery = query.where('party', isEqualTo: party.name);
      final partySnap = await partyQuery.count().get();
      final partyTotal = partySnap.count;

      // Voted count for this party
      final votedQuery = partyQuery.where('voted', isEqualTo: true);
      final votedSnap = await votedQuery.count().get();
      final partyVoted = votedSnap.count;

      // Not voted count for this party
      final notVotedQuery = partyQuery.where('voted', isEqualTo: false);
      final notVotedSnap = await notVotedQuery.count().get();
      final partyNotVoted = notVotedSnap.count;

      // Add to results as PartyCountDetail objects
      totalMap[party.name] = PartyCountDetail(
        party: party.name,
        count: partyTotal!,
        percentage: (partyTotal / total!) * 100,
        color: party.color,
      );

      votedMap[party.name] = PartyCountDetail(
        party: party.name,
        count: partyVoted!,
        percentage: (partyVoted / total!) * 100,
        color: party.color,
      );

      notVotedMap[party.name] = PartyCountDetail(
        party: party.name,
        count: partyNotVoted!,
        percentage: (partyNotVoted / total) * 100,
        color: party.color,
      );
    }

    return PartyCensusStats(
      total: totalMap,
      voted: votedMap,
      notVoted: notVotedMap,
    );
  }

  /// Get voters census statistics (total, completed, pending)
  @override
  Future<VoterCensusStats> getVoterCensusStatsCount({
    int? boothId,
    int? wardId,
    int? constituencyId,
  }) async {
    final votersRef = _firestore.collection("records");

    Query baseQuery = votersRef;
    if (boothId != null) {
      baseQuery = baseQuery.where("bhag_no", isEqualTo: boothId);
    }

    if (constituencyId != null) {
      baseQuery = baseQuery.where("assembly", isEqualTo: constituencyId);
    }

    // Total voters
    final totalSnap = await baseQuery.count().get();
    final total = totalSnap.count ?? 0;

    // Completed voters → updated_by != ""
    final completedSnap =
        await baseQuery
            .where("updated_by", isGreaterThan: "") // excludes empty string
            .count()
            .get();
    final completed = completedSnap.count ?? 0;

    final pending = total - completed;

    return VoterCensusStats(
      totalVoters: total,
      completedVoters: completed,
      pendingVoters: pending,
    );
  }

  @override
  Future<List<AgeGroupStats>> getAgeGroupStatsCount({
    int? boothId,
    int? wardId,
    int? constituencyId,
  }) async {
    CollectionReference records = _firestore.collection("records");

    Query baseQuery = records;
    if (boothId != null) {
      baseQuery = baseQuery.where("bhag_no", isEqualTo: boothId);
    }
    if (constituencyId != null) {
      baseQuery = baseQuery.where("assembly", isEqualTo: constituencyId);
    }

    final queries = await Future.wait([
      baseQuery
          .where("age", isGreaterThanOrEqualTo: 18)
          .where("age", isLessThanOrEqualTo: 25)
          .count()
          .get(),
      baseQuery
          .where("age", isGreaterThanOrEqualTo: 26)
          .where("age", isLessThanOrEqualTo: 40)
          .count()
          .get(),
      baseQuery
          .where("age", isGreaterThanOrEqualTo: 41)
          .where("age", isLessThanOrEqualTo: 60)
          .count()
          .get(),
      baseQuery.where("age", isGreaterThanOrEqualTo: 61).count().get(),
      baseQuery.where("age", isLessThan: 18).count().get(),
    ]);

    int g18to25 = queries[0].count ?? 0;
    int g26to40 = queries[1].count ?? 0;
    int g41to60 = queries[2].count ?? 0;
    int g61plus = queries[3].count ?? 0;
    int under18 = queries[4].count ?? 0;

    int total = g18to25 + g26to40 + g41to60 + g61plus + under18;

    List<AgeGroupStats> stats = [];

    if (under18 > 0) {
      stats.add(
        AgeGroupStats(
          label: "Under 18",
          count: under18,
          percentage: total > 0 ? (under18 / total) * 100 : 0,
        ),
      );
    }

    stats.addAll([
      AgeGroupStats(
        label: "18-25",
        count: g18to25,
        percentage: total > 0 ? (g18to25 / total) * 100 : 0,
      ),
      AgeGroupStats(
        label: "26-40",
        count: g26to40,
        percentage: total > 0 ? (g26to40 / total) * 100 : 0,
      ),
      AgeGroupStats(
        label: "41-60",
        count: g41to60,
        percentage: total > 0 ? (g41to60 / total) * 100 : 0,
      ),
      AgeGroupStats(
        label: "61+",
        count: g61plus,
        percentage: total > 0 ? (g61plus / total) * 100 : 0,
      ),
    ]);

    return stats;
  }

  @override
  Future<List<ReligionGroupStats>> getReligionGroupStatsCount({
    int? boothId,
    int? wardId,
    int? constituencyId,
  }) async {
    CollectionReference records = _firestore.collection("records");

    Query baseQuery = records;
    if (boothId != null) {
      baseQuery = baseQuery.where("bhag_no", isEqualTo: boothId);
    }
    if (constituencyId != null) {
      baseQuery = baseQuery.where("assembly", isEqualTo: constituencyId);
    }

    // Total voters count
    final totalSnap = await baseQuery.count().get();
    final total = totalSnap.count ?? 0;

    // Example: Fetch religions from config
    final religions =
        await getReligions(); // assume List<Religion> with {name, value, color}

    List<ReligionGroupStats> result = [];
    int knownTotal = 0;
    Religion? otherReligion;

    for (var religion in religions) {
      if (religion.value == "other") {
        otherReligion = religion;
        continue; // skip now
      }

      final snap =
          await baseQuery
              .where("religion", isEqualTo: religion.value)
              .count()
              .get();
      final count = snap.count ?? 0;
      knownTotal += count;

      result.add(
        ReligionGroupStats(
          label: religion.name,
          count: count,
          color: religion.color,
          percentage: total > 0 ? (count / total) * 100 : 0,
        ),
      );
    }

    // Add "Other"
    final otherCount = total - knownTotal;
    result.add(
      ReligionGroupStats(
        label: "Other",
        count: otherCount,
        color: otherReligion?.color ?? "#ffffff",
        percentage: total > 0 ? (otherCount / total) * 100 : 0,
      ),
    );

    return result;
  }

  // Helper method to convert age group label to numeric range
  Map<String, int>? _getAgeRange(String ageGroup) {
    switch (ageGroup) {
      case '18-25':
        return {'min': 18, 'max': 25};
      case '26-40':
        return {'min': 26, 'max': 40};
      case '41-60':
        return {'min': 41, 'max': 60};
      case '61+':
        return {'min': 61, 'max': 150}; // Using 150 as a reasonable upper limit
      default:
        return null;
    }
  }
}
