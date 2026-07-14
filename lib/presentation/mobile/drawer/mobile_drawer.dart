import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:portfolio/presentation/web/custom_app_bar.dart';

class MobileDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavItemTap;

  const MobileDrawer({
    super.key,
    required this.currentIndex,
    required this.onNavItemTap,
  });

  static const Color _activeColor = Color(0xFF9FA8DA);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.87),
              border: Border(
                right: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ================= HEADER =================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Row(
                      children: [
                        // Mac-style dots
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
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2.5,
                                ),
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
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    color: Colors.white24,
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                  ),

                  // ================= NAVIGATION ITEMS =================
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: CustomAppBar.navItems.length,
                      itemBuilder: (context, index) {
                        final item = CustomAppBar.navItems[index];
                        final isActive = index == currentIndex;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              onNavItemTap(index);
                            },
                            splashColor: _activeColor.withValues(alpha: 0.1),
                            highlightColor: _activeColor.withValues(
                              alpha: 0.08,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: isActive
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  // Активный индикатор
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: 5,
                                    height: isActive ? 24 : 0,
                                    decoration: BoxDecoration(
                                      color: _activeColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Текст с эффектом
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 17.5,
                                        fontWeight: isActive
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        letterSpacing: 0.4,
                                        color: isActive
                                            ? Colors.white
                                            : Colors.white70,
                                        shadows: isActive
                                            ? [
                                                Shadow(
                                                  color: _activeColor
                                                      .withValues(alpha: 0.5),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 0),
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // ================= FOOTER =================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    child: Column(
                      children: [
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 24),
                        Text(
                          'EN',
                          style: TextStyle(
                            color: _activeColor,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '© 2026',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
