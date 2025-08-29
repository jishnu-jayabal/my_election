part of 'download_excel_pd_bloc.dart';

@immutable
sealed class DownloadExcelPdEvent {}

class DownloadExcelEvent extends DownloadExcelPdEvent {
  final List<VoterDetails> voterDetails;
  DownloadExcelEvent({
    required this.voterDetails
  });
}

class DownloadPdfEvent extends DownloadExcelPdEvent {
  final List<VoterDetails> voterDetails;
  DownloadPdfEvent({
    required this.voterDetails
  });
}