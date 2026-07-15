import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/presentation/widgets/glass_text.dart';

class MobileFirstSection extends StatefulWidget {
  const MobileFirstSection({super.key});

  @override
  State<MobileFirstSection> createState() => _MobileFirstSectionState();
}

class _MobileFirstSectionState extends State<MobileFirstSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_GlowParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initParticles();
    });
  }

  void _initParticles() {
    final size = MediaQuery.of(context).size;
    final random = math.Random();

    _particles.clear();

    final particleCount = kIsWeb ? 3 : 6;
    for (int i = 0; i < particleCount; i++) {
      _particles.add(
        _GlowParticle(
          size: 60.w + random.nextDouble() * 140.w,
          opacity: 0.1 + random.nextDouble() * 0.35,
          random: random,
          screenSize: size,
        ),
      );
    }
    if (mounted) setState(() {});
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
      height: 0.25.sh,
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
            child: SizedBox(
              width: double.infinity,
              height: 220.h,
              child: ClipRect(
                child: Builder(
                  builder: (context) {
                    final band = Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff2C2C2C).withValues(
                          alpha: kIsWeb ? 0.82 : 0.6,
                        ),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1.w,
                          ),
                          bottom: BorderSide(
                            color: Colors.white.withValues(alpha: 0.15),
                            width: 1.w,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.w),
                          child: GlassText(
                            text: AppText.portfolioText,
                            fontSize: 80.sp,
                            letterSpacing: -6.0,
                          ),
                        ),
                      ),
                    );
                    if (kIsWeb) return band;
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: band,
                    );
                  },
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

class _GlowParticle {
  final double size;
  final double opacity;

  late Offset baseOffset;
  late double _dxRandom;
  late double _dyRandom;
  late double _freqX;
  late double _freqY;

  _GlowParticle({
    required this.size,
    required this.opacity,
    required math.Random random,
    required Size screenSize,
  }) {
    _dxRandom = 40 + random.nextDouble() * 90;
    _dyRandom = 30 + random.nextDouble() * 80;
    _freqX = 0.6 + random.nextDouble() * 1.4;
    _freqY = 0.6 + random.nextDouble() * 1.4;

    double maxBottom = screenSize.height - 60.h;
    double maxBaseY = maxBottom - _dyRandom.h - (size / 2);
    if (maxBaseY < 0) maxBaseY = 0;

    double minBaseY = _dyRandom.h;
    if (minBaseY > maxBaseY) minBaseY = maxBaseY;

    baseOffset = Offset(
      random.nextDouble() * screenSize.width,
      minBaseY + random.nextDouble() * (maxBaseY - minBaseY),
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
