import 'package:intl/intl.dart';

String formatDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return 'ไม่ทราบวันที่';

    DateTime createdAt = DateTime.parse(dateTime);
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdAt);
    //ถ้ามากกว่า2วันให้แสดงเป็น yyyy-MM-dd
    if (difference.inDays >= 2) {
      return DateFormat('yyyy-MM-dd').format(createdAt);
    
    //ถ้ามากกว่า1วันให้แสดง '1 วัน' 
    } else if (difference.inDays >= 1) {
      return '1 วัน';

    //ถ้ามากกว่า1ชั่วโมงหรือน้อยกว่า24ชั่วโมง ให้แสดง จำนวนชั่วโมง
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} ชั่วโมง';

    //ถ้ามากกว่า1นาทีหรือน้อยกว่า60นาที ให้แสดงเป็น จำนวนนาที
    } else if (difference.inMinutes >= 1) {     
      return '${difference.inMinutes} นาที';

    // ถ้าน้อยกว่า1นาที ให้แสดงเป็น 'เมื่อสักครู่นี้'
    } else {
      
      return 'เมื่อสักครู่นี้';
    }
  }