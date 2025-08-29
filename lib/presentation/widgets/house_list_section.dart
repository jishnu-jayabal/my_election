import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/core/constant/palette.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/house_list/house_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:election_mantra/presentation/widgets/voter_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HouseListSection extends StatefulWidget {
  const HouseListSection({super.key});

  @override
  State<HouseListSection> createState() => _HouseListSectionState();
}

class _HouseListSectionState extends State<HouseListSection> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _expandedHouses =
      {}; // Tracks which houses are expanded

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by house number',
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (value) {
                BlocProvider.of<HouseListBloc>(
                  context,
                ).add(SearchHouseListEvent(searchTerm: value));
              },
            ),
          ),
        ),

        // House List
        Expanded(
          child: BlocBuilder<HouseListBloc, HouseListState>(
            builder: (context, state) {
              if (state is HouseListLoading) {
                return _buildShimmerLoading();
              }

              if (state is HouseListSuccess) {
                final houseWise = state.houseWise;
                final expandedState = state.expandedState;

                if (houseWise.isEmpty) return _buildNoResults();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: houseWise.keys.length,
                  itemBuilder: (context, index) {
                    final houseName = houseWise.keys.elementAt(index);
                    final members = houseWise[houseName]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      child: Card(
                        color: Palette.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ExpansionTile(
                          key: PageStorageKey(houseName),
                          initiallyExpanded: expandedState[houseName] ?? false,
                          onExpansionChanged: (expanded) {
                            context.read<HouseListBloc>().add(
                              ToggleHouseExpansionEvent(houseName: houseName),
                            );
                          },
                          backgroundColor: Palette.white,
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.house,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            houseName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          subtitle: Text(
                            "${members.length} member${members.length != 1 ? 's' : ''}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blue.shade700,
                            size: 28,
                          ),
                          children:
                              members
                                  .map(
                                    (voter) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.95,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: VoterCard(voterDetails: voter),
                                      ),
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
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
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



  Widget _buildNoResults() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No results found",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            "Try different search terms",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseList(Map<String, List<VoterDetails>> houseWise) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: houseWise.keys.length,
      itemBuilder: (context, index) {
        final houseName = houseWise.keys.elementAt(index);
        final members = houseWise[houseName] ?? [];

        final isExpanded = _expandedHouses[houseName] ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              key: PageStorageKey(houseName), // preserves expansion on rebuild
              initiallyExpanded: isExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _expandedHouses[houseName] = expanded;
                });
              },
              backgroundColor: Palette.white,
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.house, color: Colors.blue.shade700, size: 20),
              ),
              title: Text(
                houseName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              subtitle: Text(
                "${members.length} member${members.length != 1 ? 's' : ''}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              trailing: Icon(
                Icons.arrow_drop_down,
                color: Colors.blue.shade700,
                size: 28,
              ),
              children: [
                Divider(height: 1, color: Colors.grey.shade200),
                ...members.map(
                  (voter) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: screenWidth * 0.95,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: VoterCard(voterDetails: voter),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
