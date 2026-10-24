import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/const/app_assets/asset_image_cache.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/responsive/responsive.dart';
import 'package:portfolio/presentation/widgets/glass_container_widget.dart';
import 'package:portfolio/presentation/widgets/glass_text.dart';
import 'package:portfolio/presentation/widgets/soft_skills_widget.dart';

class MobileSecondSection extends StatelessWidget {
  const MobileSecondSection({super.key});

  static const double _sectionDesignHeight = 917;

  @override
  Widget build(BuildContext context) {
    final List<String> hardSkills = [
      'OOP',
      'Firebase (Auth, Analytics, Push Notifications)',
      'REST API',
      'Hive / SharedPreferences',
      'Isar',
      'RxDart',
      'Cross-device UI adaptation',
      'BLoC',
      'GetIt',
      'Camera & Media Capture',
      'Gallery Access',
      'HealthKit & Health Connect',
      'In-App Purchases',
      'SOLID',
      'Clean Architecture',
    ];

    return SizedBox(
      width: double.infinity,
      height: _sectionDesignHeight.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 16.w,
            top: 20.h,
            child: GlassText(
              text: 'About\nme',
              fontWeight: FontWeight.w800,
              fontSize: 110.sp,
              letterSpacing: 4,
            ),
          ),
          Positioned(
            left: 210.5.w,
            top: 65.5.h,
            child: ArcText(
              radius: 30.r,
              startAngle: -pi / 6,
              stretchAngle: 3,
              text: 'MAKSYM MYCHKO',
              textStyle: TextStyle(
                fontFamily: 'Delta',
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2563EB),
              ),
            ),
          ),
          Positioned(
            left: 86.w,
            top: 40.h,
            child: Image.asset(
              AppAssets.lermImage,
              fit: BoxFit.contain,
              height: 520.h,
              width: 240.w,
              cacheWidth: AssetImageCache.cacheWidth(
                context,
                AppAssets.lermImage,
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            top: context.designY(0.3),
            child: GlassContainerWidget(
              padding: EdgeInsets.only(top: 25.h, left: 22.w, right: 18.w),
              width: 158,
              height: 360,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HARD SKILLS',
                          style: TextStyle(
                            fontFamily: 'Kokh',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w200,
                            color: const Color(0xFF4F8BFF),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ...hardSkills.map(
                          (skill) => Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Text(
                              skill,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Kosugi',
                                color: const Color(0xFFE5E5E5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: context.designX(0.20),
            top: context.designY(0.16),
            child: Container(
              width: 81.w,
              height: 30.h,
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
                    fontSize: 8.sp,
                    fontFamily: 'Kokh',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: context.designX(0.01),
            top: context.designY(0.26),
            child: GlassContainerWidget(
              padding: EdgeInsets.only(
                top: 20.h,
                bottom: 20.h,
                left: 20.w,
                right: 20.w,
              ),
              width: 152,
              height: 405,
              child: Text(
                AppText.aboutMeInfo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 7.5.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Kosugi',
                  color: const Color(0xFFE5E5E5),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20.w,
            bottom: context.designY(0.05),
            width: 372.w,
            child: Column(
              spacing: 10.w,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassText(
                  text: 'SOFT SKILLS',
                  fontWeight: FontWeight.w100,
                  fontSize: 51.sp,
                  letterSpacing: 4.sp,
                ),
                const SoftSkillsWidget(
                  isMobile: true,
                  fontSize: 16,
                  softSkill: 'CONTINUOUS LEARNING',
                  softSkillLevel: 4,
                ),
                const SoftSkillsWidget(
                  isMobile: true,
                  fontSize: 16,
                  softSkill: 'COMMUNICATION',
                  softSkillLevel: 5,
                ),
                const SoftSkillsWidget(
                  isMobile: true,
                  fontSize: 16,
                  softSkill: 'TEAMWORK',
                  softSkillLevel: 5,
                ),
                const SoftSkillsWidget(
                  isMobile: true,
                  fontSize: 16,
                  softSkill: 'TIME MANAGEMENT',
                  softSkillLevel: 5,
                ),
                const SoftSkillsWidget(
                  isMobile: true,
                  fontSize: 16,
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
