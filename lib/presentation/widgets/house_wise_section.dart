
import 'package:flutter/material.dart';

class HouseWiseSection extends StatelessWidget {
   HouseWiseSection({
    super.key,
  });
// House groups
  final houseGroups = {"001": 45, "002": 78, "003": 62, "004": 53, "005": 91};

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "House Distribution",
              style: TextStyle(
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blueAccent, Colors.blue.shade800],
                ),
              ),
              child: Center(
                child: Text(
                  "Total Houses: ${houseGroups.length}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
    
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Voters by House",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          houseGroups.entries.map((e) {
                            return Chip(
                              label: Text("House ${e.key}: ${e.value} voters"),
                              backgroundColor: Colors.blueAccent.withOpacity(
                                0.2,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    
        // SliverList(
        //   delegate: SliverChildBuilderDelegate((context, index) {
        //     final house = houseGroups.entries.toList()[index];
        //     final houseVoters =
        //         voters
        //             .where(
        //               (voter) =>
        //                   voter["house"].toString().startsWith(house.key),
        //             )
        //             .toList();
    
        //     return ExpansionTile(
        //       leading: CircleAvatar(
        //         backgroundColor: Colors.blueAccent,
        //         child: Text(house.key, style: TextStyle(color: Colors.white)),
        //       ),
        //       title: Text("House ${house.key}"),
        //       subtitle: Text("${house.value} voters"),
        //       children:
        //           houseVoters
        //               .map(
        //                 (voter) => ListTile(
        //                   title: Text(voter["name"].toString()),
        //                   subtitle: Text(
        //                     "Age: ${voter["age"]}, ${voter["sex"]}",
        //                   ),
        //                   trailing:
        //                       voter["voted"] == true
        //                           ? Icon(
        //                             Icons.check_circle,
        //                             color: Colors.green,
        //                           )
        //                           : Icon(Icons.pending, color: Colors.orange),
        //                 ),
        //               )
        //               .toList(),
        //     );
        //   }, childCount: houseGroups.length),
        // ),
      ],
    );
  }
}
