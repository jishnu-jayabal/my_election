import 'package:election_mantra/app_routes.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if(state is LoginInitial){
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route)=>false);
        }
      },
      child: AppBar(
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
        backgroundColor: Colors.blueAccent,
        centerTitle: false,
        elevation: 4,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        // ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.cloud_download,
              color: Colors.white.withOpacity(0.9),
            ),
            tooltip: "Download Data",
          ),
          GestureDetector(
            onTap: () => _showProfileDialog(context),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const CircleAvatar(radius: 16,
              child: Icon(Icons.person),
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginSuccessState) {
                return Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: CircleAvatar(radius: 40)),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          state.user.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if(state.user.constituencyNo != null)
                      Center(
                        child: Text(
                          'Constituency No : ${state.user.constituencyNo.toString()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Booth No : ${state.user.boothNo.toString()}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildProfileOption(Icons.person, "View Profile", () {
                        Navigator.pop(context);
                        // Navigate to profile page
                      }),
                      _buildProfileOption(Icons.settings, "Settings", () {
                        Navigator.pop(context);
                        // Navigate to settings page
                      }),
                      _buildProfileOption(Icons.help, "Help & Support", () {
                        Navigator.pop(context);
                        // Navigate to help page
                      }),
                      const Divider(height: 24),
                      _buildProfileOption(Icons.logout, "Logout", () {
                        BlocProvider.of<LoginBloc>(context).add(LogoutEvent());
                        Navigator.pop(context);
                        // Handle logout
                      }, color: Colors.red),
                    ],
                  ),
                );
              }
              return SizedBox();
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String text,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? Colors.blueAccent),
      title: Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
