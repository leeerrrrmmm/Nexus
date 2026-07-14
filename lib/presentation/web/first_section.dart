import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/presentation/widgets/glass_text.dart';

class FirstSectionContent extends StatefulWidget {
  const FirstSectionContent({super.key});

  @override
  State<FirstSectionContent> createState() => _FirstSectionContentState();
}

class _FirstSectionContentState extends State<FirstSectionContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_GlowParticle> _particles = [];
  final int _particleCount = 10;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final random = math.Random();

      for (int i = 0; i < _particleCount; i++) {
        _particles.add(
          _GlowParticle(
            size: 100.w + random.nextDouble() * 250.w,
            opacity: 0.1 + random.nextDouble() * 0.4,
            random: random,
            screenSize: size, // Передаем размеры экрана внутрь частицы
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
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 315.h,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff2C2C2C).withValues(alpha: 0.6),
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
                        padding: EdgeInsets.only(top: 20.w),
                        child: GlassText(
                          text: AppText.portfolioText,
                          fontSize: 248.sp,
                          letterSpacing: -19.0,
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

// Класс, описывающий один анимированный огонек
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
    _dxRandom = 50 + random.nextDouble() * 150;
    _dyRandom = 50 + random.nextDouble() * 150;
    _freqX = 0.5 + random.nextDouble() * 1.5;
    _freqY = 0.5 + random.nextDouble() * 1.5;

    // --- ЛОГИКА ОГРАНИЧЕНИЯ НИЖНЕЙ ЗОНЫ ---
    // 1. Устанавливаем абсолютный лимит: 40 пикселей от нижнего края экрана
    double maxBottom = screenSize.height - 40.h;

    // 2. Рассчитываем допустимую стартовую позицию.
    // Учитываем амплитуду (_dyRandom.h) и радиус шарика (size / 2),
    // чтобы даже на пике нижнего колебания край свечения не пробил лимит maxBottom.
    double maxBaseY = maxBottom - _dyRandom.h - (size / 2);
    if (maxBaseY < 0) maxBaseY = 0;

    // 3. Немного отступаем сверху, чтобы шарики не спавнились далеко за верхним краем
    double minBaseY = _dyRandom.h;
    if (minBaseY > maxBaseY) minBaseY = maxBaseY;

    // Генерируем случайную позицию в жестко заданных и безопасных рамках
    baseOffset = Offset(
      random.nextDouble() * screenSize.width,
      minBaseY + random.nextDouble() * (maxBaseY - minBaseY),
    );
  }

  Offset getOffset(double t, Size screenSize) {
    double x = baseOffset.dx + math.sin(t * _freqX) * _dxRandom.w;
    double y = baseOffset.dy + math.cos(t * _freqY) * _dyRandom.h;

    // Обертывание экрана ТОЛЬКО по бокам (X).
    // По оси Y обертывание больше не нужно, так как математика в конструкторе
    // гарантирует, что шарик никогда не выйдет за заданные границы снизу.
    if (x < -size / 2) x = screenSize.width + size / 2;
    if (x > screenSize.width + size / 2) x = -size / 2;

    return Offset(x, y);
  }
}
