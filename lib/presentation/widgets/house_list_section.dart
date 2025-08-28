import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:election_mantra/presentation/widgets/voter_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseListSection extends StatelessWidget {
  const HouseListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VotersListBloc, VotersListState>(
      builder: (context, state) {
        if (state is VotersListLoading) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Util.shimmerBox(
                  height: 80,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          );
        }

        if (state is VotersListFailure) {
          return const Center(child: Text("Failed to load house-wise voters"));
        }

        if (state is VotersListSuccess) {
          final houseWise = state.houseWise;

          if (houseWise.isEmpty) {
            return const Center(child: Text("No houses found"));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: houseWise.keys.length,
            itemBuilder: (context, index) {
              final houseName = houseWise.keys.elementAt(index);
              final members = houseWise[houseName] ?? [];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(
                      houseName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text("${members.length} members"),
                    children: members
                        .map(
                          (voter) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: VoterCard(voterDetails: voter),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
