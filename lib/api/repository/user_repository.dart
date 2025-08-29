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
    int? limit,
    String? searchTerm,
  });
  
  Future<void> updateVoter(VoterDetails voterDetails);

  //Voter List By Filter
  Future<List<VoterDetails>> getVotersByFilter({
    int? boothId,
    int? wardId,
    int? constituencyId,
    required FilterModel filter,
  });

  Future<List<PoliticalGroups>> getPoliticalGroups();
  Future<List<Religion>> getReligions();
  Future<List<Education>> getEducation();
  Future<List<Gender>> getGender();
  Future<List<VoterType>> getVoterType();
  Future<List<VoterConcern>> getVoterConcern();
  Future<List<StayingStatus>> getStayingStatus();


  // Aggregated Insights
 @override
  Future<PartyCensusStats> getPartySupportCount({
    int? boothId,
    int? wardId,
    int? constituencyId,
  });

  /// Get voters census statistics (total, completed, pending)
  Future<VoterCensusStats> getVoterCensusStatsCount({
    int? boothId,
    int? wardId,
    int? constituencyId,
  });

  // Get Voter census statistic
  Future<List<AgeGroupStats>> getAgeGroupStatsCount({
    int? boothId,
    int? wardId,
    int? constituencyId,
  });

  Future<List<ReligionGroupStats>> getReligionGroupStatsCount({
    int? boothId,
    int? wardId,
    int? constituencyId,
  });
}
