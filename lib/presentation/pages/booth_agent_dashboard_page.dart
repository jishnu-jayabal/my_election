import 'package:election_mantra/api/models/religion.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/age_group_stats_count/age_group_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_list/party_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_stats_count/party_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/religion/religion_bloc.dart';
import 'package:election_mantra/presentation/blocs/religion_group_stats_count/religion_group_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/startup/startup_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_stats_count/voters_stats_bloc.dart';
import 'package:election_mantra/presentation/cubit/cubit/filter_cubit.dart';
import 'package:election_mantra/presentation/widgets/age_group_stats_widget.dart';
import 'package:election_mantra/presentation/widgets/age_wise_section.dart';
import 'package:election_mantra/presentation/widgets/header.dart';
import 'package:election_mantra/presentation/widgets/party_census_stats_widget.dart';
import 'package:election_mantra/presentation/widgets/religion_wise_section.dart';
import 'package:election_mantra/presentation/widgets/side_menu.dart';
import 'package:election_mantra/presentation/widgets/voters_census_stats_widget.dart';
import 'package:election_mantra/presentation/widgets/voters_list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoothAgentDashboard extends StatefulWidget {
  const BoothAgentDashboard({super.key});

  @override
  State<BoothAgentDashboard> createState() => _BoothAgentDashboardState();
}

class _BoothAgentDashboardState extends State<BoothAgentDashboard> {
  int _currentIndex = 0;
  final String constituency = "Thiruvananthapuram South";

  @override
  void initState() {
    super.initState();
    // ✅ If already logged in when widget builds, load data once
    final loginState = context.read<LoginBloc>().state;
    if (loginState is LoginSuccessState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerDataLoads(context, boothId: 2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      drawer: SideMenu(),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            _triggerDataLoads(context, boothId: 2);
          }
        },
        child: _getCurrentScreen(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  void _triggerDataLoads(BuildContext context, {required int boothId}) {
    context.read<VotersStatsBloc>().add(
      FetchVotersStatsEvent(boothId: boothId),
    );
    context.read<PartyListBloc>().add(FetchPartyListEvent());
    context.read<ReligionBloc>().add(FetchReligionEvent());
    context.read<PartyStatsBloc>().add(FetchPartysStatsEvent(boothId: boothId));
    context.read<ReligionGroupStatsBloc>().add(
      FetchReligionGroupStatsEvent(boothId: boothId),
    );
    context.read<AgeGroupStatsBloc>().add(
      FetchAgeGroupStatsEvent(boothId: boothId),
    );
    context.read<VotersListBloc>().add(FetchVotersListEvent(boothId: boothId));
    context.read<StartupBloc>().add(FetchStartupEvent());
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardView();
      case 1:
        return _buildAgeWiseView();
      case 2:
        return _buildReligionWise();
      case 3:
        return _buildVoterListView();
      default:
        return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    return CustomScrollView(
      slivers: [
        // Constituency info below app bar
        SliverToBoxAdapter(
          child: Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.blue[700]),
                const SizedBox(width: 4),
                Text(
                  constituency,
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Stats section
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          sliver: _buildVotersCensusStats(),
        ),

        // Party counts section
        _buildPartyCensusStatus(),

        // Quick stats header
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: 8,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quick Stats",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: const Text("View All"),
                ),
              ],
            ),
          ),
        ),

        // Age groups
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          sliver: _buildAgeGroupStats(),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildAgeWiseView() {
    return AgeWiseSection();
  }

  Widget _buildReligionWise() {
    return ReligionWiseSection();
  }

  Widget _buildVoterListView() {
    return VotersListSection();
  }

  Widget _buildAgeGroupStats() {
    return AgeGroupStatsWidget();
  }

  Widget _buildVotersCensusStats() {
    return VotersCensusStatsWidget(
      onPendingClicked: () {
        BlocProvider.of<FilterCubit>(context).updateStatus("pending");
        setState(() {
          _currentIndex = 3;
        });
      },
      onCompletedClicked: () {
        BlocProvider.of<FilterCubit>(context).updateStatus("completed");
        setState(() {
          _currentIndex = 3;
        });
      },
      onTotalVoterClicked: () {
        BlocProvider.of<FilterCubit>(context).updateStatus("");
        setState(() {
          _currentIndex = 3;
        });
      },
    );
  }

  Widget _buildPartyCensusStatus() {
    return PartyCensusStatsWidget(
      onPartyChipClicked: (partyName) {
        BlocProvider.of<FilterCubit>(context).updateAffiliation(partyName);
        setState(() {
          _currentIndex = 3;
        });
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.cake), label: 'Age Wise'),
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          label: 'Religion Wise',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Voter List'),
      ],
    );
  }
}
