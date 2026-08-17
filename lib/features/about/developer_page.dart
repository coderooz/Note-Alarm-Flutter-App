import 'package:flutter/material.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Developer & Contact')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.code, size: 72, color: colorScheme.primary),
          const SizedBox(height: 12),
          const Text(
            'Coderooz',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Solo developer and founder',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Email'),
            subtitle: Text('contact@coderooz.in'),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Website'),
            subtitle: Text('coderooz.in'),
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('GitHub'),
            subtitle: Text('github.com/coderooz'),
          ),
        ],
      ),
    );
  }
}
