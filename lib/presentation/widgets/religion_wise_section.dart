import 'package:election_mantra/core/constant/palette.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/religion_group_stats_count/religion_group_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_stats_count/voters_stats_bloc.dart';
import 'package:election_mantra/presentation/widgets/religion_group_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReligionWiseSection extends StatelessWidget {
  const ReligionWiseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VotersStatsBloc, VotersStatsState>(
      builder: (context, voterStatsState) {
        if (voterStatsState is VotersStatsSuccess) {
          final totalVoters = voterStatsState.voterCensusStats.totalVoters;

          return BlocBuilder<ReligionGroupStatsBloc, ReligionGroupStatsState>(
            builder: (context, state) {
              if (state is ReligionGroupStatsSuccess) {
                final averageVotersPerGroup =
                    (totalVoters > 0 &&
                            state.religionGroupStats.isNotEmpty &&
                            state.religionGroupStats.any((g) => g.count > 0))
                        ? totalVoters ~/ state.religionGroupStats.length
                        : 0;

                final smallestGroup = _getSmallestGroup(state);

                return Scaffold(
                  body: CustomScrollView(
                    slivers: [
                      // Enhanced App Bar
                      SliverAppBar(
                        expandedHeight: 240,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Palette.primary,
                                  Palette.primary.withAlpha(100),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total Voters",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    totalVoters.toString(),
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildHeaderStat(
                                          "${state.religionGroupStats.length}",
                                          "Religions",
                                          Icons.category,
                                        ),
                                        _buildHeaderStat(
                                          averageVotersPerGroup.toString(),
                                          "Avg/Religion",
                                          Icons.bar_chart,
                                        ),
                                        _buildHeaderStat(
                                          _getLargestGroupCount(
                                            state,
                                          ).toString(),
                                          "Max",
                                          Icons.arrow_upward,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _showReligionStatsInfo(
                                context,
                                state,
                                totalVoters,
                              );
                            },
                          ),
                        ],
                      ),

                      // Summary cards
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSummaryCard(
                                      context,
                                      "Largest Religion",
                                      _getLargestGroup(state),
                                      Icons.arrow_upward,
                                      Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildSummaryCard(
                                      context,
                                      "Smallest Religion",
                                      smallestGroup,
                                      Icons.arrow_downward,
                                      Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildSummaryCard(
                                context,
                                "Average per Religion",
                                "$averageVotersPerGroup voters",
                                Icons.bar_chart,
                                Colors.orange,
                                fullWidth: true,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Visual Distribution header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.auto_graph,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Visual Distribution",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Distribution Chart
                      const ReligionGroupStatsWidget(),

                      // Detailed Breakdown header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            top: 24,
                            right: 24,
                            bottom: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.list,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Detailed Breakdown",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                              Chip(
                                label: Text("Total: $totalVoters"),
                                backgroundColor: Colors.blueAccent.withOpacity(
                                  0.1,
                                ),
                                labelStyle: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // List of Religions
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final religion = state.religionGroupStats[index];
                          final percentage = religion.percentage;

                          return _buildReligionItem(
                            context,
                            religion.label,
                            religion.count,
                            percentage,
                            index,
                            Util.hexToColor(religion.color)
                          );
                        }, childCount: state.religionGroupStats.length),
                      ),
                    ],
                  ),
                );
              }

              if (state is ReligionGroupStatsLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is ReligionGroupStatsFailed) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      "Failed to load data: ${state.msg}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  // ---------- Helpers ----------
  Widget _buildHeaderStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    bool fullWidth = false,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReligionItem(
    BuildContext context,
    String label,
    int count,
    double percentage,
    int index,
    Color color
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label[0].toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("$count voters"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${percentage.toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color:color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _getLargestGroup(ReligionGroupStatsSuccess state) {
    if (state.religionGroupStats.isEmpty) return "N/A";

    final filtered =
        state.religionGroupStats
            .where(
              (g) =>
                  g.count > 0 && // exclude empty
                  g.label != "Unidentified" &&
                  g.label != "Other",
            )
            .toList();

    if (filtered.isEmpty) return "N/A";

    final largest = filtered.reduce((a, b) => a.count > b.count ? a : b);
    return "${largest.label} (${largest.count})";
  }

  int _getLargestGroupCount(ReligionGroupStatsSuccess state) {
    if (state.religionGroupStats.isEmpty) return 0;

    final filtered =
        state.religionGroupStats
            .where(
              (g) =>
                  g.count > 0 &&
                  g.label != "Unidentified" &&
                  g.label != "Other",
            )
            .toList();

    if (filtered.isEmpty) return 0;

    final largest = filtered.reduce((a, b) => a.count > b.count ? a : b);
    return largest.count;
  }

  String _getSmallestGroup(ReligionGroupStatsSuccess state) {
    if (state.religionGroupStats.isEmpty) return "Unknown";

    final nonZeroGroups =
        state.religionGroupStats
            .where(
              (g) =>
                  g.count > 0 &&
                  g.label != "Unidentified" &&
                  g.label != "Other",
            )
            .toList();

    if (nonZeroGroups.isEmpty) return "Unknown";

    final smallest = nonZeroGroups.reduce((a, b) => a.count < b.count ? a : b);
    return "${smallest.label} (${smallest.count})";
  }

  void _showReligionStatsInfo(
    BuildContext context,
    ReligionGroupStatsSuccess state,
    int totalVoters,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Religion Distribution Statistics"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildStatRow("Total Voters", totalVoters.toString()),
                  _buildStatRow(
                    "Religions",
                    state.religionGroupStats.length.toString(),
                  ),
                  _buildStatRow("Largest Religion", _getLargestGroup(state)),
                  _buildStatRow("Smallest Religion", _getSmallestGroup(state)),
                  const SizedBox(height: 16),
                  const Text(
                    "Distribution:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...state.religionGroupStats.map(
                    (group) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${group.label}:"),
                          Text(
                            "${group.count} (${group.percentage.toStringAsFixed(1)}%)",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
