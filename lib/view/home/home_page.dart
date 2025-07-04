import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Text('안녕하세요!')
          ],
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  //

  @override
  void onReady(){
    super.onReady();
    //
  }

  //
}