part of 'download_excel_pd_bloc.dart';

@immutable
sealed class DownloadExcelPdEvent {}

class DownloadExcelEvent extends DownloadExcelPdEvent {
  final List<VoterDetails> voterDetails;
  DownloadExcelEvent({
    required this.voterDetails
  });
}