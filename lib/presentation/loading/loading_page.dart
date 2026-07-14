import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/presentation/landing/landing_page.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _loopController;
  late AnimationController _progressController;
  late Animation<double> _progressAnim;
  late AnimationController _transitionController;

  final List<String> assetsToPreload = [
    'assets/images/acta_logo.png',
    'assets/images/sous_vide_logo.png',
    'assets/images/back_pattern.png',
    'assets/images/bg.png',
    'assets/images/collabix_oreview.png',
    'assets/images/contact_me_img.png',
    'assets/images/content_flipper.png',
    'assets/images/curl_text_lib.png',
    'assets/images/echat.png',
    'assets/images/flod_lib.png',
    'assets/images/i.png',
    'assets/images/lib_bg.png',
    'assets/images/me.png',
    'assets/images/mind_map.png',
    'assets/images/project_bg.png',
    'assets/images/row.png',
    'assets/images/slack.png',
    'assets/images/sous_vide.png',
  ];

  bool _preloadStarted = false;

  @override
  void initState() {
    super.initState();

    // Бесконечный, полностью цикличный луп — никогда не сбрасывается
    // на 0 "резко": repeat() плавно продолжает с 0 после 1, а поскольку
    // все визуальные параметры считаются через sin()/cos(), значение
    // в момент t=0 и t=1 совпадает идеально — швов не видно.
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _progressAnim = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    );

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_preloadStarted) {
      _preloadStarted = true;
      _preloadAssets();
    }
  }

  Future<void> _preloadAssets() async {
    final total = assetsToPreload.length;
    for (int i = 0; i < total; i++) {
      if (!mounted) return;
      await precacheImage(AssetImage(assetsToPreload[i]), context);
      _progressController.animateTo(
        (i + 1) / total,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
      await Future.delayed(const Duration(milliseconds: 60));
    }
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    // Переход стартует прямо с текущей фазы цикла — loopController
    // не останавливается и не сбрасывается, поэтому глазу не за что
    // "зацепиться" как за обрыв анимации.
    await _startTransition();
  }

  Future<void> _startTransition() async {
    await _transitionController.forward();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, _) => const LandingPage(),
        transitionsBuilder: (_, animation, _, child) {
          final fade = CurvedAnimation(parent: animation, curve: Curves.easeIn);
          final scale = Tween<double>(begin: 1.06, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );
          return FadeTransition(
            opacity: fade,
            child: ScaleTransition(scale: scale, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _loopController.dispose();
    _progressController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _transitionController,
        builder: (context, child) {
          final t = _transitionController.value;
          return Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: (1 - t).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 1.0 + t * 0.35,
                  child: _buildContent(),
                ),
              ),
              if (t > 0)
                IgnorePointer(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 2 * t,
                      height: MediaQuery.of(context).size.width * 2 * t,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: (1 - t) * 0.9),
                            const Color(
                              0xFF9FA8DA,
                            ).withValues(alpha: (1 - t) * 0.5),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              if (t > 0.55)
                Opacity(
                  opacity: ((t - 0.55) / 0.45).clamp(0.0, 1.0),
                  child: Container(color: Colors.white),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _loopController,
            builder: (context, child) {
              final breathe =
                  0.5 + 0.5 * math.sin(_loopController.value * 2 * math.pi);
              return Opacity(opacity: 0.85 + breathe * 0.15, child: child);
            },
            child: Text(
              "PORTFOLIO",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 60.h),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (row) {
              return Padding(
                padding: EdgeInsets.only(bottom: row < 2 ? 18.h : 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (col) {
                    final index = row * 3 + col;
                    final phase = (row * 0.33 + col * 0.17) * 2 * math.pi;
                    final speed = 0.8 + (index % 3) * 0.35;

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: AnimatedBuilder(
                        animation: _loopController,
                        builder: (context, child) {
                          final t =
                              _loopController.value * speed * 2 * math.pi +
                              phase;
                          final wave = 0.5 + 0.5 * math.sin(t);
                          final opacity = 0.25 + wave * 0.75;
                          final scale = 0.75 + wave * 0.45;
                          final lift = math.sin(t + math.pi / 2) * 3.0;

                          return Transform.translate(
                            offset: Offset(0, -lift),
                            child: Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 14.w,
                                height: 14.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF9FA8DA),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF9FA8DA,
                                      ).withValues(alpha: opacity * 0.8),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
          SizedBox(height: 40.h),
          AnimatedBuilder(
            animation: _progressAnim,
            builder: (context, child) {
              final pct = (_progressAnim.value * 100).clamp(0, 100).toInt();
              return Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: const Color(0xFF9FA8DA),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
