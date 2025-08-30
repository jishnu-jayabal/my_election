import 'package:election_mantra/api/models/political_groups.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/app_routes.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/house_list/house_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_list/party_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/update_voter/update_voter_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:election_mantra/presentation/widgets/contact_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoterCard extends StatelessWidget {
  const VoterCard({super.key, required this.voterDetails});

  final VoterDetails voterDetails;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editVoterDetails,
          arguments: EditVoterDetailsArguments(voter: voterDetails),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Serial number avatar
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _getPartyColor(
                    voterDetails.party,
                    context,
                  ).withOpacity(0.15),
                  child: Text(
                    voterDetails.serialNo.toString(),
                    style: TextStyle(
                      color: _getPartyColor(voterDetails.party, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Main voter info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voterDetails.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: true,
                        maxLines: 2, // optional, limit to 2 lines
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.home,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              voterDetails.houseName,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Age: ${voterDetails.age}, ${voterDetails.gender}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        "ID: ${voterDetails.voterId}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                // Party + vote status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPartyColor(
                          voterDetails.party,
                          context,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        voterDetails.party.isEmpty ? "N/A" : voterDetails.party,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: _getPartyColor(voterDetails.party, context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    BlocConsumer<UpdateVoterBloc, UpdateVoterState>(
                      listener: (context, state) {
                        if (state is UpdateVoterSuccess) {
                          BlocProvider.of<VotersListBloc>(context).add(
                            ReplcaeVoterDetailsevent(
                              voterDetails: state.voterUpdated,
                            ),
                          );
                          BlocProvider.of<HouseListBloc>(context).add(
                            UpdateVoterInHouseListEvent(
                              voter: state.voterUpdated,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                final newVoterDetails = voterDetails.copyWith(
                                  voted: !voterDetails.voted, // toggle vote
                                );
                                BlocProvider.of<UpdateVoterBloc>(context).add(
                                  UpdateVoterDetailsEvent(
                                    voterDetails: newVoterDetails,
                                  ),
                                );
                              },
                              icon: Icon(
                                voterDetails.voted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color:
                                    voterDetails.voted
                                        ? Colors.green
                                        : Colors.grey.shade400,
                                size: 22,
                              ),
                            ),
                            Text(
                              voterDetails.voted ? "Voted" : "Not Voted",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color:
                                    voterDetails.voted
                                        ? Colors.green
                                        : Colors.grey,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            ContactButtons(voterDetails: voterDetails),
          ],
        ),
      ),
    );
  }

  Color _getPartyColor(String party, BuildContext context) {
    final partyListState = BlocProvider.of<PartyListBloc>(context).state;

    if (partyListState is PartyListSuccess) {
      // Search for the party by name or abbreviation (case insensitive)
      final match = partyListState.politicalGroups.firstWhere(
        (p) =>
            p.name.toLowerCase() == party.toLowerCase() ||
            p.abbreviation.toLowerCase() == party.toLowerCase(),
        orElse:
            () => PoliticalGroups(
              id: -1,
              name: "Unknown",
              symbol: "",
              abbreviation: "",
              color: "#999999", // default gray color
            ),
      );

      // Convert hex string to Color
      return Util.hexToColor(match.color);
    }

    // Default color if party list is not loaded
    return Colors.grey;
  }
}
