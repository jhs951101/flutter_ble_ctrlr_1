import 'package:get/get.dart';
import 'package:arduino_ble_controller1/view/page.dart';
import 'route_name.dart';

class AppRoute {
  factory AppRoute() => _instance;

  AppRoute._internal();

  static final AppRoute _instance = AppRoute._internal();

  List<GetPage<dynamic>> get getPages => [
    GetPage(
      name: RouteName().test1,
      page: () => Test1Page(),
    ),
    GetPage(
      name: RouteName().test2,
      page: () => Test2Page(),
    ),

    GetPage(
      name: RouteName().splash,
      page: () => SplashPage(),
    ),
    GetPage(
      name: RouteName().home,
      page: () => HomePage(),
    ),
  ];
}
