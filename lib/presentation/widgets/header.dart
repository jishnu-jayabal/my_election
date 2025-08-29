import 'package:election_mantra/app_routes.dart';
import 'package:election_mantra/core/constant/palette.dart';
import 'package:election_mantra/presentation/blocs/download_excel_pdf/download_excel_pd_bloc.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final bool showDownloadButton;
  const Header({super.key, required this.showDownloadButton});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginInitial) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            }
          },
        ),
        BlocListener<DownloadExcelPdBloc, DownloadExcelPdState>(
          listener: (context, state) {
            if (state is DownloadExcelPdfSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Download completed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is DownloadExcelPdFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Download failed: ${state.msg}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: AppBar(
        foregroundColor: Palette.white,
        title: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginSuccessState) {
              return Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          "BOOTH NO ${state.user.boothNo}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
        backgroundColor: Palette.primary,
        centerTitle: false,
        elevation: 4,
        actions: [
          if (showDownloadButton)
            BlocBuilder<DownloadExcelPdBloc, DownloadExcelPdState>(
              builder: (context, state) {
                if (state is DownloadExcelPdLoading) {
                  // Show progress indicator when downloading
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // Show download button when not loading
                  return IconButton(
                    onPressed: () {
                      _showDownloadOptions(context);
                    },
                    icon: Icon(
                      Icons.download,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    tooltip: "Download Data",
                  );
                }
              },
            ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  void _showDownloadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<DownloadExcelPdBloc, DownloadExcelPdState>(
          builder: (context, state) {
            if (state is DownloadExcelPdLoading) {
              return Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text('Downloading...'),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Download Options',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDownloadOption(
                        context,
                        icon: Icons.table_chart,
                        title: 'Excel',
                        onTap: () {
                          Navigator.pop(context);
                          _downloadExcel(context);
                        },
                        color: Colors.green,
                      ),
                      _buildDownloadOption(
                        context,
                        icon: Icons.picture_as_pdf,
                        title: 'PDF',
                        onTap: () {
                          Navigator.pop(context);
                          _downloadPdf(context);
                        },
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDownloadOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }

  void _downloadExcel(BuildContext context) {
    if (BlocProvider.of<VotersListBloc>(context).state is VotersListSuccess) {
      VotersListSuccess votersListSuccess =
          BlocProvider.of<VotersListBloc>(context).state as VotersListSuccess;
      BlocProvider.of<DownloadExcelPdBloc>(
        context,
      ).add(DownloadExcelEvent(voterDetails: votersListSuccess.voters));
    }
  }

  void _downloadPdf(BuildContext context) {
    if (BlocProvider.of<VotersListBloc>(context).state is VotersListSuccess) {
      VotersListSuccess votersListSuccess =
          BlocProvider.of<VotersListBloc>(context).state as VotersListSuccess;
      BlocProvider.of<DownloadExcelPdBloc>(
        context,
      ).add(DownloadPdfEvent(voterDetails: votersListSuccess.voters));
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
