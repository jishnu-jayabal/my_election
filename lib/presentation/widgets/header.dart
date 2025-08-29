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
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginInitial) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      child: AppBar(
        foregroundColor: Palette.white,
        title: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginSuccessState) {
              return Row(
                children: [
                  // Booth icon and number on the right
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

                  // Constituency in the center
                ],
              );
            }
            return SizedBox();
          },
        ),
        backgroundColor: Palette.primary,
        centerTitle: false,
        elevation: 4,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        // ),
        actions: [
          if(showDownloadButton)
          IconButton(
            onPressed: () {
              VotersListSuccess votersListSuccess = BlocProvider.of<VotersListBloc>(context).state as VotersListSuccess;
              BlocProvider.of<DownloadExcelPdBloc>(context).add(DownloadExcelEvent(voterDetails: votersListSuccess.voters));
            },
            icon: Icon(
              Icons.download,
              color: Colors.white.withOpacity(0.9),
            ),
            tooltip: "Download Data",
          ),

          SizedBox(width: 10),
        ],
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
