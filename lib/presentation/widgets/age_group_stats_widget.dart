import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/age_group_stats_count/age_group_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class AgeGroupStatsWidget extends StatelessWidget {
  const AgeGroupStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgeGroupStatsBloc, AgeGroupStatsState>(
      builder: (context, state) {
        if (state is AgeGroupStatsSuccess) {
          if (state.ageGroupStats.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "No age group data available",
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            );
          }

          // get max count for bar scaling
          final maxCount = state.ageGroupStats
              .map((e) => e.count)
              .reduce((a, b) => a > b ? a : b);

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
                      "Age Distribution",
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 250,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxCount.toDouble() * 1.2, // leave some space above
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 36,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= state.ageGroupStats.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      state.ageGroupStats[index].label,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: state.ageGroupStats.asMap().entries.map((entry) {
                            final index = entry.key;
                            final e = entry.value;
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: e.count.toDouble(),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blueAccent.shade400,
                                      Colors.blueAccent.shade700,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  width: 20,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return  SliverToBoxAdapter(
          child: Center(child: Util.shimmerBox(
            height: 200
            ,margin: EdgeInsets.symmetric(horizontal: 15)
          )),
        );
      },
    );
  }
}
