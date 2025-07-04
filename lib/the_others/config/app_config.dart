import 'package:permission_handler/permission_handler.dart';

class AppConfig {
  factory AppConfig() => _instance;

  AppConfig._internal();

  static final AppConfig _instance = AppConfig._internal();
  //final num version = 1.0;

  final List<Permission> essentialPermissions = [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
  ];
  
  /*
  static const String originalDomain = 'https://test.mycafe24.com/';
  static const String serverDomain = originalDomain + 'server/';

  final String imgPath = 'lib/theOthers/material/image/';
  final String serverLink = serverDomain + 'master.php';
  final String uploadLink = serverDomain + 'upload_file.php';
  */
}
