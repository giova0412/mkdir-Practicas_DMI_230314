import 'package:flutter/material.dart';

String formatMessageTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

class MessageTimeLabel extends StatelessWidget {
  final DateTime sentAt;
  final Color color;

  const MessageTimeLabel({
    super.key,
    required this.sentAt,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      formatMessageTime(sentAt),
      style: TextStyle(
        color: color,
        fontSize: 11,
      ),
    );
  }
}
