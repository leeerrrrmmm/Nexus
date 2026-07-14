import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/presentation/widgets/portfolio_text_link_button.dart';

class TabletLiveProjectSection extends StatefulWidget {
  const TabletLiveProjectSection({super.key});

  @override
  State<TabletLiveProjectSection> createState() =>
      _TabletLiveProjectSectionState();
}

class _TabletLiveProjectSectionState extends State<TabletLiveProjectSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  int _currentIndex = 0;

  final Color _blueColor = const Color(0xFF4F8BFF);
  final Color _yellowColor = const Color(0xFFFFF94F);

  final List<String> _projectImages = [
    'assets/images/acta_logo.png',
    'assets/images/sous_vide_logo.png',
  ];

  int get _projectCount => _projectImages.length;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // чуть дольше чем на мобиле
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

    final String rawDescription = AppText
        .liveProjectsDescription[_currentIndex]; // или mobile-версия, если отличается
    final List<String> paragraphs = rawDescription
        .split('\n\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Container(
      height: 0.85.sh, // чуть выше чем на мобиле
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          // Мягкая цветная подсветка
          AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  activeColor.withValues(alpha: 0.18),
                  activeColor.withValues(alpha: 0.03),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),

          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Верхний блок: заголовок + линия + лого
                    SizedBox(
                      height: 420.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Декоративная S-образная линия
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _CurvedLinePainter(
                                glowColor: activeColor,
                              ),
                            ),
                          ),

                          // Металлический заголовок
                          Positioned(
                            top: 20.h,
                            left: 0,
                            right: 280.w,
                            child: _MetallicTitle(
                              lines: const ['LIVE PROJECTS'],
                            ),
                          ),

                          // Круглое лого с свечением
                          Positioned(
                            right: 40.w,
                            top: 80.h,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 600),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: Tween<double>(
                                      begin: 0.88,
                                      end: 1.0,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: Container(
                                key: ValueKey<int>(_currentIndex),
                                width: 260.w,
                                height: 260.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: activeColor.withValues(
                                        alpha: 0.45,
                                      ),
                                      blurRadius: 60,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    _projectImages[_currentIndex %
                                        _projectImages.length],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 50.h),

                    // Описание
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: Column(
                            key: ValueKey<int>(_currentIndex),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < paragraphs.length; i++) ...[
                                Text(
                                  paragraphs[i],
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.78),
                                    fontSize: 17.sp,
                                    height: 1.65,
                                    letterSpacing: 0.3,
                                    fontFamily: 'Kosugi',
                                  ),
                                ),
                                if (i != paragraphs.length - 1)
                                  SizedBox(height: 20.h),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),
                    PortfolioTextLinkButton(
                      label: _currentIndex == 0
                          ? AppText.openPlayStore
                          : AppText.openProject,
                      link: PortfolioLinkX.fromLiveProjectIndex(_currentIndex),
                      fontSize: 15.sp,
                    ),
                    SizedBox(height: 20.h),

                    // Индикаторы-точки
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_projectCount, (i) {
                        final isActive = i == _currentIndex;
                        return GestureDetector(
                          onTap: () => _goToIndex(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 6.w),
                            width: isActive ? 32.w : 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Left / right swipe zones (top area only — keep Open button tappable)
          Positioned(
            top: 0,
            height: 0.4.sh,
            left: 0,
            right: 0,
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
        ],
      ),
    );
  }
}

// === Металлический заголовок ===
class _MetallicTitle extends StatelessWidget {
  final List<String> lines;

  const _MetallicTitle({required this.lines});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF2F2F2),
            Color(0xFF9A9A9A),
            Color(0xFFEDEDED),
            Color(0xFF5C5C5C),
          ],
          stops: [0.0, 0.4, 0.6, 1.0],
        ).createShader(bounds);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines
            .map(
              (line) => Text(
                line,
                style: TextStyle(
                  fontSize: 78.sp,
                  height: 0.95,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Kokh',
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// === Декоративная S-образная линия ===
class _CurvedLinePainter extends CustomPainter {
  final Color glowColor;

  _CurvedLinePainter({required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.55, -20)
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.15,
        size.width * 0.18,
        size.height * 0.25,
        size.width * 0.45,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.65,
        size.width * 0.05,
        size.height * 0.75,
        size.width * -0.08,
        size.height * 0.95,
      );

    // Свечение
    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawPath(path, glowPaint);

    // Основная линия
    final linePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.95),
          Colors.white.withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _CurvedLinePainter oldDelegate) =>
      oldDelegate.glowColor != glowColor;
}
