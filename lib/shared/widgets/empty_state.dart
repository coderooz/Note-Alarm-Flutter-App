import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(color: colorScheme.outline, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
