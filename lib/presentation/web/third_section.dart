import 'dart:async';
import 'dart:ui' show lerpDouble, ImageFilter;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/core/links/portfolio_link_scope.dart';
import 'package:portfolio/presentation/components/gradient_text_title.dart';
import 'package:portfolio/presentation/widgets/glass_container_widget.dart';

class ThirdSection extends StatefulWidget {
  const ThirdSection({super.key});

  @override
  State<ThirdSection> createState() => _ThirdSectionState();
}

enum _AxisLock { none, horizontal, vertical }

class _ThirdSectionState extends State<ThirdSection> {
  late final PageController _projectPageController;

  static const int _realItemCount = 5;
  static const int _initialPage = 10000;

  // ValueNotifier вместо setState -> не ребилдит весь Column/секцию на каждый пиксель скролла
  late final ValueNotifier<double> _pageNotifier;

  Timer? _snapTimer;
  Timer? _axisLockTimer;

  // Ось фиксируется на весь жест: пока lock = horizontal,
  // вертикальный компонент полностью глотается и не уходит в страницу.
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
      viewportFraction: 0.49,
    );

    // Лёгкий листенер: просто пишет значение в ValueNotifier,
    // без setState на весь виджет.
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

      // Ждём накопленное движение, чтобы шум трекпада не выбрал ось рано
      if (_pendingDx.abs() < _axisDecideThreshold &&
          _pendingDy.abs() < _axisDecideThreshold) {
        // Пока не решили — глотаем сигнал, иначе страница уже поедет
        // по «шумному» dy до выбора оси.
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

      // vertical: сбрасываем pending и НЕ регистрируемся —
      // этот и следующие события уйдут в страницу.
      _pendingDx = 0;
      _pendingDy = 0;
      _keepPointerAxisLockAlive();
      return;
    }

    _keepPointerAxisLockAlive();

    if (_pointerAxisLock == _AxisLock.horizontal) {
      // Забираем ВЕСЬ сигнал на время горизонтального жеста —
      // остаточный dy не должен двигать страницу.
      GestureBinding.instance.pointerSignalResolver.register(event, (
        resolvedEvent,
      ) {
        final scroll = resolvedEvent as PointerScrollEvent;
        _jumpBy(scroll.scrollDelta.dx);
        _scheduleSnap();
      });
      return;
    }

    // vertical lock: не регистрируемся — страница скроллится сама,
    // карусель полностью игнорирует этот жест.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.1.sh,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.projectBg),
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
          const GradientTextTitle(text: AppText.projectTitle),
          SizedBox(
            height: 580.h,
            width: double.infinity,
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  _handlePointerScroll(event);
                }
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: (_) {
                  _snapTimer?.cancel();
                },
                onHorizontalDragUpdate: (details) {
                  _jumpBy(-details.delta.dx);
                },
                onHorizontalDragEnd: (details) {
                  _snapToNearestPage(velocity: details.primaryVelocity ?? 0);
                },
                onHorizontalDragCancel: () {
                  _snapToNearestPage();
                },
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

                          // Центр крупнее соседей: 1.12 vs ~0.82 по краям
                          double scale = 1.12 - (pageOffset.abs() * 0.22);
                          scale = scale.clamp(0.82, 1.12);

                          double opacity = 1 - (pageOffset.abs() * 0.6);
                          opacity = opacity.clamp(0.3, 1.0);

                          return Transform.scale(
                            scale: scale,
                            filterQuality: FilterQuality.high,
                            child: Opacity(opacity: opacity, child: child),
                          );
                        },
                        child: _ProjectCard(
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
        ],
      ),
    );
  }
}

// === Карточка проекта: клик раскрывает полный текст ===
class _ProjectCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final int index;
  final Map<String, List<Color>> projectColors;

  const _ProjectCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.index,
    required this.projectColors,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _expandController;
  late final Animation<double> _expandAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 320),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final trimmedDescription = widget.description.trim();

    return Align(
      alignment: Alignment.center,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleExpanded,
          child: AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              final t = _expandAnimation.value;
              // Карточка «выезжает» вперёд — layout и фото не трогаем.
              return Transform.scale(
                scale: lerpDouble(0.9, 1, t)!,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                child: child,
              );
            },
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
              height: 580,
              width: 480,
              padding: EdgeInsets.all(2.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CustomMacElement(
                        width: 70.w,
                        height: 31.h,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30.r),
                          topLeft: Radius.circular(100.r),
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
                        width: 321.w,
                        height: 31.h,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(140.r),
                          bottomLeft: Radius.circular(30.r),
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
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 6.9,
                        left: 10,
                        right: 10,
                      ),
                      height: 215.36.h,
                      width: 481.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        gradient: LinearGradient(
                          colors: widget.projectColors[widget.title] ?? [],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset(
                          AppAssets().projectImages[widget.index],
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 6.9,
                      left: 10,
                      right: 10,
                    ),
                    child: GradientTextTitle(
                      alignment: Alignment.centerLeft,
                      text: widget.title,
                      fontSize: 24.sp,
                      fontFamily: 'Kokh',
                      stops: const [0.1, 0.9, 1.0],
                      colors: widget.projectColors[widget.title],
                      topAlignment: Alignment.centerLeft,
                      bottomAlignment: Alignment.centerRight,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 6.9,
                      left: 10,
                      right: 10,
                    ),
                    child: GradientTextTitle(
                      alignment: Alignment.centerLeft,
                      text: widget.subtitle,
                      fontSize: 24.sp,
                      fontFamily: 'Kokh',
                      stops: const [0.1, 0.8, 1.0],
                      colors: widget.projectColors[widget.title],
                      topAlignment: Alignment.centerRight,
                      bottomAlignment: Alignment.centerLeft,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 6.9,
                        left: 10,
                        right: 10,
                      ),
                      child: AnimatedBuilder(
                        animation: _expandAnimation,
                        builder: (context, _) {
                          final t = _expandAnimation.value;
                          final showFullText = t > 0.5;

                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 220),
                            opacity: lerpDouble(0.85, 1.0, t)!,
                            child: SingleChildScrollView(
                              physics: showFullText
                                  ? const BouncingScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                              child: Text(
                                trimmedDescription,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Kokh',
                                  color: Colors.white.withValues(
                                    alpha: lerpDouble(0.6, 0.88, t)!,
                                  ),
                                  height: 1.5,
                                ),
                                maxLines: showFullText ? null : 6,
                                overflow: showFullText
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 58.h,
                    width: 80.w,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 14.w,
                          bottom: 4.h,
                          child: Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1F1F22),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 1.w,
                              ),
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.github,
                                color: Colors.grey,
                                size: 28.sp,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 18.h,
                          left: 40.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10.0,
                                sigmaY: 10.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  PortfolioLinkScope.of(context)(
                                    PortfolioLinkX.fromProjectTitle(
                                      widget.title,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: const Color(0xFF8C73FF),
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ),
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

// === CustomMacElement ===
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
