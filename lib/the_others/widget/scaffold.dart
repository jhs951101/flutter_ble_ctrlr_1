import 'package:arduino_ble_controller1/the_others/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomScaffold extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onTapAppBar;
  final void Function()? onScrollTop;
  final String? title;
  final bool canPop;
  final bool isLoading;
  final bool isFullscreen;
  final bool hasAppBar;
  final bool resizeToAvoidBottomInset;
  final ScrollController? scrollController;
  final Widget? titleWidget;
  final Widget? positioned;
  final Color backgroundColor;
  final Widget body;
  final List<Widget>? actions;

  const CustomScaffold({
    super.key,
    this.onTap,
    this.onTapAppBar,
    this.onScrollTop,
    this.title,
    this.canPop = true,
    this.isLoading = false,
    this.isFullscreen = false,
    this.hasAppBar = true,
    this.resizeToAvoidBottomInset = false,
    this.scrollController,
    this.titleWidget,
    this.positioned,
    this.backgroundColor = Colors.transparent,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();

          if (onTap != null) {
            onTap!();
          }
        },
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Container(
                  color: CustomColor.white,
                  child: Scaffold(
                    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                    backgroundColor: backgroundColor,
                    appBar: null,
                    /*
                    appBar: hasAppBar
                      ? CustomAppBar(
                          onTap: onTapAppBar,
                          title: title,
                          canPop: canPop,
                          isFullscreen: isFullscreen,
                          titleWidget: titleWidget,
                          actions: actions,
                        )
                      : null,
                    */
                    body: body,
                  ),
                ),
                positioned ?? Container(),
                if (onScrollTop != null || scrollController != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).padding.top,
                    child: GestureDetector(
                      onTap: () {
                        if (onScrollTop != null) {
                          onScrollTop!();
                        } else if (scrollController != null) {
                          scrollController!.animateTo(
                            0,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeOutCirc,
                          );
                        }
                      },
                    ),
                  )
                else
                  Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
