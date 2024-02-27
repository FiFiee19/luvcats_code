import 'package:intl/intl.dart';

String formatDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return 'ไม่ทราบวันที่';

    DateTime createdAt = DateTime.parse(dateTime);
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdAt);

    if (difference.inDays >= 2) {
      // If the difference is more than 2 days, show the date in yyyy-MM-dd format
      return DateFormat('yyyy-MM-dd').format(createdAt);
    } else if (difference.inDays >= 1) {
      // If the difference is at least 1 day but less than 2 days, show it as "1 day ago"
      return '1 วัน';
    } else if (difference.inHours >= 1) {
      // If the difference is at least 1 hour but less than 24 hours, show it as "X hours ago"
      return '${difference.inHours} ชั่วโมง';
    } else if (difference.inMinutes >= 1) {
      // If the difference is at least 1 minute but less than 60 minutes, show it as "X minutes ago"
      return '${difference.inMinutes} นาที';
    } else {
      // If the difference is less than 1 minute, show it as "Just now"
      return 'เมื่อสักครู่นี้';
    }
  }