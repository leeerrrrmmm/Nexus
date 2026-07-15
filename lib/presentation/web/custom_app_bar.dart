import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Function(int) onNavItemTap;
  final int currentIndex; 

  const CustomAppBar({
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
    final bar = Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: kIsWeb ? 0.88 : 0.4,
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.transparent,
              ],
              stops: const [0.0, 0.25],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              // ================= СЛЕВА: MAC-STYLE DOTS =================
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 25),

              // ================= ПО ЦЕНТРУ: НАВИГАЦИЯ =================
              Expanded(
                child: Row(
                  children: navItems.asMap().entries.map((entry) {
                    final int idx = entry.key;
                    final String item = entry.value;
                    final bool isActive = currentIndex == idx;

                    return _AppBarButton(
                      title: item,
                      isActive: isActive,
                      onTap: () => onNavItemTap(idx),
                    );
                  }).toList(),
                ),
              ),

              // ================= СПРАВА: СЕЛЕКТОР ЯЗЫКОВ =================
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EN',
                    style: TextStyle(
                      color: Color(0xFF8A7CFF), // Активный неоново-лиловый
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'UKR',
                    style: TextStyle(
                      color: Colors.white38, // Приглушенный язык
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
    );

    return ClipRect(
      child: kIsWeb
          ? bar
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: bar,
            ),
    );
  }
}

class _AppBarButton extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _AppBarButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_AppBarButton> createState() => _AppBarButtonState();
}

class _AppBarButtonState extends State<_AppBarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Цвета из Screenshot 2026-07-10 at 15.30.51.png
    final Color activeColor = const Color(
      0xFF9FA8DA,
    ); // Неоново-лиловый / фиолетовый оттенок
    final Color inactiveColor = Colors.white.withValues(alpha: 0.35);
    final Color hoverColor = Colors.white.withValues(alpha: 0.7);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            // Если элемент НЕ активен, оборачиваем его в тонкую контурную рамку, как в дизайне
            border: Border.all(
              color: widget.isActive
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: _isHovered ? 0.15 : 0.05),
            ),
            borderRadius: BorderRadius.circular(10),
            color: widget.isActive
                ? Colors.white.withValues(alpha: 0.03)
                : Colors.transparent,
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: widget.isActive
                  ? activeColor
                  : (_isHovered ? hoverColor : inactiveColor),
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
              letterSpacing: 0.3,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
