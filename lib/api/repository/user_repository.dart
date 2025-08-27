import 'package:election_mantra/api/models/age_group_stats.dart';
import 'package:election_mantra/api/models/party_census_stats.dart';
import 'package:election_mantra/api/models/political_groups.dart';
import 'package:election_mantra/api/models/user.dart';
import 'package:election_mantra/api/models/voter.dart';
import 'package:election_mantra/api/models/voters_census_stats.dart';

/// Repository interface
abstract class UserRepository {
  //User Methods
  Future<void> sendOtp({required String phoneNumber});
  Future<void> verifyOtp({required String otp, bool forReauth});
  Future<void> signOut();
  String? getCurrentUserId();
  String? getCurrentPhoneNumber();
  Future<User?> getUserProfile();
  // Voter Raw Data
  Future<List<VoterDetails>> getVoters({
    int? boothId,
    int? wardId,
    int? constituencyId,
  });
  // Aggregated Insights
  Future<Map<String, PartyCensusStats>> getPartySupportPercentage({
    int? boothId,
    int? wardId,
    int? constituencyId,
  });

  Future<List<PoliticalGroups>> getPoliticalGroups();

  /// Get voters census statistics (total, completed, pending)
  Future<VoterCensusStats> getVoterCensusStats({
    int? boothId,
    int? wardId,
    int? constituencyId,
  });

  Future<List<AgeGroupStats>> getAgeGroupStats({
    int? boothId,
    int? wardId,
    int? constituencyId,
  });
}
