import 'package:intl/intl.dart';

class HelperMethods {
  static String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(time);
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }

  static String formatMessageTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
}
