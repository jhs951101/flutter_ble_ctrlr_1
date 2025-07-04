import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:arduino_ble_controller1/the_others/widget/widget.dart';

class Test2Page extends StatelessWidget {
  Test2Page({super.key});

  final _controller = Get.put(Test2Controller());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '테스트2',
      body: SafeArea(
        child: Column(
          children: [
            //
          ],
        ),
      ),
    );
  }
}

class Test2Controller extends GetxController {
  //

  @override
  void onReady(){
    super.onReady();
    //
  }

  //
}