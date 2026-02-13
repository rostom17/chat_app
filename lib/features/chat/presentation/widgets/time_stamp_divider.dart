
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeStampDivider extends StatelessWidget {
  const TimeStampDivider({
    super.key,
    required this.timestamp,
  });

  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    String text;

    if (difference.inDays == 0) {
      text = 'Today';
    } else if (difference.inDays == 1) {
      text = 'Yesterday';
    } else if (difference.inDays < 7) {
      text = DateFormat('EEEE').format(timestamp);
    } else {
      text = DateFormat('dd MMMM yyyy').format(timestamp);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }
}