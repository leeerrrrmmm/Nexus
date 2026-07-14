import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? fontSize;
  final String? fontFamily;
  final double? height;
  const GlassText({
    super.key,
    required this.text,
    this.fontWeight,
    this.letterSpacing,
    this.fontSize,
    this.height,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // СЛОЙ 1: Тело текста (чистая полупрозрачная заливка, сквозь которую виден фон)
        Text(
          text,
          style: TextStyle(
            height: height ?? 0.8,
            fontSize: fontSize ?? 50.sp,
            fontWeight: fontWeight ?? FontWeight.bold,
            letterSpacing: letterSpacing ?? 0.0,
            fontFamily: fontFamily ?? 'Kokh',
            color: const Color(0xFFCACACA).withValues(alpha: 0.05),
          ),
        ),

        // СЛОЙ 2: Идеальный стеклянный контур в 1 линию (полный обход багов геометрии шрифта)
        Text(
          text,
          style: TextStyle(
            height: height ?? 0.8,
            fontSize: fontSize ?? 50.sp,
            fontWeight: fontWeight ?? FontWeight.bold,
            fontFamily: fontFamily ?? 'Kokh',
            letterSpacing: letterSpacing ?? 0.0,
            color: Colors
                .transparent, // Делаем сам текст прозрачным, чтобы не дублировать заливку
            shadows: [
              // Блик сверху-слева (Белый, под углом 45 градусов)
              Shadow(
                color: Colors.white.withValues(alpha: 0.6),
                offset: const Offset(
                  -0.8,
                  -0.8,
                ), // Сдвиг на толщину линии в пикселях
                blurRadius:
                    0.0, // 0.0 дает максимально четкую, не размытую линию
              ),
              // Тень снизу-справа (Темная, под углом 45 градусов)
              Shadow(
                color: Colors.black.withValues(alpha: 0.4),
                offset: const Offset(0.8, 0.8),
                blurRadius: 0.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
