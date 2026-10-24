import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_assets/asset_image_cache.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/presentation/widgets/portfolio_text_link_button.dart';

class MobileLiveProjectsSection extends StatefulWidget {
  const MobileLiveProjectsSection({super.key});

  @override
  State<MobileLiveProjectsSection> createState() =>
      _MobileLiveProjectsSectionState();
}

class _MobileLiveProjectsSectionState extends State<MobileLiveProjectsSection>
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
      duration: const Duration(seconds: 8),
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

    final String rawDescription =
        AppText.mobileLiveProjectsDescription[_currentIndex];
    final List<String> paragraphs = rawDescription
        .split('\n\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Container(
      height: 0.7.sh,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  activeColor.withValues(alpha: 0.14),
                  activeColor.withValues(alpha: 0.02),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _MetallicTitle(lines: ['LIVE MOBILE', 'APP']),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _CurvedLinePainter(
                                glowColor: activeColor,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              width: 0.5.sw,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    switchInCurve: Curves.easeOutCubic,
                                    switchOutCurve: Curves.easeInCubic,
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: ScaleTransition(
                                          scale: Tween<double>(
                                            begin: 0.85,
                                            end: 1,
                                          ).animate(animation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      key: ValueKey<int>(_currentIndex),
                                      width: 140.w,
                                      height: 140.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: activeColor.withValues(
                                              alpha: 0.35,
                                            ),
                                            blurRadius: 40,
                                            spreadRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          _projectImages[_currentIndex %
                                              _projectImages.length],
                                          fit: BoxFit.cover,
                                          cacheWidth:
                                              AssetImageCache.cacheWidth(
                                                context,
                                                _projectImages[_currentIndex %
                                                    _projectImages.length],
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 450,
                                        ),
                                        switchInCurve: Curves.easeOutCubic,
                                        switchOutCurve: Curves.easeInCubic,
                                        child: Column(
                                          key: ValueKey<int>(_currentIndex),
                                          children: [
                                            for (
                                              int i = 0;
                                              i < paragraphs.length;
                                              i++
                                            ) ...[
                                              Text(
                                                paragraphs[i],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.75),
                                                  fontSize: 9.sp,
                                                  height: 1.7,
                                                  letterSpacing: 0.4,
                                                  fontFamily: 'Kosugi',
                                                ),
                                              ),
                                              if (i != paragraphs.length - 1)
                                                SizedBox(height: 14.h),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if (_currentIndex == 0)
                      PortfolioTextLinkButton(
                        label: AppText.openPlayStore,
                        link: PortfolioLinkX.fromLiveProjectIndex(
                          _currentIndex,
                        ),
                        fontSize: 12.sp,
                      )
                    else
                      const _InProgressBadge(),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_projectCount, (i) {
                        final isActive = i == _currentIndex;
                        return GestureDetector(
                          onTap: () => _goToIndex(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: isActive ? 22.w : 7.w,
                            height: 7.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.3),
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

          // Left / right tap zones (keep CTA + dots tappable)
          Positioned(
            top: 0,
            height: 0.42.sh,
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

class _InProgressBadge extends StatelessWidget {
  const _InProgressBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 36.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 2.5, color: const Color(0xFF997530)),
      ),
      child: Center(
        child: Text(
          AppText.liveProjectsInProgress,
          style: TextStyle(
            color: const Color(0xFF997530),
            fontSize: 12.sp,
            height: 1.5,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kosugi',
          ),
        ),
      ),
    );
  }
}

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
                  fontSize: 46.sp,
                  height: 1.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Kokh',
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CurvedLinePainter extends CustomPainter {
  final Color glowColor;

  _CurvedLinePainter({required this.glowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.58, -10)
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.12,
        size.width * 0.20,
        size.height * 0.22,
        size.width * 0.42,
        size.height * 0.40,
      )
      ..cubicTo(
        size.width * 0.62,
        size.height * 0.56,
        size.width * 0.02,
        size.height * 0.68,
        size.width * -0.05,
        size.height,
      );

    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawPath(path, glowPaint);

    final linePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.9),
          Colors.white.withValues(alpha: 0.15),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _CurvedLinePainter oldDelegate) =>
      oldDelegate.glowColor != glowColor;
}
