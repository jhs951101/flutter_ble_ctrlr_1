import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:arduino_ble_controller1/the_others/widget/widget.dart';

class Test1Page extends StatelessWidget {
  Test1Page({super.key});

  final _controller = Get.put(Test1Controller());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '테스트1',
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            //
          ],
        ),
      ),
    );
  }
}

class Test1Controller extends GetxController {
  //

  @override
  void onReady(){
    super.onReady();
    //
  }

  //
}