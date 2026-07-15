import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/presentation/widgets/glass_text.dart';
import 'package:portfolio/presentation/widgets/portfolio_text_link_button.dart';

class LiveProjectsSection extends StatefulWidget {
  const LiveProjectsSection({super.key});

  @override
  State<LiveProjectsSection> createState() => _LiveProjectsSectionState();
}

class _LiveProjectsSectionState extends State<LiveProjectsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  int _currentIndex = 0;

  final Color _blueColor = const Color(0xFF4F8BFF);
  final Color _yellowColor = const Color(0xFFFFF94F);

  final List<String> _projectImages = [
    'assets/images/acta_logo.png',
    'assets/images/sous_vide_logo.png',
  ];

  int get _projectCount => AppText.liveProjectsDescription.length;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToIndex((_currentIndex + 1) % _projectCount);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _animationController.forward();
    });
  }

  void _goToIndex(int index) {
    if (!mounted) return;
    setState(() => _currentIndex = index);
    _animationController
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getCurrentColor(int index) =>
      (index % 2 == 0) ? _blueColor : _yellowColor;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = _getCurrentColor(_currentIndex);

    return Container(
      height: 1.sh,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          // 1. Фоновая подсветка
          AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.topLeft,
                colors: [
                  activeColor.withValues(alpha: 0.22),
                  activeColor.withValues(alpha: 0.04),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.8, 1.0],
              ),
            ),
          ),

          // === ДОБАВЛЕННАЯ КРИВАЯ ЛИНИЯ ===
          Positioned.fill(
            child: CustomPaint(
              painter: _CurvedLinePainter(glowColor: activeColor),
            ),
          ),

          // Маска затемнения (чтобы линия не конфликтовала с правой частью)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    stops: const [0.35, 0.75, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ПРАВАЯ ЧАСТЬ: Изображение проекта
          Positioned(
            top: 0,
            bottom: 0,
            right: 0.1.sw,
            child: IgnorePointer(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.94,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: SizedBox(
                  key: ValueKey<int>(_currentIndex),
                  width: 500.w,
                  height: 500.h,
                  child: Image.asset(
                    _projectImages[_currentIndex % _projectImages.length],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Left / right tap zones — 20s auto-rotate resets on tap
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _goToIndex(
                      (_currentIndex - 1 + _projectCount) % _projectCount,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () =>
                        _goToIndex((_currentIndex + 1) % _projectCount),
                  ),
                ),
              ],
            ),
          ),

          // ОСНОВНОЙ КОНТЕНТ (поверх зон тапа; кнопка остаётся кликабельной)
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 30.w, 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IgnorePointer(
                          child: GlassText(
                            letterSpacing: 10.sp,
                            text: AppText.liveProjectsTitle,
                            fontSize: 100.sp,
                            fontFamily: 'Kokh',
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Flexible(
                          child: IgnorePointer(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 600),
                              switchInCurve: Curves.easeInOutCubic,
                              switchOutCurve: Curves.easeInOutCubic,
                              child: Align(
                                key: ValueKey<int>(_currentIndex),
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  width: 465.w,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      AppText.liveProjectsDescription[
                                          _currentIndex],
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.75,
                                        ),
                                        fontSize: 20.sp,
                                        height: 1.5,
                                        fontFamily: 'Kosugi',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          switchInCurve: Curves.easeInOutCubic,
                          switchOutCurve: Curves.easeInOutCubic,
                          child: _currentIndex == 1
                              ? IgnorePointer(
                                  key: const ValueKey<String>('badge_visible'),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 14.h),
                                    width: 151.w,
                                    height: 47.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(
                                        width: 3,
                                        color: const Color(0xFF997530),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppText.liveProjectsInProgress,
                                        style: TextStyle(
                                          color: const Color(0xFF997530),
                                          fontSize: 20.sp,
                                          height: 1.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Kosugi',
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey<String>('badge_hidden'),
                                ),
                        ),
                        SizedBox(height: 18.h),
                        _currentIndex == 0
                            ? PortfolioTextLinkButton(
                                label: AppText.openPlayStore,
                                link: PortfolioLinkX.fromLiveProjectIndex(
                                  _currentIndex,
                                ),
                                fontSize: 16.sp,
                              )
                            : const SizedBox.shrink(),
                      ],
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

// ================== КРИВАЯ S-ОБРАЗНАЯ ЛИНИЯ ==================
class _CurvedLinePainter extends CustomPainter {
  final Color glowColor;

  _CurvedLinePainter({required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.22)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.28,
        size.width * 0.05,
        size.height * 0.45,
        size.width * 0.22,
        size.height * 0.58,
      )
      ..cubicTo(
        size.width * 0.38,
        size.height * 0.70,
        size.width * 0.02,
        size.height * 0.82,
        size.width * 0.15,
        size.height * 0.95,
      );

    // Свечение
    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    canvas.drawPath(path, glowPaint);

    // Основная линия
    final linePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.85),
          Colors.white.withValues(alpha: 0.25),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _CurvedLinePainter oldDelegate) =>
      oldDelegate.glowColor != glowColor;
}
