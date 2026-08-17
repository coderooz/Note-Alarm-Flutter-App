import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Text(
          'Note Alarm takes your privacy seriously.\n\n'
          '1. Data Storage\n'
          'All app data (alarms and tasks) is stored locally on your device '
          'using shared preferences. Nothing is uploaded to any server.\n\n'
          '2. Permissions\n'
          'The app requests notification and exact-alarm permissions so it '
          'can ring at the times you set. These permissions are used only '
          'for alarm functionality and can be revoked at any time in your '
          'device settings.\n\n'
          '3. No Analytics\n'
          'Note Alarm does not collect, transmit, or share any personal '
          'data, analytics, or usage statistics.\n\n'
          '4. Third-Party Services\n'
          'The app does not integrate any third-party analytics, '
          'advertising, or cloud services.\n\n'
          '5. Contact\n'
          'If you have questions about this policy, contact us at '
          'contact@coderooz.in.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
      ),
    );
  }
}
