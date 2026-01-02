import 'package:flutter/material.dart';

class CalloutView extends StatelessWidget {
  const CalloutView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(icon, size: 20, color: Colors.purple[800]),
              Text(
                title,
                style: TextStyle(
                  color: Colors.purple[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            description,
            style: TextStyle(color: Colors.purple[900], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
