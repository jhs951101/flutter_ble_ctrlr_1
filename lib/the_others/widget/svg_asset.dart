import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgAsset extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final String name;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const CustomSvgAsset({
    super.key,
    this.margin,
    required this.name,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: SvgPicture.asset(
        'lib/the_others/asset/image/svg/$name.svg',
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(
                color!,
                BlendMode.srcIn,
              )
            : null,
        fit: fit,
      ),
    );
  }
}
