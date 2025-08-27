import 'package:election_mantra/api/models/voter.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:election_mantra/presentation/widgets/filter_widget.dart';
import 'package:election_mantra/presentation/widgets/voter_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum VotersListWidgetMode { full, recent }

class VotersListWidget extends StatelessWidget {
  final VotersListWidgetMode mode;
  const VotersListWidget({super.key, this.mode = VotersListWidgetMode.full});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VotersListBloc, VotersListState>(
      builder: (context, state) {
        if (state is VotersListSuccess) {
          final voters = state.voters; // get the voters list from state
          return CustomScrollView(
            slivers: [
              if (mode == VotersListWidgetMode.full)
                // Search bar
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
                                      (context) =>  FilterWidget(
                                        onFiltersChanged: (map) {},
                                      ),
                                ),
                              );
                            },
                            icon: Icon(Icons.settings),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (mode == VotersListWidgetMode.full)
                // Voter list header
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "All Voters (${voters.length})",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),

              // Voter list
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final voter = voters[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: _buildVoterCard(voter, index + 1),
                    );
                  },
                  childCount:
                      mode == VotersListWidgetMode.full ? voters.length : 5,
                ),
              ),
            ],
          );
        }

        if (state is VotersListLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is VotersListFailure) {
          return Center(child: Text("Failed to load voters"));
        }

        return const SizedBox.shrink(); // default empty widget
      },
    );
  }

  Widget _buildVoterCard(VoterDetails voter, int index) {
    return VoterCard(voterDetails: voter);
  }
}
