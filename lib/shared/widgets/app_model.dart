import 'package:flutter/material.dart';

class AppModal extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool dismissible;

  const AppModal({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.dismissible = true, // Default to true implies standard behavior
  });

  // A static helper method to show the modal easily
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool dismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      // This controls clicking outside the box
      barrierDismissible: dismissible,
      builder: (context) => AppModal(
        title: title,
        content: content,
        actions: actions,
        dismissible: dismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // PopScope controls the Back Button on Android / Back Swipe on iOS
    return PopScope(
      canPop: dismissible,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        // SingleChildScrollView prevents overflow if content is long
        content: SingleChildScrollView(child: content),
        actions:
            actions ??
            [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
            ],
      ),
    );
  }
}
