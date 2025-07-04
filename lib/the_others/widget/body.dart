import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CustomBody extends StatelessWidget {
  List<Widget> children;
  bool top;
  double? bottom;
  bool hasPositioned;

  ScrollPhysics physics;
  ScrollController? controller;
  Widget? sliverFillRemaining;
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  CustomBody({
    super.key,
    required this.children,
    this.top = true,
    this.bottom,
    this.hasPositioned = true,

    this.physics = const AlwaysScrollableScrollPhysics(),
    this.controller,
    this.sliverFillRemaining,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  final _controller = Get.put(CustomBodyController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      
      child: Stack(
        children: [
          CustomScrollView(
            controller: controller,
            physics: physics,
            keyboardDismissBehavior: keyboardDismissBehavior,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  children,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: hasPositioned
                        ? 120
                        : bottom != null
                            ? bottom!
                            : 20,
                  ),
                  alignment: Alignment.bottomCenter,
                  child: sliverFillRemaining,
                ),
              ),
            ],
          ),

          /*
          hasPositioned
            ? Positioned(
                left: 15,
                right: 15,
                bottom: 0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width - 30,
                  height: 60,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: CustomColor.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeButton(
                        onTap: () {
                          _controller.onTap_homeBtn();
                        },
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                const CustomSvgAsset(
                                  name: 'menu_1',
                                  height: 20,
                                ),
                                const Gap(5),
                                NormalText(
                                  title: '홈',
                                  fontSize: 10,
                                  color: Color(0xffFFFFFF),
                                ),
                              ],
                            ),
                            Obx((){
                              String num_show = '';
                              int num = CustomBodyController.numOfNotices.value;

                              if(num >= 1){
                                if(num >= 100){
                                  num_show = '99+';
                                }
                                else{
                                  num_show = num.toString();
                                }
                              }

                              return Visibility(
                                visible: num_show.isNotEmpty,
                                child: Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 2, right: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color(0xffE91111),
                                    ),
                                    child: Text(
                                      num_show,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      FadeButton(
                        onTap: () {
                          Get.toNamed(RouteName().create_trash_step1);
                        },
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                const CustomSvgAsset(
                                  name: 'menu_2',
                                  height: 20,
                                ),
                                const Gap(5),
                                NormalText(
                                  title: '수거 의뢰',
                                  fontSize: 10,
                                  color: Color(0xffFFFFFF),
                                ),
                              ],
                            ),
                            Obx((){
                              String num_show = '';
                              int num = CustomBodyController.defaultNum.value;

                              if(num >= 1){
                                if(num >= 100){
                                  num_show = '99+';
                                }
                                else{
                                  num_show = num.toString();
                                }
                              }

                              return Visibility(
                                visible: num_show.isNotEmpty,
                                child: Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 2, right: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color(0xffE91111),
                                    ),
                                    child: Text(
                                      num_show,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      FadeButton(
                        onTap: () async {
                          await _controller.onTap_searchTrashesBtn();
                        },
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                const CustomSvgAsset(
                                  name: 'menu_3',
                                  height: 20,
                                ),
                                const Gap(5),
                                NormalText(
                                  title: '수거하기',
                                  fontSize: 10,
                                  color: Color(0xffFFFFFF),
                                ),
                              ],
                            ),
                            Obx((){
                              String num_show = '';
                              int num = CustomBodyController.defaultNum.value;

                              if(num >= 1){
                                if(num >= 100){
                                  num_show = '99+';
                                }
                                else{
                                  num_show = num.toString();
                                }
                              }

                              return Visibility(
                                visible: num_show.isNotEmpty,
                                child: Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 2, right: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color(0xffE91111),
                                    ),
                                    child: Text(
                                      num_show,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      FadeButton(
                        onTap: () {
                          if(!Get.currentRoute.contains(RouteName().read_chat_room)){
                            Get.toNamed(RouteName().read_chat_room);
                          }
                        },
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                const CustomSvgAsset(
                                  name: 'menu_4',
                                  height: 20,
                                ),
                                const Gap(5),
                                NormalText(
                                  title: '채팅',
                                  fontSize: 10,
                                  color: Color(0xffFFFFFF),
                                ),
                              ],
                            ),
                            Obx((){
                              String num_show = '';
                              int num = CustomBodyController.numOfUnreadMessages.value;

                              if(num >= 1){
                                if(num >= 100){
                                  num_show = '99+';
                                }
                                else{
                                  num_show = num.toString();
                                }
                              }

                              return Visibility(
                                visible: num_show.isNotEmpty,
                                child: Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 2, right: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color(0xffE91111),
                                    ),
                                    child: Text(
                                      num_show,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      FadeButton(
                        onTap: () async {
                          await _controller.onTap_readMyTrashesBtn();
                        },
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                const CustomSvgAsset(
                                  name: 'menu_5',
                                  height: 20,
                                ),
                                const Gap(5),
                                NormalText(
                                  title: '진행 목록',
                                  fontSize: 10,
                                  color: Color(0xffFFFFFF),
                                ),
                              ],
                            ),
                            Obx((){
                              String num_show = '';
                              int num = CustomBodyController.numOfProcessingTrashes.value;

                              if(num >= 1){
                                if(num >= 100){
                                  num_show = '99+';
                                }
                                else{
                                  num_show = num.toString();
                                }
                              }

                              return Visibility(
                                visible: num_show.isNotEmpty,
                                child: Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 2, right: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color(0xffE91111),
                                    ),
                                    child: Text(
                                      num_show,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
          */
        ],
      ),
    );
  }
}

class CustomBodyController extends GetxController {
  //

  //
}