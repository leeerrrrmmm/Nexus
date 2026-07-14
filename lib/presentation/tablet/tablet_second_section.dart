import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/presentation/widgets/glass_container_widget.dart';
import 'package:portfolio/presentation/widgets/glass_text.dart';
import 'package:portfolio/presentation/widgets/soft_skills_widget.dart';

class TabletSecondSection extends StatelessWidget {
  const TabletSecondSection({super.key});

  /// Design canvas for this section (1.5 × tablet draft height 1024).
  static const double _sectionDesignHeight = 1536;

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

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5.w),
        ),
      ),
      width: double.infinity,
      height: _sectionDesignHeight.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // "About me"
          Positioned(
            left: 46.w,
            top: 100.h,
            width: 720.w,
            height: 380.h,
            child: GlassText(
              text: 'About\nme',
              fontWeight: FontWeight.w800,
              fontSize: 178.sp,
              letterSpacing: 100 * 0.085,
            ),
          ),

          // Curved name
          Positioned(
            left: 364.w,
            top: 180.h,
            child: ArcText(
              radius: 54.r,
              startAngle: -pi / 6.2,
              stretchAngle: 3.05,
              text: 'MAKSYM MYCHKO',
              textStyle: TextStyle(
                fontFamily: 'Delta',
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2563EB),
              ),
            ),
          ),

          // Portrait — fixed design size so it scales with the canvas
          Positioned(
            right: 215.w,
            top: 122.h,
            child: Image.asset(
              AppAssets.lermImage,
              fit: BoxFit.contain,
              width: 390.w,
              height: 880.h,
            ),
          ),

          // Flutter Developer badge
          Positioned(
            right: 154.w,
            top: 328.h,
            child: Container(
              width: 210.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(
                  width: 2.5.w,
                  color: const Color(0xFF4F8BFF),
                ),
              ),
              child: Center(
                child: Text(
                  'Flutter Developer',
                  style: TextStyle(
                    color: const Color(0xFF4F8BFF),
                    fontSize: 16.sp,
                    fontFamily: 'Kokh',
                  ),
                ),
              ),
            ),
          ),

          // Hard skills card
          Positioned(
            left: 36.w,
            top: 481.h,
            child: GlassContainerWidget(
              padding: EdgeInsets.only(top: 34.h, left: 26.w, right: 24.w),
              width: 320,
              height: 560,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: -28.w,
                    top: -28.h,
                    child: Image.asset(
                      AppAssets.rowImage,
                      fit: BoxFit.contain,
                      width: 118.w,
                      height: 118.h,
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
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w200,
                            color: const Color(0xFF4F8BFF),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ...hardSkills.map((skill) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: Text(
                              skill,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Kosugi',
                                color: const Color(0xFFE5E5E5),
                              ),
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

          // About me info card
          Positioned(
            right: 38.w,
            top: 480.h,
            child: GlassContainerWidget(
              padding: EdgeInsets.only(
                top: 22.h,
                bottom: 20.h,
                left: 32.w,
                right: 22.w,
              ),
              width: 320,
              height: 570,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  AppText.aboutMeInfo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kosugi',
                    color: const Color(0xFFE5E5E5),
                    height: 1.48,
                  ),
                ),
              ),
            ),
          ),

          // Soft skills — anchored to section canvas, not viewport fractions
          Positioned(
            left: 81.w,
            right: 36.w,
            top: 1080.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassText(
                  text: 'SOFT SKILLS',
                  fontWeight: FontWeight.w100,
                  fontSize: 80.sp,
                  letterSpacing: 4.sp,
                ),
                SizedBox(height: 12.h),
                const SoftSkillsWidget(
                  isMobile: false,
                  fontSize: 25,
                  softSkill: 'CONTINUOUS LEARNING',
                  softSkillLevel: 4,
                ),
                SizedBox(height: 12.h),
                const SoftSkillsWidget(
                  isMobile: false,
                  fontSize: 25,
                  softSkill: 'COMMUNICATION',
                  softSkillLevel: 5,
                ),
                SizedBox(height: 12.h),
                const SoftSkillsWidget(
                  isMobile: false,
                  fontSize: 25,
                  softSkill: 'TEAMWORK',
                  softSkillLevel: 5,
                ),
                SizedBox(height: 12.h),
                const SoftSkillsWidget(
                  isMobile: false,
                  fontSize: 25,
                  softSkill: 'TIME MANAGEMENT',
                  softSkillLevel: 5,
                ),
                SizedBox(height: 12.h),
                const SoftSkillsWidget(
                  isMobile: false,
                  fontSize: 25,
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
