import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:election_mantra/api/models/voter_details.dart';

class DownloadService {
  /// Downloads voter data as Excel file
   Future<void> downloadExcel(List<VoterDetails> voters) async {
    if (voters.isEmpty) {
      throw Exception('No voters data to export');
    }

    try {
      // Create Excel workbook and sheet
      final excel = Excel.createExcel();
      final sheet = excel['Voters'];

      // Create header row using VoterDetails property names
      sheet.appendRow([
        'Serial No',
        'Name',
        'Guardian Name',
        'House Name',
        'Gender',
        'Age',
        'Voter ID',
        'Polling Station',
        'Religion',
        'Caste',
        'Vote Type',
        'Is Sure Vote',
        'Is Staying Outside',
        'Staying Location',
        'Staying Status',
        'Influencer',
        'Education',
        'Occupation',
        'Mobile No',
        'State',
        'District',
        'Block',
        'Panchayath',
        'Assembly',
        'Local Body Type',
        'Party',
        'Voter Concern',
        'Voted',
        'Bhag No',
        'Created At',
        'Updated At',
        'Updated By',
      ]);

      // Add data rows
      for (var voter in voters) {
        sheet.appendRow([
          voter.serialNo,
          voter.name,
          voter.guardianName,
          voter.houseName,
          voter.gender,
          voter.age,
          voter.voterId,
          voter.pollingStation,
          voter.religion,
          voter.caste,
          voter.voteType,
          voter.isSureVote ? 'Yes' : 'No',
          voter.isStayingOutside ? 'Yes' : 'No',
          voter.stayingLocation,
          voter.stayingStatus,
          voter.influencer,
          voter.education,
          voter.occupation,
          voter.mobileNo,
          voter.state,
          voter.district,
          voter.block,
          voter.panchayath,
          voter.assembly,
          voter.locBodyType,
          voter.party,
          voter.voterConcern,
          voter.voted ? 'Yes' : 'No',
          voter.bhagNo,
          voter.createdAt.toString(),
          voter.updatedAt?.toString() ?? '',
          voter.updatedBy ?? '',
        ]);
      }

      // Encode Excel to bytes
      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('Failed to encode Excel file');
      }

      // Get directory for saving
      final directory = await _getSaveDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/voters_export_$timestamp.xlsx';
      
      // Save file
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Open the file
      await OpenFile.open(filePath);

      print('Excel file saved at: $filePath');

    } catch (e) {
      print('Error exporting Excel: $e');
      throw Exception('Failed to export Excel: $e');
    }
  }

  /// Helper method to get the best directory for saving files
  static Future<Directory> _getSaveDirectory() async {
    try {
      // Try external storage first (for downloads folder)
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        final downloadsDir = Directory('${externalDir.path}/Download');
        if (await downloadsDir.exists()) {
          return downloadsDir;
        } else {
          await downloadsDir.create(recursive: true);
          return downloadsDir;
        }
      }
    } catch (e) {
      print('External storage access failed: $e');
    }

    try {
      // Fallback to application documents directory
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      print('Application documents access failed: $e');
      
      // Final fallback to temporary directory
      return await getTemporaryDirectory();
    }
  }

  /// Alternative method that returns the file path for custom handling
  static Future<String> exportToExcel(List<VoterDetails> voters) async {
    if (voters.isEmpty) {
      throw Exception('No voters data to export');
    }

    final excel = Excel.createExcel();
    final sheet = excel['Voters'];

    // Header row
    sheet.appendRow([
      'Serial No',
      'Name',
      'Guardian Name',
      'House Name',
      'Gender',
      'Age',
      'Voter ID',
      'Polling Station',
      'Religion',
      'Caste',
      'Vote Type',
      'Is Sure Vote',
      'Is Staying Outside',
      'Staying Location',
      'Staying Status',
      'Influencer',
      'Education',
      'Occupation',
      'Mobile No',
      'State',
      'District',
      'Block',
      'Panchayath',
      'Assembly',
      'Local Body Type',
      'Party',
      'Voter Concern',
      'Voted',
      'Bhag No',
      'Created At',
      'Updated At',
      'Updated By',
    ]);

    // Data rows
    for (var voter in voters) {
      sheet.appendRow([
        voter.serialNo,
        voter.name,
        voter.guardianName,
        voter.houseName,
        voter.gender,
        voter.age,
        voter.voterId,
        voter.pollingStation,
        voter.religion,
        voter.caste,
        voter.voteType,
        voter.isSureVote ? 'Yes' : 'No',
        voter.isStayingOutside ? 'Yes' : 'No',
        voter.stayingLocation,
        voter.stayingStatus,
        voter.influencer,
        voter.education,
        voter.occupation,
        voter.mobileNo,
        voter.state,
        voter.district,
        voter.block,
        voter.panchayath,
        voter.assembly,
        voter.locBodyType,
        voter.party,
        voter.voterConcern,
        voter.voted ? 'Yes' : 'No',
        voter.bhagNo,
        voter.createdAt.toString(),
        voter.updatedAt?.toString() ?? '',
        voter.updatedBy ?? '',
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('Failed to encode Excel file');
    }

    final directory = await _getSaveDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${directory.path}/voters_export_$timestamp.xlsx';
    
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }
}