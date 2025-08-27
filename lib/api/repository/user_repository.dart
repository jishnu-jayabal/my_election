import 'package:election_mantra/api/models/age_group_stats.dart';
import 'package:election_mantra/api/models/filter_model.dart';
import 'package:election_mantra/api/models/party_census_stats.dart';
import 'package:election_mantra/api/models/political_groups.dart';
import 'package:election_mantra/api/models/religion.dart';
import 'package:election_mantra/api/models/religion_group_stats.dart';
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
    int? limit
  });

  //Voter List By Filter
    Future<List<VoterDetails>> getVotersByFilter({
    int? boothId,
    int? wardId,
    int? constituencyId,
  required  FilterModel filter
  });
  // Aggregated Insights
  Future<Map<String, PartyCensusStats>> getPartySupportPercentage({
    int? boothId,
    int? wardId,
    int? constituencyId,
  });

  Future<List<PoliticalGroups>> getPoliticalGroups();
  Future<List<Religion>> getReligions();

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

   Future<List<ReligionGroupStats>> getReligionGroupStats({
    int? boothId,
    int? wardId,
    int? constituencyId,
  });
}
