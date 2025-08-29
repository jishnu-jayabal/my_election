import 'package:election_mantra/api/models/filter_model.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:election_mantra/presentation/cubit/cubit/filter_cubit.dart';
import 'package:election_mantra/presentation/widgets/applied_filter_widget.dart';
import 'package:election_mantra/presentation/widgets/filter_widget.dart';
import 'package:election_mantra/presentation/widgets/voter_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum VotersListSectionMode { full, recent }

class VotersListSection extends StatelessWidget {
  final VotersListSectionMode mode;
  const VotersListSection({super.key, this.mode = VotersListSectionMode.full});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (mode == VotersListSectionMode.full)
          // 🔹 Search bar (always visible)
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    BlocProvider.of<VotersListBloc>(
                      context,
                    ).add(SearchVoterListEvent(searchTerm: value));
                  },
                  decoration: InputDecoration(
                    hintText: "Search by name, voter ID, house...",
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.blueAccent,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
    
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder:
                                (context) => FilterWidget(
                                  onFiltersChanged: (map) {
                                    final loginSuccessState =
                                        BlocProvider.of<LoginBloc>(
                                              context,
                                            ).state
                                            as LoginSuccessState;
                                    BlocProvider.of<VotersListBloc>(
                                      context,
                                    ).add(
                                      //local filter decide later which to use
                                      FetchVoterListByFilterEventLocal(
                                        boothId:
                                            loginSuccessState.user.boothNo,
                                        constituencyId:
                                            loginSuccessState
                                                .user
                                                .constituencyNo,
                                        wardId: loginSuccessState.user.wardNo,
                                        filter: map,
                                      ),
                                    );
                                  },
                                ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                    ),
                  ),
                ),
              ),
            ),
          ),
    
        if (mode == VotersListSectionMode.full)
          SliverToBoxAdapter(child: AppliedFilterWidget()),
    
        if (mode == VotersListSectionMode.full)
          // 🔹 Voter list header (always visible)
          SliverPadding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
            sliver: SliverToBoxAdapter(
              child: BlocBuilder<VotersListBloc, VotersListState>(
                builder: (context, state) {
                  if (state is VotersListSuccess) {
                    return Text(
                      "All Voters (${state.voters.length})",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
    
        // 🔹 The actual list controlled by Bloc
        BlocBuilder<VotersListBloc, VotersListState>(
          builder: (context, state) {
            if (state is VotersListLoading) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Util.shimmerBox(
                        height: 120, // height similar to VoterCard
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                  childCount: 6, // show 6 shimmer cards
                ),
              );
            }
    
            if (state is VotersListFailure) {
              return const SliverFillRemaining(
                child: Center(child: Text("Failed to load voters")),
              );
            }
    
            if (state is VotersListSuccess) {
              final voters = state.voters;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final voter = voters[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: VoterCard(voterDetails: voter),
                    );
                  },
                  childCount:
                      mode == VotersListSectionMode.full
                          ? voters.length
                          : (voters.length <= 5 ? voters.length : 4),
                ),
              );
            }
    
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          },
        ),
      ],
    );
  }
}
