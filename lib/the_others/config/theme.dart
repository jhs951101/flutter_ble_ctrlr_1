import 'package:arduino_ble_controller1/the_others/config/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomThemeData {
  static ThemeData get init => ThemeData(
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: CustomColor.white,
        colorScheme: const ColorScheme.light(),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: CustomColor.primary,
          selectionHandleColor: CustomColor.primary,
          selectionColor: Color(0xff8BC3AE),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          titleSpacing: 0,
          centerTitle: true,
          backgroundColor: CustomColor.white,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: CustomColor.white,
          surfaceTintColor: CustomColor.white,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: CustomColor.white,
          surfaceTintColor: CustomColor.white,
        ),
      );
}