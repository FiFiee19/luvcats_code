import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('บริการตำแหน่งที่ตั้งถูกปิดใช้งาน');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('สิทธิ์การเข้าถึงตำแหน่งถูกปฏิเสธ');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      
      return Future.error(
          'สิทธิ์การเข้าถึงตำแหน่งถูกปฏิเสธอย่างถาวรและไม่สามารถขอสิทธิ์ได้อีก');
    }

    
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
