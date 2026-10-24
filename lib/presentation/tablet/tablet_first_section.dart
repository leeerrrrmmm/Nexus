import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/presentation/widgets/glass_text.dart';

class TabletFirstSection extends StatefulWidget {
  const TabletFirstSection({super.key});

  @override
  State<TabletFirstSection> createState() => _TabletFirstSectionState();
}

class _TabletFirstSectionState extends State<TabletFirstSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_GlowParticle> _particles = [];
  final int _particleCount = 12;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final random = math.Random();

      for (int i = 0; i < _particleCount; i++) {
        _particles.add(
          _GlowParticle(
            size: 120.w + random.nextDouble() * 280.w,
            opacity: 0.08 + random.nextDouble() * 0.35,
            random: random,
            screenSize: size,
          ),
        );
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      height: 1.sh,
      child: Stack(
        children: [
          if (_particles.isNotEmpty)
            Positioned.fill(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      children: _particles.map((particle) {
                        final offset = particle.getOffset(
                          _controller.value * 2 * math.pi,
                          screenSize,
                        );
                        return Positioned(
                          left: offset.dx - particle.size / 2,
                          top: offset.dy - particle.size / 2,
                          child: _buildGlowOrb(
                            const Color(0xff4F8BFF),
                            particle.size,
                            particle.opacity,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),

          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1100.w),
              child: SizedBox(
                width: double.infinity,
                height: 380.h,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff2C2C2C).withValues(alpha: 0.55),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.18),
                            width: 1.5.w,
                          ),
                          bottom: BorderSide(
                            color: Colors.white.withValues(alpha: 0.18),
                            width: 1.5.w,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.w),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: GlassText(
                              text: AppText.portfolioText,
                              fontSize: 140.sp.clamp(130.0, 210.0),
                              letterSpacing: -10.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowOrb(Color color, double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

// _GlowParticle остаётся тот же (можно вынести в отдельный файл позже)
class _GlowParticle {
  final double size;
  final double opacity;
  late Offset baseOffset;
  late double _dxRandom, _dyRandom, _freqX, _freqY;

  _GlowParticle({
    required this.size,
    required this.opacity,
    required math.Random random,
    required Size screenSize,
  }) {
    _dxRandom = 60 + random.nextDouble() * 180;
    _dyRandom = 60 + random.nextDouble() * 160;
    _freqX = 0.4 + random.nextDouble() * 1.4;
    _freqY = 0.4 + random.nextDouble() * 1.4;

    double maxBottom = screenSize.height - 60.h;
    double maxBaseY = maxBottom - _dyRandom.h - (size / 2);
    if (maxBaseY < 0) maxBaseY = 0;

    baseOffset = Offset(
      random.nextDouble() * screenSize.width,
      80.h + random.nextDouble() * (maxBaseY - 80.h),
    );
  }

  Offset getOffset(double t, Size screenSize) {
    double x = baseOffset.dx + math.sin(t * _freqX) * _dxRandom.w;
    double y = baseOffset.dy + math.cos(t * _freqY) * _dyRandom.h;

    if (x < -size / 2) x = screenSize.width + size / 2;
    if (x > screenSize.width + size / 2) x = -size / 2;

    return Offset(x, y);
  }
}
