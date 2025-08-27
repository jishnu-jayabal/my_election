import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election_mantra/api/models/age_group_stats.dart';
import 'package:election_mantra/api/models/party_census_stats.dart';
import 'package:election_mantra/api/models/political_groups.dart';
import 'package:election_mantra/api/models/user.dart';
import 'package:election_mantra/api/models/voter.dart';
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
        print("otp sent");
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
  }) async {
    Query query = _firestore.collection('records');

    // ⚡ Match Firestore fields correctly
    if (boothId != null) {
      query = query
          .where('bhag_no', isEqualTo: boothId)
          .orderBy('serial_no')
          .limit(5);
    }
    if (constituencyId != null) {
      query = query
          .where('assembly', isEqualTo: constituencyId)
          .orderBy('serial_no');
    }
    // wardId not available currently

    final snapshot = await query.get();

    return snapshot.docs
        .map(
          (doc) =>
              VoterDetails.fromJson(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
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
  Future<Map<String, PartyCensusStats>> getPartySupportPercentage({
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

    // Get total voters count
    final totalSnap = await query.count().get();
    final total = totalSnap.count;

    if (total == 0) return {};

    // Get grouped party counts
    final partyCounts = <String, int>{};

    final snap = await query.get();
    for (var doc in snap.docs) {
      final data = doc.data();
      final party =
          (data['party'] ?? "").toString().isNotEmpty
              ? data['party']
              : "Undecided";

      partyCounts[party] = (partyCounts[party] ?? 0) + 1;
    }

    // Convert to map where party name is the key
    final result = <String, PartyCensusStats>{};
    partyCounts.forEach((party, count) {
      result[party] = PartyCensusStats(
        party: party,
        count: count,
        percentage: (count / total!) * 100,
      );
    });

    return result;
  }

  /// Get voters census statistics (total, completed, pending)
  @override
  Future<VoterCensusStats> getVoterCensusStats({
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
  Future<List<AgeGroupStats>> getAgeGroupStats({
    int? boothId,
    int? wardId,
    int? constituencyId,
  }) async {
    Query baseQuery = _firestore.collection('records');

    if (boothId != null) {
      baseQuery = baseQuery.where('bhag_no', isEqualTo: boothId);
    }
    if (constituencyId != null) {
      baseQuery = baseQuery.where('assembly', isEqualTo: constituencyId);
    }


    final results = await Future.wait([
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
      baseQuery.where("age", isNull: true).count().get(), // unknown
    ]);

    final g18to25 = results[0].count ?? 0;
    final g26to40 = results[1].count ?? 0;
    final g41to60 = results[2].count ?? 0;
    final g61plus = results[3].count ?? 0;
    final unknown = results[4].count ?? 0;

    final total = g18to25 + g26to40 + g41to60 + g61plus + unknown;

    List<AgeGroupStats> stats = [
      AgeGroupStats(
        label: "18-25",
        count: g18to25,
        percentage: (g18to25 / total) * 100,
      ),
      AgeGroupStats(
        label: "26-40",
        count: g26to40,
        percentage: (g26to40 / total) * 100,
      ),
      AgeGroupStats(
        label: "41-60",
        count: g41to60,
        percentage: (g41to60 / total) * 100,
      ),
      AgeGroupStats(
        label: "61+",
        count: g61plus,
        percentage: (g61plus / total) * 100,
      ),
      AgeGroupStats(
        label: "Unknown",
        count: unknown,
        percentage: (unknown / total) * 100,
      ),
    ];

    return stats;
  }
}
