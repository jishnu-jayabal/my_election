import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/religion_group_stats_count/religion_group_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class ReligionGroupStatsWidget extends StatelessWidget {
  const ReligionGroupStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReligionGroupStatsBloc, ReligionGroupStatsState>(
      builder: (context, state) {
        if (state is ReligionGroupStatsSuccess) {
          // Filter out groups with 0 count
          final nonZeroGroups =
              state.religionGroupStats.where((group) => group.count > 0).toList();

          if (nonZeroGroups.isEmpty) {
            return SliverToBoxAdapter(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                margin: const EdgeInsets.all(16),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "No religion data available",
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return SliverToBoxAdapter(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Religion Distribution",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: nonZeroGroups.map((group) {
                            return PieChartSectionData(
                              color: Util.hexToColor(group.color), // ✅ Use provided color
                              value: group.percentage,
                              title:
                                  "${group.label}\n${group.percentage.toStringAsFixed(1)}%",
                              radius: 80,
                              titleStyle: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    if (nonZeroGroups.length < state.religionGroupStats.length)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "+ ${state.religionGroupStats.length - nonZeroGroups.length} religions with 0 voters",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
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
