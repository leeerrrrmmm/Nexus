import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedTextSection extends StatefulWidget {
  final bool isMobile;
  const AnimatedTextSection({required this.isMobile, super.key});

  @override
  State<AnimatedTextSection> createState() => _AnimatedTextSectionState();
}

class _AnimatedTextSectionState extends State<AnimatedTextSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> words = [
      "#",
      "Live Mobile Applications",
      "#",
      "Libraries",
    ];

    final Widget rowContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: words.map((word) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            word,
            style: TextStyle(
              color: word == "Live Mobile Applications"
                  ? Color(0xFF7B61FF)
                  : Color(0xFFFFFFFF),
              fontSize: widget.isMobile ? 17.5.sp : 32.sp,
              fontFamily: 'Kosugi',
            ),
          ),
        );
      }).toList(),
    );
    return Container(
      decoration: BoxDecoration(
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
      height: widget.isMobile ? 40.h : 92.h,
      width: double.infinity,
      child: ClipRect(
        child: RepaintBoundary(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FractionalTranslation(
                  translation: Offset(-_animationController.value * 0.5, 0),
                  child: child,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [rowContent, rowContent, rowContent, rowContent],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
