import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/voters_stats_count/voters_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VotersCensusStatsWidget extends StatelessWidget {
final GestureTapCallback onTotalVoterClicked;
final GestureTapCallback onPendingClicked;
final GestureTapCallback onCompletedClicked;
  const VotersCensusStatsWidget({super.key,
  required this.onTotalVoterClicked,
  required this.onCompletedClicked,
  required this.onPendingClicked
  });

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<VotersStatsBloc, VotersStatsState>(
      builder: (context, state) {
        if (state is VotersStatsSuccess) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 120,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: onTotalVoterClicked,
                        child: _buildStatCard(
                          "Total Voters",
                          state.voterCensusStats.totalVoters.toString(),
                          Colors.blue,
                          Icons.people,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: onCompletedClicked,
                        child: _buildStatCard(
                          "Completed",
                          state.voterCensusStats.completedVoters.toString(),
                          Colors.green,
                          Icons.check_circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: onPendingClicked,
                        child: _buildStatCard(
                          "Pending",
                          state.voterCensusStats.pendingVoters.toString(),
                          Colors.orange,
                          Icons.pending_actions,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return  SliverToBoxAdapter(child: Util.shimmerBox(
          height: 200,margin: EdgeInsets.symmetric(horizontal: 15)
        ));
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
