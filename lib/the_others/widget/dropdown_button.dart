import 'package:arduino_ble_controller1/the_others/config/config.dart';
import 'package:arduino_ble_controller1/the_others/widget/svg_asset.dart';
import 'package:arduino_ble_controller1/the_others/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownButton extends StatelessWidget {
  List<String> values;
  RxString selectedValue;

  String? title;
  void Function()? onChanged;

  CustomDropdownButton({
    super.key,
    required this.values,
    required this.selectedValue,

    this.title,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx((){
      title ??= AppConfig().defaultValue_dropdownButton;

      return DropdownButton(
        value: selectedValue.value,
        underline: Container(),
        isDense: true,
        hint: NormalText(
          margin: const EdgeInsets.all(0),
          title: title!,
          fontSize: 15,
          color: CustomColor.black,
        ),
        icon: const CustomSvgAsset(
          name: 'arrow_down',
        ),
        items: values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: NormalText(
                margin: const EdgeInsets.all(0),
                title: e,
                fontSize: 15,
                color: CustomColor.black,
              ),
            ),
          )
          .toList(),
        onChanged: (value) {
          selectedValue.value = value!;

          if(onChanged != null){
            onChanged!();
          }
        },
      );
    });
  }
}
