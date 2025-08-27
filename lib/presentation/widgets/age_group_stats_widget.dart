import 'package:election_mantra/presentation/blocs/age_group_stats/age_group_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgeGroupStatsWidget extends StatelessWidget {
  const AgeGroupStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgeGroupStatsBloc, AgeGroupStatsState>(
      builder: (context, state) {
        if (state is AgeGroupStatsSuccess) {
          // Get the max count among all age groups for scaling
          final maxCount = state.ageGroupStats.isNotEmpty
              ? state.ageGroupStats.map((e) => e.count).reduce((a, b) => a > b ? a : b)
              : 1;

          return SliverToBoxAdapter(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Age Distribution",
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: state.ageGroupStats.map((e) {
                          final barHeight = (e.count / maxCount) * 100; // relative bar height
                          return Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  e.count.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.blueAccent.shade400,
                                        Colors.blueAccent.shade700,
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  e.label,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(
          child: LinearProgressIndicator(),
        );
      },
    );
  }
}
