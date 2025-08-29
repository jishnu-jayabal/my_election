import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

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

  // Load a Malayalam font from assets
  static Future<pw.Font> _loadMalayalamFont() async {
    try {
      // Load the font data from assets
      final fontData = await rootBundle.load(
        'assets/fonts/NotoSansMalayalam.ttf',
      );
      return pw.Font.ttf(fontData);
    } catch (e) {
      print('Error loading Malayalam font: $e');
      // Fallback to default font if Malayalam font is not available
      return pw.Font.courier();
    }
  }

  /// Downloads voter data as Excel file to Download/electionmantra folder
  Future<File> downloadExcel(
    List<VoterDetails> voters, {
    String? fileName,
  }) async {
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

      // Get Downloads directory with electionmantra subfolder
      final directory = await _getElectionMantraDownloadsDirectory();

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

  /// Downloads voter data as PDF file to Download/electionmantra folder
  Future<File> downloadPDF(
    List<VoterDetails> voters, {
    String? fileName,
  }) async {
    if (voters.isEmpty) {
      throw Exception('No voters data to export');
    }

    try {
      // Load Malayalam font
      final malayalamFont = await _loadMalayalamFont();

      // Create PDF document
      final pdf = pw.Document(
        pageMode: PdfPageMode.fullscreen

      );

      // Calculate how many rows fit per page
      const rowsPerPage = 20; // Reduced to allow more space per row
      final totalPages = (voters.length / rowsPerPage).ceil();

      for (int page = 0; page < totalPages; page++) {
        final startIndex = page * rowsPerPage;
        final endIndex = (page + 1) * rowsPerPage;
        final pageVoters = voters.sublist(
          startIndex,
          endIndex > voters.length ? voters.length : endIndex,
        );

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a3.landscape,
            margin: const pw.EdgeInsets.all(10),
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  // Header with title and page number
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Voters List',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          font: malayalamFont,
                        ),
                      ),
                      pw.Text(
                        'Page ${page + 1} of $totalPages',
                        style: pw.TextStyle(fontSize: 10, font: malayalamFont),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),

                  // Excel-like table with improved layout
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: _getColumnWidths(),
                      children: [
                        // Table header row
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey300,
                          ),
                          children: _getHeaders().map((header) {
                            return pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(
                                header,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 6,
                                  font: malayalamFont,
                                ),
                                textAlign: _getHeaderAlignment(header),
                              ),
                            );
                          }).toList(),
                        ),

                        // Data rows
                        ...pageVoters.map((voter) {
                          final rowData = _getVoterRowData(voter);
                          return pw.TableRow(
                            children: rowData.asMap().entries.map((entry) {
                              final index = entry.key;
                              final cellData = entry.value;
                              return pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text(
                                  cellData?.toString() ?? '',
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    font: malayalamFont,
                                  ),
                                  textAlign: _getCellAlignment(index),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }

      // Save the PDF document to bytes
      final bytes = await pdf.save();

      // Get Downloads directory with electionmantra subfolder
      final directory = await _getElectionMantraDownloadsDirectory();

      // Create filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalFileName = fileName ?? 'voters_export_$timestamp.pdf';
      final filePath = '${directory.path}/$finalFileName';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      print('PDF file saved at: $filePath');
      return file;
    } catch (e) {
      print('Error exporting PDF: $e');
      throw Exception('Failed to export PDF: $e');
    }
  }

  // Define text alignment for header cells
  static pw.TextAlign _getHeaderAlignment(String header) {
    // Center align most headers, left align longer text headers
    final leftAlignHeaders = [
      'Name',
      'Guardian Name',
      'House Name',
      'Polling Station',
      'Staying Location',
      'Influencer',
      'Voter Concern',
      'Panchayath',
    ];
    
    return leftAlignHeaders.contains(header) 
        ? pw.TextAlign.left 
        : pw.TextAlign.center;
  }

  // Define text alignment for data cells based on column index
  static pw.TextAlign _getCellAlignment(int columnIndex) {
    // Columns that should be center aligned
    final centerAlignedColumns = [0, 4, 5, 6, 10, 11, 12, 26, 27, 28, 29, 30];
    
    return centerAlignedColumns.contains(columnIndex)
        ? pw.TextAlign.center
        : pw.TextAlign.left;
  }

  // Define column widths for the table
  static Map<int, pw.TableColumnWidth> _getColumnWidths() {
    return {
      0: const pw.FixedColumnWidth(100),  // Serial No
      1: const pw.FixedColumnWidth(200),  // Name
      2: const pw.FixedColumnWidth(200),  // Guardian Name
      3: const pw.FixedColumnWidth(130),  // House Name
      4: const pw.FixedColumnWidth(130),  // Gender
      5: const pw.FixedColumnWidth(100),  // Age
      6: const pw.FixedColumnWidth(150),  // Voter ID
      7: const pw.FixedColumnWidth(150),  // Polling Station
      8: const pw.FixedColumnWidth(130),  // Religion
      9: const pw.FixedColumnWidth(120),  // Caste
      10: const pw.FixedColumnWidth(120), // Vote Type
      11: const pw.FixedColumnWidth(130), // Is Sure Vote
      12: const pw.FixedColumnWidth(180), // Is Staying Outside
      13: const pw.FixedColumnWidth(180), // Staying Location
      14: const pw.FixedColumnWidth(130), // Staying Status
      15: const pw.FixedColumnWidth(170), // Influencer
      16: const pw.FixedColumnWidth(170), // Education
      17: const pw.FixedColumnWidth(170), // Occupation
      18: const pw.FixedColumnWidth(170), // Mobile No
      19: const pw.FixedColumnWidth(130), // State
      20: const pw.FixedColumnWidth(130), // District
      21: const pw.FixedColumnWidth(130), // Block
      22: const pw.FixedColumnWidth(150), // Panchayath
      23: const pw.FixedColumnWidth(130), // Assembly
      24: const pw.FixedColumnWidth(130), // Local Body Type
      25: const pw.FixedColumnWidth(100), // Party
      26: const pw.FixedColumnWidth(150), // Voter Concern
      27: const pw.FixedColumnWidth(120), // Voted
      28: const pw.FixedColumnWidth(150), // Bhag No
      29: const pw.FixedColumnWidth(200), // Created At
      30: const pw.FixedColumnWidth(200), // Updated At
      31: const pw.FixedColumnWidth(200), // Updated By
    };
  }

  /// Get the Download/electionmantra directory
  static Future<Directory> _getElectionMantraDownloadsDirectory() async {
    if (Platform.isAndroid) {
      try {
        Directory downloadDir = Directory('/storage/emulated/0/Download');

        final List<String> possiblePaths = [
          '/storage/emulated/0/Download',
          '/sdcard/Download',
          '/storage/sdcard0/Download',
          '/storage/sdcard1/Download',
        ];

        bool downloadDirFound = false;
        for (String path in possiblePaths) {
          final directory = Directory(path);
          if (await directory.exists()) {
            downloadDir = directory;
            downloadDirFound = true;
            break;
          }
        }

        if (!downloadDirFound) {
          final externalDir = await getExternalStorageDirectory();
          if (externalDir != null) {
            downloadDir = externalDir;
          } else {
            throw Exception('Could not access storage directory');
          }
        }

        final electionMantraDir = Directory(
          '${downloadDir.path}/electionmantra',
        );
        if (!await electionMantraDir.exists()) {
          await electionMantraDir.create(recursive: true);
        }

        return electionMantraDir;
      } catch (e) {
        print('Failed to access electionmantra directory: $e');
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          return externalDir;
        }
        return await getApplicationDocumentsDirectory();
      }
    }

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

  /// Check if a file exists in Download/electionmantra
  static Future<bool> fileExistsInDownloads(String fileName) async {
    try {
      final directory = await _getElectionMantraDownloadsDirectory();
      final file = File('${directory.path}/$fileName');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get list of exported files in Download/electionmantra
  static Future<List<File>> getExportedFiles() async {
    try {
      final directory = await _getElectionMantraDownloadsDirectory();
      final files = await directory.list().where((entity) {
        return entity is File &&
            (entity.path.endsWith('.xlsx') || entity.path.endsWith('.pdf'));
      }).toList();

      return files.cast<File>();
    } catch (e) {
      return [];
    }
  }
}