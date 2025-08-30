import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/api/models/party_census_stats.dart';
import 'package:election_mantra/api/models/political_groups.dart';
import 'package:election_mantra/presentation/blocs/party_list/party_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_stats/party_stats_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PartyCensusStatsWidget extends StatelessWidget {
  final Function(String) onPartyChipClicked;
  final bool isCardMode; // Flag for tab/pie chart mode

  const PartyCensusStatsWidget({
    super.key,
    required this.onPartyChipClicked,
    this.isCardMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartyListBloc, PartyListState>(
      builder: (context, listState) {
        if (listState is! PartyListSuccess) {
          return SliverToBoxAdapter(
            child: Center(
              child: Util.shimmerBox(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
          );
        }

        return BlocBuilder<PartyStatsBloc, PartyStatsState>(
          builder: (context, statsState) {
            if (statsState is! PartyStatsSuccess) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }

            final stats = statsState.partyCensusStats;
            final parties = listState.politicalGroups;

            if (!isCardMode) {
              // Original chip list mode
              return SliverPadding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          parties.map((e) {
                            final color = Util.hexToColor(e.color);
                            final count = stats.total[e.name]?.count ?? 0;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => onPartyChipClicked(e.name),
                                child: _buildPartyChip(e.name, count, color),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              );
            } else {
              // Card with tabs + pie chart mode
              return SliverToBoxAdapter(
                child: _buildCardWithTabs(stats, parties, context),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildPartyChip(String name, int count, Color color) {
    return Chip(
      label: Text("$name: $count"),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: BorderSide(color: color.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  Widget _buildCardWithTabs(
    PartyCensusStats stats,
    List<PoliticalGroups> parties,
    BuildContext context,
  ) {
    return SizedBox(
      height: 450, // Height enough for pie chart + chips
      child: DefaultTabController(
        length: 2,
        child: Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    child: Text(
                      "Voted",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Not Voted",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
                labelColor: Colors.black,
                indicatorColor: Colors.blue,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPartyPieAndChips(stats.voted, parties),
                    _buildPartyPieAndChips(stats.notVoted, parties),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartyPieAndChips(
    Map<String, PartyCountDetail> map,
    List<PoliticalGroups> parties,
  ) {
    final pieSections = <PieChartSectionData>[];

    for (var party in parties) {
      final detail = map[party.name];
      if (detail != null && detail.percentage > 0) {
        pieSections.add(
          PieChartSectionData(
            value: detail.percentage,
            title: "${detail.party} ${detail.percentage.toStringAsFixed(1)}%",
            color: Util.hexToColor(party.color),
            radius: 160,
            
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    }

    if (pieSections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FaIcon(FontAwesomeIcons.chartPie, size: 180, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              "No data available",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        SizedBox(height: 30),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: pieSections,
              sectionsSpace: 2,
              centerSpaceRadius: 0,
            ),
          ),
        ),
      ],
    );
  }
}
