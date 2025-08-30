// Paste this into your file (or a new file) and import where needed.
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:election_mantra/api/models/voter_details.dart';

class ContactButtons extends StatelessWidget {
  final VoterDetails voterDetails;

  /// default country code used for WhatsApp when number doesn't include one
  final String defaultCountryCode;

  const ContactButtons({
    Key? key,
    required this.voterDetails,
    this.defaultCountryCode = '91',
  }) : super(key: key);

  String _stripNumber(String raw) {
    var n = raw.trim();
    // keep digits and plus, then remove plus and leading zeros
    n = n.replaceAll(RegExp(r'[^\d+]'), '');
    if (n.startsWith('+')) n = n.substring(1);
    n = n.replaceFirst(RegExp(r'^0+'), '');
    return n;
  }

  Future<void> _callNumber(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open dialer')));
    }
  }

  Future<void> _openWhatsApp(
    BuildContext context,
    String phone, {
    String message = '',
  }) async {
    // Ensure proper formatting
    String n = phone.replaceAll(RegExp(r'[^\d]'), ''); // remove non-digits
    if (n.startsWith('0')) n = n.substring(1); // remove leading 0
    if (!n.startsWith('91')) n = '91$n'; // add country code if missing

    final whatsappScheme = Uri.parse(
      'whatsapp://send?phone=$n&text=${Uri.encodeComponent(message)}',
    );
    final waMe = Uri.parse(
      'https://wa.me/$n?text=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(whatsappScheme)) {
        await launchUrl(whatsappScheme, mode: LaunchMode.externalApplication);
        return;
      }
      if (await canLaunchUrl(waMe)) {
        await launchUrl(waMe, mode: LaunchMode.externalApplication);
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open WhatsApp')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening WhatsApp: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = voterDetails.mobileNo;
    if (mobile == null || mobile.trim().isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.phone, color: Colors.green),
          tooltip: 'Call',
          onPressed: () => _callNumber(context, mobile),
        ),
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
          tooltip: 'WhatsApp',
          onPressed: () => _openWhatsApp(context, mobile),
        ),
      ],
    );
  }
}
