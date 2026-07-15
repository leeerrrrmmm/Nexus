import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MobileAppBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavItemTap;

  const MobileAppBar({
    super.key,
    required this.currentIndex,
    required this.onNavItemTap,
  });

  static const List<String> navItems = [
    'Header',
    'About me',
    'Project',
    'Live Mobile App',
    'Library',
    'Contact me',
  ];

  static const Color _activeColor = Color(0xFF9FA8DA);

  @override
  Widget build(BuildContext context) {
    final bar = Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: kIsWeb ? 0.88 : 0.45),
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
            Colors.white.withValues(alpha: 0.07),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3],
        ),
      ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  // ================= MAC-STYLE DOTS =================
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          width: 6,
                          height: 6,
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

                  const SizedBox(width: 12),

                  // ================= АКТИВНАЯ СЕКЦИЯ (по центру) =================
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRect(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final offsetAnim = Tween<Offset>(
                              begin: const Offset(0, 0.4),
                              end: Offset.zero,
                            ).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: offsetAnim,
                                child: child,
                              ),
                            );
                          },
                          child: Row(
                            key: ValueKey<int>(currentIndex),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _activeColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  navItems[currentIndex],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: _activeColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ================= ЯЗЫК =================
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Text(
                      'EN',
                      style: TextStyle(
                        color: _activeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // ================= ГАМБУРГЕР =================
                  GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withValues(alpha: 0.03),
                      ),
                      child: Icon(
                        Icons.menu_rounded,
                        color: Colors.white.withValues(alpha: 0.85),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
