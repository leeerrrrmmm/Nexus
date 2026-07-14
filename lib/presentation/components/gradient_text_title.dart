import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientTextTitle extends StatelessWidget {
  final String text;
  final List<Color>? colors;
  final List<double>? stops;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final Alignment? topAlignment;
  final Alignment? bottomAlignment;
  final Alignment? alignment;
  const GradientTextTitle({
    super.key,
    required this.text,
    this.colors,
    this.stops,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.topAlignment,
    this.bottomAlignment,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: topAlignment ?? Alignment.topCenter,
          end: bottomAlignment ?? Alignment.bottomCenter,
          stops: stops ?? const [0.0, 0.3, 1.0],
          colors:
              colors ??
              [
                const Color(0xFF4F8BFF),
                const Color(0xFF4F8BFF),
                const Color(0xFF4F8BFF).withValues(alpha: 0.6),
              ],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        blendMode: BlendMode.srcIn,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? 126.sp,
            fontFamily: fontFamily ?? 'Kokh',
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
