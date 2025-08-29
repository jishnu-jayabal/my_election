part of 'download_excel_pd_bloc.dart';

@immutable
sealed class DownloadExcelPdState {}

final class DownloadExcelPdInitial extends DownloadExcelPdState {}
final class DownloadExcelPdLoading extends DownloadExcelPdState {}
final class DownloadExcelPdfSuccess extends DownloadExcelPdState {}
final class DownloadExcelPdFailure extends DownloadExcelPdState {
  final String msg;
  DownloadExcelPdFailure({required this.msg});
}