import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:election_mantra/api/models/voter_details.dart';

class DownloadService {
  static const Map<String, String> _propertyDisplayNames = {
    'serialNo': 'Serial No',
    'name': 'Name',
    'guardianName': 'Guardian Name',
    'houseName': 'House Name',
    'gender': 'Gender',
    'age': 'Age',
    'voterId': 'Voter ID',
    'pollingStation': 'Polling Station',
    'religion': 'Religion',
    'caste': 'Caste',
    'voteType': 'Vote Type',
    'isSureVote': 'Is Sure Vote',
    'isStayingOutside': 'Is Staying Outside',
    'stayingLocation': 'Staying Location',
    'stayingStatus': 'Staying Status',
    'influencer': 'Influencer',
    'education': 'Education',
    'occupation': 'Occupation',
    'mobileNo': 'Mobile No',
    'state': 'State',
    'district': 'District',
    'block': 'Block',
    'panchayath': 'Panchayath',
    'assembly': 'Assembly',
    'locBodyType': 'Local Body Type',
    'party': 'Party',
    'voterConcern': 'Voter Concern',
    'voted': 'Voted',
    'bhagNo': 'Bhag No',
    'createdAt': 'Created At',
    'updatedAt': 'Updated At',
    'updatedBy': 'Updated By',
  };

  /// Downloads voter data as Excel file to Downloads folder
   Future<File> downloadExcel(List<VoterDetails> voters, {String? fileName}) async {
    if (voters.isEmpty) {
      throw Exception('No voters data to export');
    }

    try {
      final excel = Excel.createExcel();
      final sheet = excel['Voters'];

      // Get headers from property map
      final headers = _getHeaders();
      sheet.appendRow(headers);

      // Add data rows
      for (var voter in voters) {
        final rowData = _getVoterRowData(voter);
        sheet.appendRow(rowData);
      }

      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('Failed to encode Excel file');
      }

      // Get Downloads directory
      final directory = await _getDownloadsDirectory();
      
      // Create filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalFileName = fileName ?? 'voters_export_$timestamp.xlsx';
      final filePath = '${directory.path}/$finalFileName';
      
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      print('Excel file saved at: $filePath');
      return file;

    } catch (e) {
      print('Error exporting Excel: $e');
      throw Exception('Failed to export Excel: $e');
    }
  }

  /// Get the Downloads directory for Android
  static Future<Directory> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      try {
        // For Android, use the Downloads directory
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final downloadsDir = Directory('${directory.path}/Download');
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
          return downloadsDir;
        }
      } catch (e) {
        print('Failed to access Downloads directory: $e');
        // Fallback to external storage
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          return externalDir;
        }
      }
    }
    
    // For iOS or fallback, use documents directory
    try {
      return await getApplicationDocumentsDirectory();
    } catch (e) {
      return await getTemporaryDirectory();
    }
  }

  /// Get headers from property map
  static List<String> _getHeaders() {
    return _propertyDisplayNames.values.toList();
  }

  /// Get row data for a voter
  static List<dynamic> _getVoterRowData(VoterDetails voter) {
    return [
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
    ];
  }

  /// Open the downloaded file
  static Future<void> openDownloadedFile(File file) async {
    try {
      await OpenFile.open(file.path);
    } catch (e) {
      print('Failed to open file: $e');
      throw Exception('Failed to open file: $e');
    }
  }

  /// Check if a file exists in Downloads
  static Future<bool> fileExistsInDownloads(String fileName) async {
    try {
      final directory = await _getDownloadsDirectory();
      final file = File('${directory.path}/$fileName');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get list of exported files in Downloads
  static Future<List<File>> getExportedFiles() async {
    try {
      final directory = await _getDownloadsDirectory();
      final files = await directory.list().where((entity) {
        return entity is File && entity.path.endsWith('.xlsx');
      }).toList();
      
      return files.cast<File>();
    } catch (e) {
      return [];
    }
  }
}