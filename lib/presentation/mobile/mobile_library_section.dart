import 'dart:ui';

import 'package:content_flipper/content_flipper.dart';
import 'package:curl_text/curl_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_assets/asset_image_cache.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/presentation/components/gradient_text_title.dart';
import 'package:portfolio/presentation/widgets/portfolio_text_link_button.dart';

class MobileLibrarySection extends StatefulWidget {
  const MobileLibrarySection({super.key});

  @override
  State<MobileLibrarySection> createState() => _MobileLibrarySectionState();
}

class _MobileLibrarySectionState extends State<MobileLibrarySection> {
  int? _activeIndex;

  static const _motionDuration = Duration(milliseconds: 780);
  static const _fadeDuration = Duration(milliseconds: 520);
  static const _motionCurve = Curves.easeInOutCubicEmphasized;

  final List<String> _libraryImages = [
    'assets/images/content_flipper.png',
    'assets/images/flod_lib.png',
    'assets/images/curl_text_lib.png',
  ];

  final List<String> _libraryDescriptions = [
    '''content_flipper: A flexible library for implementing content flip animations. It allows you to control the mechanics of the flip effect and offers extensive customization options, with active development focused on expanding its capabilities.''',
    '''Flod: A powerful schema validation library for Dart/Flutter, inspired by Zod. It provides robust type safety, an advanced transformation pipeline, comprehensive error reporting with i18n support, and a high-performance architecture for production-grade data validation.''',
    '''curl_text: A lightweight utility designed to make adding text strokes and outlines effortless. It simplifies the process of styling typography, ensuring your text stands out with minimal configuration.''',
  ];

  @override
  Widget build(BuildContext context) {
    final bool isAnyExpanded = _activeIndex != null;

    // === ИСПРАВЛЕННЫЕ РАСЧЁТЫ ===
    final double stackWidth = 1.05.sw;
    final double stackHeight = 280.h;
    final double circleSize = 168.r;
    final double expandedWidth = 410.w;
    final double overlapGap = 100.w;

    // Центрируем правильно
    final double centerX = (stackWidth - circleSize) / 2;

    return Container(
      width: double.infinity,
      height: 0.8.sh,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImageCache.provider(context, 'assets/images/lib_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.black.withValues(alpha: 0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: GradientTextTitle(
                    text: AppText.libraryTitle,
                    fontSize: 50.sp,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: stackWidth,
                      height: stackHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [2, 0, 1].map((index) {
                          final bool isExpanded = _activeIndex == index;
                          final bool isHidden = isAnyExpanded && !isExpanded;

                          final double leftPosition = isExpanded
                              ? (stackWidth - expandedWidth) / 2
                              : centerX + (index - 1) * overlapGap;

                          return AnimatedPositioned(
                            duration: _motionDuration,
                            curve: _motionCurve,
                            left: leftPosition,
                            top: (stackHeight - circleSize) / 3,
                            width: isHidden
                                ? 0
                                : (isExpanded ? expandedWidth : circleSize),
                            height: circleSize,
                            child: RepaintBoundary(
                              child: MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _activeIndex = index),
                                onExit: (_) =>
                                    setState(() => _activeIndex = null),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _activeIndex = (_activeIndex == index)
                                          ? null
                                          : index;
                                    });
                                  },
                                  child: AnimatedOpacity(
                                    duration: _fadeDuration,
                                    curve: Curves.easeOutCubic,
                                    opacity: isHidden ? 0.0 : 1.0,
                                    child: AnimatedContainer(
                                      duration: _motionDuration,
                                      curve: _motionCurve,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          circleSize / 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.35,
                                            ),
                                            blurRadius: isExpanded ? 28 : 20,
                                            offset: Offset(
                                              0,
                                              isExpanded ? 8 : 4,
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.hardEdge,
                                        children: [
                                          // Изображение (круг)
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            width: circleSize,
                                            height: circleSize,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF0F172A,
                                                  ).withValues(alpha: 0.08),
                                                  width: 5.w,
                                                ),
                                                image: DecorationImage(
                                                  image:
                                                      AssetImageCache.provider(
                                                        context,
                                                        _libraryImages[index],
                                                      ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Описание при расширении
                                          Positioned(
                                            left: circleSize,
                                            top: 0,
                                            bottom: 0,
                                            width: expandedWidth - circleSize,
                                            child: AnimatedOpacity(
                                              duration: _fadeDuration,
                                              curve: Curves.easeOutCubic,
                                              opacity: isExpanded ? 1.0 : 0.0,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 20.w,
                                                  right: 34.w,
                                                  top: 10.h,
                                                  bottom: 12.h,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: index == 0
                                                            ? ContentFlipper(
                                                                onBackTap: () =>
                                                                    setState(
                                                                      () => _activeIndex =
                                                                          index,
                                                                    ),
                                                                onFrontTap: () =>
                                                                    setState(
                                                                      () => _activeIndex =
                                                                          index,
                                                                    ),
                                                                front: Text(
                                                                  _libraryDescriptions[0],
                                                                  style: TextStyle(
                                                                    color: const Color(
                                                                      0xFF0F172A,
                                                                    ),
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1.4,
                                                                  ),
                                                                ),
                                                                back: Text(
                                                                  _libraryDescriptions[0],
                                                                  style: TextStyle(
                                                                    color: const Color(
                                                                      0xFF0F172A,
                                                                    ),
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    height: 1.4,
                                                                  ),
                                                                ),
                                                              )
                                                            : index == 2
                                                            ? CurlTextWidget(
                                                                text:
                                                                    _libraryDescriptions[2],
                                                                fontSize: 10.sp,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                strokeColor:
                                                                    const Color(
                                                                      0xFF0F172A,
                                                                    ),
                                                                strokeWidth:
                                                                    0.7.w,
                                                              )
                                                            : Text(
                                                                _libraryDescriptions[index],
                                                                maxLines: 8,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                  color: const Color(
                                                                    0xFF0F172A,
                                                                  ),
                                                                  fontSize:
                                                                      10.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.2,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    PortfolioTextLinkButton(
                                                      label: AppText.openPubDev,
                                                      link:
                                                          PortfolioLinkX.fromLibraryIndex(
                                                            index,
                                                          ),
                                                      dark: true,
                                                      fontSize: 11.sp,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
