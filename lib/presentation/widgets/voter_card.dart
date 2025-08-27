
import 'package:election_mantra/api/models/voter.dart';
import 'package:flutter/material.dart';

class VoterCard extends StatelessWidget {
  const VoterCard({
    super.key,
    required this.voterDetails
  });

  final VoterDetails voterDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:  _getPartyColor(voterDetails.party).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              voterDetails.serialNo.toString(),
              style: TextStyle(
                color:  _getPartyColor(voterDetails.party),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          voterDetails.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "House: ${voterDetails.houseName} • ${voterDetails.age} yrs • ${voterDetails.gender}",
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                "ID: ${voterDetails.voterId}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:  _getPartyColor(voterDetails.party).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                voterDetails.party,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getPartyColor(voterDetails.party),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                voterDetails.voted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: voterDetails.voted ? Colors.green : Colors.grey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

   Color _getPartyColor(String party) {
    switch (party.toLowerCase()) {
      case "udf":
        return Colors.blue;
      case "ldf":
        return Colors.red;
      case "bjp":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
