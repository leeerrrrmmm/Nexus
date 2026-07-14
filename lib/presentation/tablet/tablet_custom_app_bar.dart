import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabletCustomAppBar extends StatelessWidget {
  final Function(int) onNavItemTap;
  final int currentIndex;

  const TabletCustomAppBar({
    super.key,
    required this.onNavItemTap,
    required this.currentIndex,
  });

  static const List<String> navItems = [
    'Header',
    'About me',
    'Project',
    'Live Mobile App',
    'Library',
    'Contact me',
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.09),
                Colors.transparent,
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              // Dots
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.09),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: 9.w,
                      height: 9.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 32.w),

              // Навигация — делаем flexible
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: navItems.asMap().entries.map((entry) {
                      final int idx = entry.key;
                      final String item = entry.value;
                      final bool isActive = currentIndex == idx;

                      return _TabletAppBarButton(
                        title: item,
                        isActive: isActive,
                        onTap: () => onNavItemTap(idx),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(width: 32.w),

              // Языки
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'EN',
                    style: TextStyle(
                      color: Color(0xFF8A7CFF),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'UKR',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabletAppBarButton extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabletAppBarButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_TabletAppBarButton> createState() => _TabletAppBarButtonState();
}

class _TabletAppBarButtonState extends State<_TabletAppBarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF9FA8DA);
    final Color inactiveColor = Colors.white.withValues(alpha: 0.45);
    final Color hoverColor = Colors.white.withValues(alpha: 0.85);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.isActive
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: _isHovered ? 0.2 : 0.08),
            ),
            borderRadius: BorderRadius.circular(12),
            color: widget.isActive
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.transparent,
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: widget.isActive
                  ? activeColor
                  : (_isHovered ? hoverColor : inactiveColor),
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              fontSize: 15.5,
              letterSpacing: 0.4,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
