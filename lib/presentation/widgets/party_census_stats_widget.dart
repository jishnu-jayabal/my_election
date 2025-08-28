import 'package:election_mantra/core/constant/palette.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/party_list/party_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_stats_count/party_stats_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PartyCensusStatsWidget extends StatelessWidget {
  final Function(String) onPartyChipClicked;

  const PartyCensusStatsWidget({super.key , required this.onPartyChipClicked});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartyListBloc, PartyListState>(
      builder: (context, listState) {
        if (listState is PartyListSuccess) {
          return BlocBuilder<PartyStatsBloc, PartyStatsState>(
            builder: (context, statsState) {
              if (statsState is PartyStatsSuccess) {
                return SliverPadding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            listState.politicalGroups.map((e) {
                              final color = Util.hexToColor(e.color);
                              final count =
                                  statsState.partyCensusStats[e.name] != null?statsState.partyCensusStats[e.name]!.count:
                                  0; // <- lookup by party id
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: (){
                                    onPartyChipClicked(e.name);
                                  },
                                  child: _buildPartyChip(e.name, count, color)),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                );
              }
              return SliverToBoxAdapter(child: SizedBox.shrink(),);
            },
          );
        }
        return  SliverToBoxAdapter(
          child: Center(child: Util.shimmerBox(
            height: 50
            ,margin: EdgeInsets.symmetric(horizontal: 15)
          )),
        );
      },
    );
  }

  Widget _buildPartyChip(String name, int count, Color color) {
    return Chip(
      label: Text("$name: $count"),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(
        color: Palette.black.withOpacity(0.8),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      side: BorderSide(color: color.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}
