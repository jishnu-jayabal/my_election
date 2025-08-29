import 'package:bloc/bloc.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/core/platform/download_service.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'download_excel_pd_event.dart';
part 'download_excel_pd_state.dart';

class DownloadExcelPdBloc
    extends Bloc<DownloadExcelPdEvent, DownloadExcelPdState> {
  final DownloadService _downloadService = GetIt.I<DownloadService>();
  DownloadExcelPdBloc() : super(DownloadExcelPdInitial()) {
    on<DownloadExcelEvent>((event, emit) async {
      try {
        emit(DownloadExcelPdLoading());
        await _downloadService.downloadExcel(event.voterDetails);
        emit(DownloadExcelPdfSuccess());
      } catch (e) {
        emit(DownloadExcelPdFailure(msg: e.toString()));
      }
    });
 
    on<DownloadPdfEvent>((event,emit) async{
         try {
        emit(DownloadExcelPdLoading());
        await _downloadService.downloadPDF(event.voterDetails);
        emit(DownloadExcelPdfSuccess());
      } catch (e) {
        emit(DownloadExcelPdFailure(msg: e.toString()));
      }
    });
  }
}
