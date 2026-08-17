import 'package:flutter/material.dart';
import 'developer_page.dart';
import 'licenses_page.dart';
import 'privacy_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.alarm, size: 72, color: colorScheme.primary),
          const SizedBox(height: 12),
          const Text(
            'Note Alarm',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Version 1.0.0+1',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text(
            'Note Alarm combines an alarm clock with a task manager in a '
            'single lightweight app. All data is stored locally on your '
            'device.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const PrivacyPage())),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Open Source Licenses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const LicensesPage())),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Developer & Contact'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const DeveloperPage())),
          ),
        ],
      ),
    );
  }
}
