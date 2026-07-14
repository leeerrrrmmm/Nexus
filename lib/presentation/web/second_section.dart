import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/responsive/responsive.dart';
import 'package:portfolio/presentation/widgets/glass_container_widget.dart';
import 'package:portfolio/presentation/widgets/glass_text.dart';
import 'package:portfolio/presentation/widgets/soft_skills_widget.dart';

class SecondSection extends StatelessWidget {
  const SecondSection({super.key});

  /// Draft canvas height for this section (1.5 × desktop design height).
  static const double _sectionDesignHeight = 1251;

  @override
  Widget build(BuildContext context) {
    final List<String> hardSkills = [
      'OOP',
      'Firebase (Auth, Analytics, Push Notifications)',
      'REST API',
      'Hive / SharedPreferences',
      'Isar',
      'RxDart',
      'Cross-device UI adaptation (Responsive & Adaptive Layouts)',
      'BLoC',
      'GetIt',
      'Camera & Media Capture (Flutter)',
      'Gallery Access',
      'Cross-platform Health Data Integration (HealthKit & Health Connect)',
      'In-App Purchases (RevenueCat)',
      'SOLID',
      'Clean Architecture (Layered Feature-based)',
      'OneSignal',
    ];

    return SizedBox(
      width: double.infinity,
      height: _sectionDesignHeight.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 20.w,
            top: 10.h,
            width: 873.w,
            height: 448.h,
            child: GlassText(
              text: 'About\nme',
              fontWeight: FontWeight.w800,
              fontSize: 260.sp,
              letterSpacing: 100 * 0.11,
            ),
          ),
          Positioned(
            left: 478.5.w,
            top: 126.5.h,
            child: ArcText(
              radius: 70.5.r,
              startAngle: -pi / 6,
              stretchAngle: 3.2,
              text: 'MAKSYM MYCHKO',
              textStyle: TextStyle(
                fontFamily: 'Delta',
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2563EB),
              ),
            ),
          ),
          Positioned(
            right: context.designX(0.44),
            top: context.designY(0.07),
            child: Image.asset(
              AppAssets.lermImage,
              fit: BoxFit.contain,
              height: 1035.h,
              width: 484.w,
            ),
          ),
          Positioned(
            left: 20.w,
            top: context.designY(0.58),
            child: GlassContainerWidget(
              padding: EdgeInsets.only(top: 35.h, left: 22.w, right: 25.w),
              width: 390,
              height: 659,
              child: Stack(
                children: [
                  Positioned(
                    right: -30.w,
                    top: -30.h,
                    child: Image.asset(
                      AppAssets.rowImage,
                      fit: BoxFit.contain,
                      width: 132.w,
                      height: 132.h,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HARD SKILLS',
                          style: TextStyle(
                            fontFamily: 'Kokh',
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w200,
                            color: const Color(0xFF4F8BFF),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        ...hardSkills.map((skill) {
                          return Text(
                            skill,
                            style: TextStyle(
                              fontSize: 17.4.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Kosugi',
                              color: const Color(0xFFE5E5E5),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: context.designX(0.40),
            top: context.designY(0.32),
            child: Container(
              width: 191.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(width: 2.w, color: const Color(0xFF4F8BFF)),
              ),
              child: Center(
                child: Text(
                  'Flutter Developer',
                  style: TextStyle(
                    color: const Color(0xFF4F8BFF),
                    fontSize: 18.sp,
                    fontFamily: 'Kokh',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20.w,
            top: 360.h,
            child: GlassContainerWidget(
              padding: EdgeInsets.only(
                top: 8.h,
                bottom: 7.h,
                left: 33.w,
                right: 13.w,
              ),
              width: 659,
              height: 363,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  AppText.aboutMeInfo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.5.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kosugi',
                    color: const Color(0xFFE5E5E5),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 6.w,
            bottom: context.designY(0.12),
            width: 662.w,
            child: Column(
              spacing: 10.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassText(
                  text: 'SOFT SKILLS',
                  fontWeight: FontWeight.w100,
                  fontSize: 91.sp,
                  letterSpacing: 6.sp,
                ),
                const SoftSkillsWidget(
                  softSkill: 'CONTINUOUS LEARNING',
                  softSkillLevel: 4,
                ),
                const SoftSkillsWidget(
                  softSkill: 'COMMUNICATION',
                  softSkillLevel: 5,
                ),
                const SoftSkillsWidget(
                  softSkill: 'TEAMWORK',
                  softSkillLevel: 5,
                ),
                const SoftSkillsWidget(
                  softSkill: 'TIME MANAGEMENT',
                  softSkillLevel: 5,
                ),
                const SoftSkillsWidget(
                  softSkill: 'PROBLEM SOLVING',
                  softSkillLevel: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
