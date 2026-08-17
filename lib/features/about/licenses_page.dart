import 'package:flutter/material.dart';

class LicensesPage extends StatelessWidget {
  const LicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Source Licenses')),
      body: const LicensePage(),
    );
  }
}
