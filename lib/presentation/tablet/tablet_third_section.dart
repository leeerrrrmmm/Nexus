import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/const/app_assets/asset_image_cache.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/core/links/portfolio_link_scope.dart';
import 'package:portfolio/presentation/components/gradient_text_title.dart';
import 'package:portfolio/presentation/widgets/glass_container_widget.dart';
import 'package:portfolio/presentation/widgets/project_details_dialog.dart';

class TabletThirdSection extends StatefulWidget {
  const TabletThirdSection({super.key});

  @override
  State<TabletThirdSection> createState() => _TabletThirdSectionState();
}

enum _AxisLock { none, horizontal, vertical }

class _TabletThirdSectionState extends State<TabletThirdSection> {
  late final PageController _projectPageController;

  static const int _realItemCount = 5;
  static const int _initialPage = 10000;

  late final ValueNotifier<double> _pageNotifier;

  Timer? _snapTimer;
  Timer? _axisLockTimer;

  _AxisLock _pointerAxisLock = _AxisLock.none;
  double _pendingDx = 0;
  double _pendingDy = 0;

  static const double _axisDecideThreshold = 6;

  final List<String> _projectTitles = const [
    'E-CHAT',
    'Mind Map',
    'Slack',
    'Collabix',
    'Sous vide',
  ];

  final List<String> _projectSubtitles = const [
    'Communication app',
    'Task manager',
    'Team communication',
    'Workspaces',
    'Reference',
  ];

  static const List<String> _dummyDescriptions = [
    '''
    An innovative e-commerce messenger designed to transform standard online shopping into a dynamic, personalized conversation between brands and customers. This platform removes communication barriers, allowing users and sellers to exchange interactive product cards, discuss order details, apply promo codes, and complete secure one-click payments right inside the chat window. A built-in tracking system lets customers view their delivery status in real time without leaving the conversation, while smart bots instantly handle FAQs. It elevates customer service, making online shopping as seamless as texting a friend.
    ''',
    '''
    A next-generation task manager that redefines how you organize daily workflows and map out complex projects. The app allows users to organize tasks into standard default categories or create custom folders tailored to specific personal or professional needs. Its defining feature is a seamless integration with an interactive visualization board. Instead of managing dull, linear to-do lists, you can build connections between tasks, create interactive mind maps, group cards contextually, and view the entire architecture of your project at a glance. It is the ultimate tool for unlocking visual thinking and mastering productivity.
    ''',
    '''
    A full-featured corporate messenger designed to streamline team communication and eliminate the chaos of cluttered workspaces. The app offers an intuitive ecosystem featuring public and private channels for project-specific discussions, direct messages for quick one-on-one chats, and structured threads that keep conversations organized. Users can instantly share files of any format, customize profiles, flexibly adjust notification schedules, and use advanced search to navigate chat history. It is the perfect solution for distributed teams looking to stay synchronized, maintain momentum, and collaborate effortlessly within a unified digital environment.
    ''',
    ''' 
    An all-in-one collaboration platform that seamlessly bridges the gap between corporate messaging and the visual power of interactive boards. Forget toggling between multiple tabs: here, you can chat with your team to brainstorm ideas and instantly map them out on an infinite Miro-style canvas. The standout feature is its interactive task cards. Each card functions as a fully operational task element, allowing users to update its status in real time based on their current progress. This enables teams to not only visualize complex workflows but also track project momentum directly inside a single workspace.
    ''',
    '''
    A smart culinary assistant tailored for chefs and precision cooking enthusiasts aiming for consistent, restaurant-quality results at home. The heart of the app is an intuitive time and temperature calculator for sous vide cooking. It completely eliminates guesswork, helping users select perfect parameters for meat, fish, or vegetables based on desired doneness. Beyond calculations, the app features a curated collection of recipes—including refined bar-style creations—with step-by-step guidance. An integrated equipment guide helps users understand essential tools and how to utilize them effectively in any kitchen environment.
    ''',
  ];

  static final Map<String, List<Color>> _projectColors = {
    'E-CHAT': [Color(0xFFFFFFFF), Color(0xFF8095C3), Color(0xFF8095C3)],
    'Mind Map': [
      Color(0xFFFFFFFF),
      Color.fromARGB(201, 226, 108, 108),
      Color(0xFFE45756),
    ],
    'Slack': [
      Color(0xFFFFFFFF),
      Color.fromARGB(255, 66, 65, 65),
      Color.fromARGB(175, 104, 101, 101),
    ],
    'Collabix': [
      Color(0xFFFFFFFF),
      Color.fromARGB(152, 125, 185, 0),
      Color.fromARGB(152, 125, 185, 4),
    ],
    'Sous vide': [
      Color(0xFFFFFFFF),
      Color.fromARGB(184, 128, 91, 51),
      Color.fromARGB(230, 128, 91, 51),
    ],
  };

  @override
  void initState() {
    super.initState();

    _pageNotifier = ValueNotifier<double>(_initialPage.toDouble());

    _projectPageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.58, // лучше для планшета
    );

    _projectPageController.addListener(() {
      final page = _projectPageController.page;
      if (page != null) {
        _pageNotifier.value = page;
      }
    });
  }

  @override
  void dispose() {
    _snapTimer?.cancel();
    _axisLockTimer?.cancel();
    _projectPageController.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }

  void _jumpBy(double delta) {
    if (!_projectPageController.hasClients) return;
    if (delta == 0) return;
    final position = _projectPageController.position;
    position.jumpTo(
      (position.pixels + delta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
    );
  }

  void _snapToNearestPage({double velocity = 0}) {
    if (!_projectPageController.hasClients) return;
    final page = _projectPageController.page;
    if (page == null) return;

    final int target;
    if (velocity < -400) {
      target = page.ceil();
    } else if (velocity > 400) {
      target = page.floor();
    } else {
      target = page.round();
    }

    _projectPageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _scheduleSnap() {
    _snapTimer?.cancel();
    _snapTimer = Timer(const Duration(milliseconds: 90), _snapToNearestPage);
  }

  void _keepPointerAxisLockAlive() {
    _axisLockTimer?.cancel();
    _axisLockTimer = Timer(const Duration(milliseconds: 160), () {
      _pointerAxisLock = _AxisLock.none;
      _pendingDx = 0;
      _pendingDy = 0;
    });
  }

  _AxisLock _resolveAxis(double dx, double dy) {
    if (dx.abs() > dy.abs()) return _AxisLock.horizontal;
    return _AxisLock.vertical;
  }

  void _handlePointerScroll(PointerScrollEvent event) {
    final dx = event.scrollDelta.dx;
    final dy = event.scrollDelta.dy;

    if (_pointerAxisLock == _AxisLock.none) {
      _pendingDx += dx;
      _pendingDy += dy;

      if (_pendingDx.abs() < _axisDecideThreshold &&
          _pendingDy.abs() < _axisDecideThreshold) {
        GestureBinding.instance.pointerSignalResolver.register(event, (_) {});
        _keepPointerAxisLockAlive();
        return;
      }

      _pointerAxisLock = _resolveAxis(_pendingDx, _pendingDy);

      if (_pointerAxisLock == _AxisLock.horizontal) {
        GestureBinding.instance.pointerSignalResolver.register(event, (_) {
          _jumpBy(_pendingDx);
          _pendingDx = 0;
          _pendingDy = 0;
          _scheduleSnap();
        });
        _keepPointerAxisLockAlive();
        return;
      }

      _pendingDx = 0;
      _pendingDy = 0;
      _keepPointerAxisLockAlive();
      return;
    }

    _keepPointerAxisLockAlive();

    if (_pointerAxisLock == _AxisLock.horizontal) {
      GestureBinding.instance.pointerSignalResolver.register(event, (
        resolvedEvent,
      ) {
        final scroll = resolvedEvent as PointerScrollEvent;
        _jumpBy(scroll.scrollDelta.dx);
        _scheduleSnap();
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 0.95.sh,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImageCache.provider(context, AppAssets.projectBg),
          fit: BoxFit.cover,
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1.w,
          ),
        ),
      ),
      child: Column(
        children: [
          GradientTextTitle(
            text: AppText.projectTitle,
            fontSize: (MediaQuery.sizeOf(context).width * 0.085)
                .clamp(54.0, 72.0)
                .toDouble(),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Listener(
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    _handlePointerScroll(event);
                  }
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: (_) => _snapTimer?.cancel(),
                  onHorizontalDragUpdate: (details) =>
                      _jumpBy(-details.delta.dx),
                  onHorizontalDragEnd: (details) => _snapToNearestPage(
                    velocity: details.primaryVelocity ?? 0,
                  ),
                  onHorizontalDragCancel: () => _snapToNearestPage(),
                  child: PageView.builder(
                    controller: _projectPageController,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    clipBehavior: Clip.none,
                    allowImplicitScrolling: true,
                    itemBuilder: (context, index) {
                      final int realIndex = index % _realItemCount;

                      return RepaintBoundary(
                        child: ValueListenableBuilder<double>(
                          valueListenable: _pageNotifier,
                          builder: (context, page, child) {
                            final double pageOffset = page - index;
                            double scale = 1.08 - (pageOffset.abs() * 0.18);
                            scale = scale.clamp(0.85, 1.08);

                            double opacity = 1 - (pageOffset.abs() * 0.55);
                            opacity = opacity.clamp(0.4, 1.0);

                            return Transform.scale(
                              scale: scale,
                              filterQuality: FilterQuality.high,
                              child: Opacity(opacity: opacity, child: child),
                            );
                          },
                          child: _TabletProjectCard(
                            title: _projectTitles[realIndex],
                            subtitle: _projectSubtitles[realIndex],
                            description: _dummyDescriptions[realIndex],
                            projectColors: _projectColors,
                            index: realIndex,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Tablet Project Card ====================
class _TabletProjectCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final int index;
  final Map<String, List<Color>> projectColors;

  const _TabletProjectCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.index,
    required this.projectColors,
  });

  @override
  State<_TabletProjectCard> createState() => _TabletProjectCardState();
}

class _TabletProjectCardState extends State<_TabletProjectCard> {
  void _openDetails() {
    final imagePath = AppAssets().projectImages[widget.index];
    showProjectDetailsDialog(
      context: context,
      title: widget.title,
      subtitle: widget.subtitle,
      description: widget.description,
      imagePath: imagePath,
      colors: widget.projectColors[widget.title] ?? const [],
      onOpenProject: () => PortfolioLinkScope.of(context)(
        PortfolioLinkX.fromProjectTitle(widget.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trimmedDescription = widget.description.trim();

    return Align(
      alignment: Alignment.center,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _openDetails,
          child: GlassContainerWidget(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                Colors.white.withValues(alpha: 0.1),
                const Color(0xFF7C62FE).withValues(alpha: 0.1),
                const Color(0xFF7C62FE).withValues(alpha: 0.1),
              ],
            ),
            height: 620,
            width: 380,
            padding: EdgeInsets.all(3.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CustomMacElement(
                      width: 68.w,
                      height: 28.h,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(28.r),
                        topLeft: Radius.circular(90.r),
                      ),
                      boxBorder: Border(
                        right: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.w,
                        ),
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 4.r,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          CircleAvatar(
                            radius: 4.r,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          CircleAvatar(
                            radius: 4.r,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _CustomMacElement(
                      width: 280.w,
                      height: 28.h,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(120.r),
                        bottomLeft: Radius.circular(28.r),
                      ),
                      boxBorder: Border(
                        right: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.w,
                        ),
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.w,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'VIEW DETAILS',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 9.sp,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.north_east_rounded,
                              color: Colors.white.withValues(alpha: 0.5),
                              size: 12.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 8.h, left: 12.w, right: 12.w),
                    height: 190.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.asset(
                        AppAssets().projectImages[widget.index],
                        fit: BoxFit.cover,
                        cacheWidth: AssetImageCache.cacheWidth(
                          context,
                          AppAssets().projectImages[widget.index],
                        ),
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: GradientTextTitle(
                    alignment: Alignment.centerLeft,
                    text: widget.title,
                    fontSize: 22.sp,
                    fontFamily: 'Kokh',
                  ),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: GradientTextTitle(
                    alignment: Alignment.centerLeft,
                    text: widget.subtitle,
                    fontSize: 20.sp,
                    fontFamily: 'Kokh',
                  ),
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Text(
                      trimmedDescription,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.45,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                  height: 55.h,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 14.w,
                      right: 14.w,
                      bottom: 8.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42.w,
                          height: 42.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F1F22),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.w,
                            ),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.github,
                              size: 24.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            PortfolioLinkScope.of(context)(
                              PortfolioLinkX.fromProjectTitle(widget.title),
                            );
                          },
                          child: Container(
                            width: 42.w,
                            height: 42.w,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.2.w,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: const Color(0xFF8C73FF),
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomMacElement extends StatelessWidget {
  final double width;
  final double height;
  final BoxBorder boxBorder;
  final Widget? child;
  final BorderRadius borderRadius;

  const _CustomMacElement({
    required this.width,
    required this.height,
    required this.boxBorder,
    this.child,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(15, 0, 0, 0).withValues(alpha: 0.24),
        borderRadius: borderRadius,
        border: boxBorder,
      ),
      child: child,
    );
  }
}
