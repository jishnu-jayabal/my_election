import 'package:election_mantra/app_routes.dart';
import 'package:election_mantra/core/constant/palette.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Palette.primary,
      child: SafeArea(
        child: Container(
          // 🔹 Add background color here
          color: Palette.primary,
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginSuccessState) {
                final user = state.user;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Profile Section
                    UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(color: Palette.primary),
                      currentAccountPicture: const CircleAvatar(
                        radius: 30,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      accountName: Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      accountEmail: Text(
                        "Booth No: ${user.boothNo}  |  Constituency: ${user.constituencyNo ?? '-'}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),

                    // 🔹 Menu items (separate Container with white background)
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            _buildMenuItem(
                              icon: Icons.cake,
                              text: "Age Wise",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.ageWiseStatsView,
                                );
                              },
                            ),
                         
                            _buildMenuItem(
                              icon: Icons.cake,
                              text: "Religion Wise",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.religionWiseStatsView,
                                );
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.settings,
                              text: "Settings",
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            _buildMenuItem(
                              icon: Icons.help,
                              text: "Help & Support",
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Spacer(),
                            const Divider(),
                            _buildMenuItem(
                              icon: Icons.logout,
                              text: "Logout",
                              color: Colors.red,
                              onTap: () {
                                BlocProvider.of<LoginBloc>(
                                  context,
                                ).add(LogoutEvent());
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.login,
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              // If not logged in
              return const Center(child: Text("Not logged in"));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blueAccent),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
