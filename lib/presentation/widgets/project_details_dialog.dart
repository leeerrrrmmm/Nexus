import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_assets/asset_image_cache.dart';

Future<void> showProjectDetailsDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String description,
  required String imagePath,
  required List<Color> colors,
  required VoidCallback onOpenProject,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => ProjectDetailsDialog(
      title: title,
      subtitle: subtitle,
      description: description,
      imagePath: imagePath,
      colors: colors,
      onOpenProject: onOpenProject,
    ),
  );
}

class ProjectDetailsDialog extends StatelessWidget {
  const ProjectDetailsDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.colors,
    required this.onOpenProject,
  });

  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final List<Color> colors;
  final VoidCallback onOpenProject;

  static const Map<String, String> _highlights = {
    'E-CHAT':
        'Shopping stays in the conversation: browse product cards, use promo codes, and complete an order without leaving the chat.',
    'Mind Map':
        'Connect tasks on an interactive map and see the structure of the entire project at a glance.',
    'Slack':
        'Channels, direct messages, threads, and search keep team conversations structured and easy to follow.',
    'Collabix':
        'Chat and an infinite canvas share one workspace, with task progress updated directly on each card.',
    'Sous vide':
        'A cooking calculator finds the time and temperature for each ingredient and preferred doneness.',
  };

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final isMobile = screen.width < 600;
    final accent = colors.length > 1 ? colors.last : const Color(0xFF8C73FF);

    return Dialog(
      backgroundColor: const Color(0xFF17171D),
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 14 : 32,
        vertical: isMobile ? 16 : 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 26 : 32),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 920,
          maxHeight: screen.height * (isMobile ? 0.94 : 0.88),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -100,
              child: IgnorePointer(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.22),
                        blurRadius: 100,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 18 : 30,
                isMobile ? 18 : 26,
                isMobile ? 18 : 30,
                isMobile ? 22 : 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'PROJECT CASE',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 11.sp.clamp(10.0, 13.0),
                            letterSpacing: 2.4,
                            fontFamily: 'Kosugi',
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close project details',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.white70,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
                    child: AspectRatio(
                      aspectRatio: isMobile ? 1.55 : 2.35,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            cacheWidth: AssetImageCache.cacheWidth(
                              context,
                              imagePath,
                            ),
                            filterQuality: FilterQuality.medium,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.82),
                                ],
                                stops: const [0.38, 1],
                              ),
                            ),
                          ),
                          Positioned(
                            left: isMobile ? 16 : 24,
                            right: isMobile ? 16 : 24,
                            bottom: isMobile ? 14 : 22,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Kokh',
                                    fontSize: (screen.width * 0.055).clamp(
                                      25.0,
                                      46.0,
                                    ),
                                    height: 1,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.78),
                                    fontSize: 13.sp.clamp(12.0, 17.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _ProjectTag(
                        icon: Icons.badge_outlined,
                        label: 'Flutter Developer',
                        accent: accent,
                      ),
                      _ProjectTag(
                        icon: Icons.code_rounded,
                        label: 'Flutter · Dart · Firebase',
                        accent: accent,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _SectionHeading(title: 'About the project', accent: accent),
                  SizedBox(height: 8.h),
                  Text(
                    description.trim(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 14.sp.clamp(13.0, 17.0),
                      height: 1.65,
                      fontFamily: 'Kosugi',
                    ),
                  ),
                  SizedBox(height: 22.h),
                  _SectionHeading(title: 'Project highlight', accent: accent),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 15 : 18),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: accent.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _highlights[title] ??
                          'A thoughtfully built Flutter application.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 13.sp.clamp(12.0, 16.0),
                        height: 1.55,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onOpenProject();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: accent.withValues(alpha: 0.22),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: accent.withValues(alpha: 0.55)),
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 15 : 17,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.north_east_rounded),
                      label: const Text('Open project'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.accent});

  final String title;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp.clamp(15.0, 20.0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectTag extends StatelessWidget {
  const _ProjectTag({
    required this.icon,
    required this.label,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: accent),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.86),
                fontSize: 11.sp.clamp(10.0, 13.0),
                fontFamily: 'Kosugi',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
