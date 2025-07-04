import 'package:arduino_ble_controller1/the_others/config/config.dart';
import 'package:arduino_ble_controller1/the_others/controller/controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final _controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'lib/the_others/asset/image/logo.png',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashController extends GetxController {
  String nextRouteName = RouteName().home;
  TimerController timerController = TimerController();

  //

  @override
  Future<void> onReady() async {
    super.onReady();
    setTimer();
  }

  //

  void goToNextView(){
    AppConfig().essentialPermissions.request();
    Get.offNamed(nextRouteName);
  }

  void setTimer(){
    goToNextView();
    
    /*
    timerController.executeAfter(
      (){
        goToNextView();
      },
      5000
    );
    */
  }
}