import 'dart:ui';

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
    return ClipRRect(
      child: BackdropFilter(
        // 2. Задаем силу размытия по осям X и Y (10-15 обычно оптимально)
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          width: width.w,
          height: height.h,
          decoration: BoxDecoration(
            gradient:
                gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2C2C2C).withValues(alpha: 0.2),
                    Color(0xFF474747).withValues(alpha: 0.2),
                  ],
                ),
            borderRadius: BorderRadius.circular(40.r),
            border: Border.all(
              color: const Color(0xFFFFFFFF).withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF474747).withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
