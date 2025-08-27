import 'package:election_mantra/api/models/age_group_stats.dart';
import 'package:election_mantra/api/models/party_census_stats.dart';
import 'package:election_mantra/api/models/political_groups.dart';
import 'package:election_mantra/api/models/voter.dart';
import 'package:election_mantra/api/models/voters_census_stats.dart';
import 'package:get_it/get_it.dart';
import 'package:election_mantra/api/models/user.dart';
import 'package:election_mantra/api/repository/user_repository.dart';

/// Provides common access to user-related APIs.
class ApiBridge {
  final UserRepository _userRepository = GetIt.I<UserRepository>();

  ApiBridge();


  /// Send OTP to the specified phone number.
  Future<void> sendOtp(String phoneNumber) {
    return _userRepository.sendOtp(phoneNumber: phoneNumber);
  }

  /// Verify OTP using verification ID and code.
  Future<void> verifyOtp(String otp, {bool forReauth = false}) {
    return _userRepository.verifyOtp(otp: otp, forReauth: forReauth);
  }

  /// Sign out the current user.
  Future<void> signOut() {
    return _userRepository.signOut();
  }

  /// Get current user's ID.
  String? getCurrentUserId() {
    return _userRepository.getCurrentUserId();
  }

  /// Get current user's phone number.
  String? getCurrentPhoneNumber() {
    return _userRepository.getCurrentPhoneNumber();
  }

  /// Fetch the user profile.
  Future<User?> getUserProfile() {
    return _userRepository.getUserProfile();
  }

  
  Future<List<VoterDetails>> getVoters({
    int? boothId,
    int? wardId,
    int? constituencyId,
  }){
    return _userRepository.getVoters(
      boothId: boothId,
      constituencyId: constituencyId,
      wardId: wardId
    );
  }

    Future<List<PoliticalGroups>> getPoliticalGroups() async {
      return _userRepository.getPoliticalGroups();
    }

  Future<Map<String, PartyCensusStats>> getPartySupportPercentage({
    int? boothId,
    int? wardId,
    int? constituencyId,
  }) {
    return _userRepository.getPartySupportPercentage(
      boothId: boothId,
      constituencyId: constituencyId,
      wardId: wardId
    );
  }

  Future<VoterCensusStats> getVoterCensusStats({
    int? boothId,
    int? wardId,
    int? constituencyId,
  }){
    return  _userRepository.getVoterCensusStats(
      boothId: boothId,
      constituencyId: constituencyId,
      wardId: wardId
    );
  }

    Future<List<AgeGroupStats>> getAgeGroupStats({
    int? boothId,
    int? wardId,
    int? constituencyId,
  }) async {
    return _userRepository.getAgeGroupStats(
      boothId: boothId,
      constituencyId: constituencyId,
      wardId: wardId
    );
  }
}
