import 'package:arduino_ble_controller1/the_others/config/config.dart';
import 'package:arduino_ble_controller1/the_others/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogController {
  void showAlertDialog(
    {
      required String title,
      required String contents,
      
      Function? closeBtnPressed,
      bool canPop = true,
      bool barrierDismissible = true,
    }
  ){
    showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: canPop,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NormalText(
                  margin: const EdgeInsets.only(top: 24),
                  title: title,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.black,
                ),
                NormalText(
                  margin: const EdgeInsets.only(top: 12),
                  title: contents,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: CustomColor.black,
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: const Divider(
                    height: 1,
                    color: Color(0xFFE2E2E2),
                  ),
                ),
                FadeButton(
                  onTap: () {
                    Get.back();

                    if(closeBtnPressed != null){
                      closeBtnPressed.call();
                    }
                  },
                  padding: const EdgeInsets.only(top: 17, bottom: 17),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: NormalText(
                        title: '확인',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7D7878),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showConfirmDialog(
    {
      required String title,
      required String contents,

      Function? yesBtnPressed,
      Function? noBtnPressed,

      bool canPop = true,
      bool barrierDismissible = true,
    }
  ){
    showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: canPop,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NormalText(
                  margin: const EdgeInsets.only(top: 24),
                  title: title,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.black,
                ),
                NormalText(
                  margin: const EdgeInsets.only(top: 12),
                  title: contents,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: CustomColor.black,
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: const Divider(
                    height: 1,
                    color: Color(0xFFE2E2E2),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: FadeButton(
                        onTap: () {
                          Get.back();

                          if(yesBtnPressed != null){
                            yesBtnPressed.call();
                          }
                        },
                        padding: const EdgeInsets.only(top: 17, bottom: 17),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: NormalText(
                              title: '예',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF7D7878),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: FadeButton(
                        onTap: () {
                          Get.back();

                          if(noBtnPressed != null){
                            noBtnPressed.call();
                          }
                        },
                        padding: const EdgeInsets.only(top: 17, bottom: 17),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: NormalText(
                              title: '아니오',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF7D7878),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}