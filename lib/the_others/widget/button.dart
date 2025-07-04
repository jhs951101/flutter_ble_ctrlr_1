import 'package:arduino_ble_controller1/the_others/config/config.dart';
import 'package:arduino_ble_controller1/the_others/widget/text.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  String title;
  void Function()? onTap;

  EdgeInsetsGeometry titleMargin;
  Color color;
  Color titleColor;
  double radius;
  double foneSize;

  CustomElevatedButton({
    super.key,
    required this.title,
    required this.onTap,

    this.titleMargin = const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
    this.color = CustomColor.primary,
    this.titleColor = CustomColor.white,
    this.radius = 5,
    this.foneSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    List<BoxShadow>? boxShadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        offset: Offset(0, 1),
        blurRadius: 3,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
    ];

    if(onTap == null){
      color = const Color(0xffE3E3E4);
      titleColor = const Color(0xff98979A);
      boxShadows = null;
    }

    return FadeButton(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
          boxShadow: boxShadows,
        ),
        child: Center(
          child: NormalText(
            margin: titleMargin,
            title: title,
            fontSize: foneSize,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
      ),
    );
  }
}

class FadeButton extends StatefulWidget {
  Widget child;
  void Function()? onTap;

  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry padding;
  Color color;

  FadeButton({
    super.key,
    required this.child,
    required this.onTap,

    this.margin,
    this.padding = const EdgeInsets.all(10),
    this.color = Colors.transparent,
  });

  @override
  State<FadeButton> createState() => _FadeButtonState();
}

class _FadeButtonState extends State<FadeButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isButton = false;
  Tween<double> _tween = Tween<double>(begin: 1.0);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(milliseconds: 200),
    );

    _animation = _animationController
        .drive(
          CurveTween(
            curve: Curves.decelerate,
          ),
        )
        .drive(_tween);

    _setTween();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FadeButton fadeButton) {
    _setTween();
    super.didUpdateWidget(fadeButton);
  }

  void _setTween() {
    _tween.begin = 1.0;
    _tween.end = 0.4;
  }

  void _onTapUp(_) {
    if (widget.onTap != null) {
      if (_isButton) {
        _isButton = false;

        _animate();
      }
    }
  }

  void _onTapDown(_) {
    if (widget.onTap != null) {
      if (!_isButton) {
        _isButton = true;

        _animate();
      }
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      if (_isButton) {
        _isButton = false;

        _animate();
      }
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;

    bool isWasButton = _isButton;

    TickerFuture tickerFuture = _animationController.animateTo(
      _isButton ? 1.0 : 0,
      duration: Duration(
        milliseconds: _isButton ? 10 : 100,
      ),
    );

    tickerFuture.then((_) {
      if (mounted && isWasButton != _isButton) {
        _animate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: widget.margin,
          color: widget.color,
          child: widget.onTap != null
            ? GestureDetector(
              onTap: widget.onTap,
              onTapUp: _onTapUp,
              onTapDown: _onTapDown,
              onTapCancel: _onTapCancel,
              behavior: HitTestBehavior.opaque,
              child: FadeTransition(
                opacity: _animation,
                child: Container(
                  padding: widget.padding ?? EdgeInsets.all(10),
                  child: Center(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: widget.child,
                  ),
                ),
              ),
            )
            : Container(
              padding: widget.padding ?? EdgeInsets.all(10),
              child: Center(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: widget.child,
              ),
            ),
        ),
      ],
    );
  }
}
