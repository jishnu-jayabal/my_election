import 'package:election_mantra/core/constant/palette.dart';
import 'package:election_mantra/presentation/blocs/age_group_stats/age_group_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_stats/voters_stats_bloc.dart';
import 'package:election_mantra/presentation/widgets/age_group_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgeWiseSection extends StatelessWidget {
  const AgeWiseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VotersStatsBloc, VotersStatsState>(
      builder: (context, voterStatsState) {
        if (voterStatsState is VotersStatsSuccess) {
          return BlocBuilder<AgeGroupStatsBloc, AgeGroupStatsState>(
            builder: (context, ageGroupStatsState) {
              if (ageGroupStatsState is AgeGroupStatsSuccess) {
                final totalVoters = voterStatsState.voterCensusStats.totalVoters;
                final averageVotersPerGroup = totalVoters > 0 && ageGroupStatsState.ageGroupStats.isNotEmpty
                    ? totalVoters ~/ ageGroupStatsState.ageGroupStats.length
                    : 0;
                
                // Get smallest group (show "Unknown" if count is 0)
                final smallestGroup = _getSmallestGroup(ageGroupStatsState);
                
                return Scaffold(
                  body: CustomScrollView(
                    slivers: [
                      
                      // Enhanced App Bar with more information
                      SliverAppBar(
                        expandedHeight: 240, // Increased height for more content
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                        
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Palette.primary , Palette.primary.withAlpha(100)],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Main total voters count
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
                                        Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 6, offset: const Offset(0, 2)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Stats row
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildHeaderStat(
                                          "${ageGroupStatsState.ageGroupStats.length}",
                                          "Groups",
                                          Icons.category,
                                        ),
                                        _buildHeaderStat(
                                          averageVotersPerGroup.toString(),
                                          "Avg/Group",
                                          Icons.bar_chart,
                                        ),
                                        _buildHeaderStat(
                                          _getLargestGroupCount(ageGroupStatsState).toString(),
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
                            icon: const Icon(Icons.info_outline, color: Colors.white),
                            onPressed: () {
                              _showAgeStatsInfo(context, ageGroupStatsState, totalVoters);
                            },
                          ),
                        ],
                      ),

                      // Summary cards with key metrics
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Column(
                            children: [
                              // Quick stats row
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSummaryCard(
                                      context,
                                      "Largest Group",
                                      _getLargestGroup(ageGroupStatsState),
                                      Icons.arrow_upward,
                                      Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildSummaryCard(
                                      context,
                                      "Smallest Group",
                                      smallestGroup,
                                      Icons.arrow_downward,
                                      Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Average voters card
                              _buildSummaryCard(
                                context,
                                "Average per Group",
                                "$averageVotersPerGroup voters",
                                Icons.bar_chart,
                                Colors.orange,
                                fullWidth: true,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Age group visualization header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
                          child: Row(
                            children: [
                              Icon(Icons.auto_graph, color: Colors.blueAccent, size: 20),
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
                      
                      // AgeGroupStatsWidget
                      const AgeGroupStatsWidget(),
                      
                      // Detailed list header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.list, color: Colors.blueAccent, size: 20),
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
                                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                                labelStyle: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Enhanced list of age groups
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final ageGroup = ageGroupStatsState.ageGroupStats.toList()[index];
                            final percentage = (ageGroup.count / totalVoters * 100);
                            
                            return _buildAgeGroupItem(
                              context,
                              ageGroup.label,
                              ageGroup.count,
                              percentage,
                              index,
                            );
                          }, 
                          childCount: ageGroupStatsState.ageGroupStats.length,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // Helper method to build header stats
  Widget _buildHeaderStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // Helper method to build summary cards
  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon, Color color, {bool fullWidth = false}) {
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

  // Helper method to build age group list items
  Widget _buildAgeGroupItem(BuildContext context, String label, int count, double percentage, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getColorForIndex(index).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getColorForIndex(index),
              ),
            ),
          ),
        ),
        title: Text(
          "$label Years",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
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
                    color: _getColorForIndex(index),
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

  // Helper to get consistent colors based on index
  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blueAccent,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }

  // Helper to get the largest age group
  String _getLargestGroup(AgeGroupStatsSuccess state) {
    if (state.ageGroupStats.isEmpty) return "N/A";
    
    final largest = state.ageGroupStats.reduce(
      (a, b) => a.count > b.count ? a : b,
    );
    return "${largest.label} (${largest.count})";
  }

  // Helper to get the count of the largest group
  int _getLargestGroupCount(AgeGroupStatsSuccess state) {
    if (state.ageGroupStats.isEmpty) return 0;
    
    final largest = state.ageGroupStats.reduce(
      (a, b) => a.count > b.count ? a : b,
    );
    return largest.count;
  }

  // Helper to get the smallest age group - returns "Unknown" if count is 0
  String _getSmallestGroup(AgeGroupStatsSuccess state) {
    if (state.ageGroupStats.isEmpty) return "Unknown";
    
    // Filter out groups with 0 count
    final nonZeroGroups = state.ageGroupStats.where((group) => group.count > 0).toList();
    
    if (nonZeroGroups.isEmpty) return "Unknown";
    
    final smallest = nonZeroGroups.reduce(
      (a, b) => a.count < b.count ? a : b,
    );
    return "${smallest.label} (${smallest.count})";
  }

  // Show detailed information dialog
  void _showAgeStatsInfo(BuildContext context, AgeGroupStatsSuccess state, int totalVoters) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Age Distribution Statistics"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildStatRow("Total Voters", totalVoters.toString()),
              _buildStatRow("Age Groups", state.ageGroupStats.length.toString()),
              _buildStatRow("Largest Group", _getLargestGroup(state)),
              _buildStatRow("Smallest Group", _getSmallestGroup(state)),
              const SizedBox(height: 16),
              const Text(
                "Distribution:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...state.ageGroupStats.map((group) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${group.label} Years:"),
                    Text("${group.count} (${(group.count / totalVoters * 100).toStringAsFixed(1)}%)"),
                  ],
                ),
              )).toList(),
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