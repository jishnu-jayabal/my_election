import 'package:election_mantra/api/models/filter_model.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/age_group_stats/age_group_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/house_list/house_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_list/party_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_stats/party_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/religion/religion_bloc.dart';
import 'package:election_mantra/presentation/blocs/religion_group_stats/religion_group_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/startup/startup_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_stats_count/voters_stats_bloc.dart';
import 'package:election_mantra/presentation/cubit/cubit/filter_cubit.dart';
import 'package:election_mantra/presentation/widgets/header.dart';
import 'package:election_mantra/presentation/widgets/house_list_section.dart';
import 'package:election_mantra/presentation/widgets/party_census_stats_widget.dart';
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
  bool isNetwork = false;

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
      appBar: Header(
        showDownloadButton: (_currentIndex == 2 || _currentIndex == 3),
      ),
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
    context.read<PartyListBloc>().add(FetchPartyListEvent());
    context.read<ReligionBloc>().add(FetchReligionEvent());
    context.read<StartupBloc>().add(FetchStartupEvent());

    context.read<VotersListBloc>().add(FetchVotersListEvent(boothId: boothId));
    context.read<VotersStatsBloc>().add(
      FetchVotersStatsEventNetwork(boothId: boothId),
    );
    context.read<PartyStatsBloc>().add(
      FetchPartysStatsEventNetwork(boothId: boothId),
    );
    context.read<ReligionGroupStatsBloc>().add(
      FetchReligionGroupStatsEventNetwork(boothId: boothId),
    );
    context.read<AgeGroupStatsBloc>().add(
      FetchAgeGroupStatsEvent(boothId: boothId),
    );
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardView();
      case 1:
        return _buildPollingDays();
      case 2:
        return _buildHouseWiseView();
      case 3:
        return _buildVoterListView();
      default:
        return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    return BlocBuilder<VotersListBloc, VotersListState>(
      builder: (context, state) {
        if (state is VotersListSuccess) {
          final allVoters = context.read<VotersListBloc>().allVoters;
          //Local
          BlocProvider.of<HouseListBloc>(
            context,
          ).add(FetchHouseListEventLocal(voters: allVoters));
          final loginSuccessState =
              context.read<LoginBloc>().state as LoginSuccessState;
          final partyListSuccess =
              context.read<PartyListBloc>().state as PartyListSuccess;
          final religionSuccess =
              context.read<ReligionBloc>().state as ReligionSuccess;
          context.read<VotersStatsBloc>().add(
            FetchVotersStatsEventLocal(
              boothId: loginSuccessState.user.boothNo,
              allVoters: allVoters,
            ),
          );
          context.read<PartyStatsBloc>().add(
            FetchPartysStatsEventLocal(
              boothId: loginSuccessState.user.boothNo,
              allVoters: allVoters,
              politicalGroups: partyListSuccess.politicalGroups,
            ),
          );
          context.read<ReligionGroupStatsBloc>().add(
            FetchReligionGroupStatsLocal(
              boothId: loginSuccessState.user.boothNo,
              allVoters: allVoters,
              religions: religionSuccess.religions,
            ),
          );

          return CustomScrollView(
            slivers: [
              // Constituency info below app bar
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.blue[50],
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.blue[700],
                      ),
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
                        "Party Percentage",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              PartyCensusStatsWidget(
                onPartyChipClicked: (value) {},
                isCardMode: true,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          );
        }
        return Center(child: Util.shimmerCircle());
      },
    );
  }

  Widget _buildPollingDays() {
    return Center(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 150, color: Colors.grey),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25.0,
                horizontal: 30.0,
              ),
              child: Text(
                "🚧 App Under Maintenance 🚧 We're making things better! Please check back soon.",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseWiseView() {
    return HouseListSection();
  }

  Widget _buildVoterListView() {
    return VotersListSection();
  }

  Widget _buildVotersCensusStats() {
    return VotersCensusStatsWidget(
      onPendingClicked: () {
        _navigateToVoterListWithFilter(
          context,
          (cubit) => cubit.updateTemporaryFilter(status: "pending"),
        );
      },
      onCompletedClicked: () {
        _navigateToVoterListWithFilter(
          context,
          (cubit) => cubit.updateTemporaryFilter(status: "completed"),
        );
      },
      onTotalVoterClicked: () {
        _navigateToVoterListWithFilter(
          context,
          (cubit) => cubit.updateTemporaryFilter(status: null),
        );
      },
    );
  }

  Widget _buildPartyCensusStatus() {
    return PartyCensusStatsWidget(
      onPartyChipClicked: (partyName) {
        _navigateToVoterListWithFilter(
          context,
          (cubit) => cubit.updateTemporaryFilter(affiliation: partyName),
        );
      },
    );
  }

  void _navigateToVoterListWithFilter(
    BuildContext context,
    void Function(FilterCubit) updateFilterCallback,
  ) {
    final cubit = context.read<FilterCubit>();

    // First reset temporary filters to initial state
    cubit.resetTemporaryFilters();

    // Then update with the new specific filter
    updateFilterCallback(cubit);

    // Apply the filters immediately
    cubit.applyTemporaryFilters();

    // Navigate to voter list
    setState(() {
      _currentIndex = 3;
    });

    // Trigger voter list reload with the new filters
    final appliedFilters = cubit.currentAppliedFilters;
    final loginSuccessState =
        context.read<LoginBloc>().state as LoginSuccessState;

    context.read<VotersListBloc>().add(
      FetchVoterListByFilterEventLocal(
        boothId: loginSuccessState.user.boothNo,
        constituencyId: loginSuccessState.user.constituencyNo,
        wardId: loginSuccessState.user.wardNo,
        filter: appliedFilters,
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 3) {
          // Clear all filters when navigating to Voter List
          context.read<FilterCubit>().clearAllAppliedFilters();

          // Reload voter list without filters
          final loginSuccessState =
              context.read<LoginBloc>().state as LoginSuccessState;
          context.read<VotersListBloc>().add(
            FetchVoterListByFilterEventLocal(
              boothId: loginSuccessState.user.boothNo,
              constituencyId: loginSuccessState.user.constituencyNo,
              wardId: loginSuccessState.user.wardNo,
              filter: FilterModel.initial(), // Empty filters
            ),
          );
        }

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
        BottomNavigationBarItem(icon: Icon(Icons.poll), label: 'Polling Day'),
        BottomNavigationBarItem(icon: Icon(Icons.house), label: 'House Wise'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Voter List'),
      ],
    );
  }
}
