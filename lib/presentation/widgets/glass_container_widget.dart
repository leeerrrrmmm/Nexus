import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassContainerWidget extends StatelessWidget {
  final Widget child;
  final String? text;
  final int width;
  final int height;
  final EdgeInsets padding;
  final LinearGradient? gradient;
  const GlassContainerWidget({
    super.key,
    this.text,
    this.hardSkills,
    this.gradient,
    required this.child,
    required this.width,
    required this.height,
    required this.padding,
  });

  final List<String>? hardSkills;

  @override
  Widget build(BuildContext context) {
    // BackdropFilter is very expensive on Flutter web — skip it there.
    final useBlur = !kIsWeb;
    final radius = BorderRadius.circular(40.r);

    final content = Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        gradient:
            gradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF2C2C2C).withValues(alpha: useBlur ? 0.2 : 0.55),
                const Color(0xFF474747).withValues(alpha: useBlur ? 0.2 : 0.45),
              ],
            ),
        borderRadius: radius,
        border: Border.all(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF474747).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );

    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        children: [
          if (!useBlur)
            Positioned.fill(
              child: ColoredBox(
                color: const Color(0xFF121212).withValues(alpha: 0.72),
              ),
            ),
          if (useBlur)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
          content,
        ],
      ),
    );
  }
}
