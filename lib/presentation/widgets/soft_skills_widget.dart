import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SoftSkillsWidget extends StatelessWidget {
  final String softSkill;
  final int softSkillLevel;
  final double? fontSize;
  final bool isMobile;
  const SoftSkillsWidget({
    super.key,
    required this.softSkill,
    required this.softSkillLevel,
    this.fontSize,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0.w, left: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Текст занимает всё свободное место слева
          Expanded(
            child: Text(
              softSkill,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize ?? 28.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Kokh',
                color: const Color(0xFF4F8BFF),
              ),
            ),
          ),

          // Фиксированный контейнер для точек уровня
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: SizedBox(
              width: isMobile ? 113.w : 218.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: isMobile ? 12.w : 24.w,
                children: [
                  ...List.generate(
                    softSkillLevel,
                    (index) => Container(
                      width: isMobile ? 10.w : 24.w,
                      height: isMobile ? 10.w : 24.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // СЛОЙ 1: Тело круга (чистая полупрозрачная заливка, как Color(0xFFCACACA).withValues(alpha: 0.05))
                        color: const Color(0xFFCACACA).withValues(alpha: 0.05),

                        // СЛОЙ 2: Идеальный стеклянный контур (Блик + Тень)
                        boxShadow: [
                          // Блик сверху-слева (Белый, под углом 45 градусов, толщина 0.8 пикселя)
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.6),
                            offset: const Offset(-0.8, -0.8),
                            blurRadius: 0.0, // Четкая линия без размытия
                          ),
                          // Тень снизу-справа (Темная, под углом 45 градусов, толщина 0.8 пикселя)
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            offset: const Offset(0.8, 0.8),
                            blurRadius: 0.0, // Четкая линия без размытия
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
