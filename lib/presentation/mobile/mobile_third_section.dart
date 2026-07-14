import 'dart:async';
import 'dart:ui' show lerpDouble, ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/core/links/portfolio_link_scope.dart';
import 'package:portfolio/presentation/components/gradient_text_title.dart';
import 'package:portfolio/presentation/widgets/glass_container_widget.dart';

class MobileThirdSection extends StatefulWidget {
  const MobileThirdSection({super.key});

  @override
  State<MobileThirdSection> createState() => _MobileThirdSectionState();
}

class _MobileThirdSectionState extends State<MobileThirdSection> {
  late final PageController _projectPageController;
  late final ValueNotifier<double> _pageNotifier;
  Timer? _autoPlayTimer;

  static const int _realItemCount = 5;
  static const int _initialPage = 10000;

  final List<String> _projectTitles = const [
    'Collabix',
    'Sous vide',
    'Slack',
    'E-CHAT',
    'Mind Map',
  ];

  final List<String> _projectSubtitles = const [
    'Workspaces',
    'Reference',
    'Team communication',
    'Communication app',
    'Task manager',
  ];

  static const List<String> _dummyDescriptions = [
    '''An all-in-one collaboration platform that seamlessly bridges the gap between corporate messaging and the visual power of interactive boards. Forget toggling between multiple tabs: here, you can chat with your team to brainstorm ideas and instantly map them out on an infinite Miro-style canvas.''',
    '''A smart culinary assistant tailored for chefs and precision cooking enthusiasts aiming for consistent, restaurant-quality results at home. The heart of the app is an intuitive time and temperature calculator for sous vide cooking.''',
    '''A full-featured corporate messenger designed to streamline team communication and eliminate the chaos of cluttered workspaces.''',
    '''An innovative e-commerce messenger designed to transform standard online shopping into a dynamic, personalized conversation between brands and customers.''',
    '''A next-generation task manager that redefines how you organize daily workflows and map out complex projects with interactive mind maps.''',
  ];

  static final Map<String, List<Color>> _projectColors = {
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
    'Slack': [
      Color(0xFFFFFFFF),
      Color.fromARGB(255, 66, 65, 65),
      Color.fromARGB(175, 104, 101, 101),
    ],
    'E-CHAT': [Color(0xFFFFFFFF), Color(0xFF8095C3), Color(0xFF8095C3)],
    'Mind Map': [
      Color(0xFFFFFFFF),
      Color.fromARGB(201, 226, 108, 108),
      Color(0xFFE45756),
    ],
  };

  @override
  void initState() {
    super.initState();

    _pageNotifier = ValueNotifier<double>(_initialPage.toDouble());

    _projectPageController = PageController(initialPage: _initialPage);

    _projectPageController.addListener(() {
      if (_projectPageController.page != null) {
        _pageNotifier.value = _projectPageController.page!;
      }
    });

    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 16), (timer) {
      if (!_projectPageController.hasClients) return;
      final current = _projectPageController.page?.round() ?? _initialPage;
      _projectPageController.animateToPage(
        current + 1,
        duration: const Duration(seconds: 6),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _projectPageController.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 0.95.sh,
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
          const GradientTextTitle(text: AppText.projectTitle, fontSize: 73),
          const SizedBox(height: 30),
          SizedBox(
            height: 580.h,
            width: double.infinity,
            child: PageView.builder(
              controller: _projectPageController,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final int realIndex = index % _realItemCount;
                return Center(
                  child: _ProjectCard(
                    title: _projectTitles[realIndex],
                    subtitle: _projectSubtitles[realIndex],
                    description: _dummyDescriptions[realIndex],
                    projectColors: _projectColors,
                    index: realIndex,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== PROJECT CARD ====================
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
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 320),
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

    return GestureDetector(
      onTap: _toggleExpanded,
      child: AnimatedBuilder(
        animation: _expandController,
        builder: (context, child) {
          final t = _expandController.value;
          return Transform.scale(
            scale: lerpDouble(0.95, 1.0, t)!,
            child: child,
          );
        },
        child: GlassContainerWidget(
          height: 600,
          width: 321,
          padding: EdgeInsets.all(2.r),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mac-style top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CustomMacElement(
                    width: 46.w,
                    height: 19.h,
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
                      children: List.generate(
                        3,
                        (_) => CircleAvatar(
                          radius: 3.5.r,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                  _CustomMacElement(
                    width: 210.w,
                    height: 20.h,
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

              // Project Image
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 7, left: 10, right: 10),
                  height: 215.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: LinearGradient(
                      colors: widget.projectColors[widget.title] ?? [],
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
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GradientTextTitle(
                  alignment: Alignment.centerLeft,
                  text: widget.title,
                  fontSize: 24.sp,
                  fontFamily: 'Kokh',
                  stops: const [0.1, 0.9, 1.0],
                  colors: widget.projectColors[widget.title],
                ),
              ),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GradientTextTitle(
                  alignment: Alignment.centerLeft,
                  text: widget.subtitle,
                  fontSize: 24.sp,
                  fontFamily: 'Kokh',
                  stops: const [0.1, 0.8, 1.0],
                  colors: widget.projectColors[widget.title],
                ),
              ),

              SizedBox(height: 16.h),

              // Description
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AnimatedBuilder(
                    animation: _expandController,
                    builder: (context, _) {
                      final t = _expandController.value;
                      final showFull = t > 0.5;

                      return SingleChildScrollView(
                        physics: showFull
                            ? const BouncingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: lerpDouble(0.75, 1.0, t)!,
                          child: Text(
                            trimmedDescription,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontFamily: 'Kokh',
                              color: Colors.white.withValues(
                                alpha: lerpDouble(0.65, 0.9, t)!,
                              ),
                              height: 1.5,
                            ),
                            maxLines: showFull ? null : 5,
                            overflow: showFull
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Bottom buttons
              SizedBox(
                height: 58.h,
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
                      left: 35.w,
                      child: GestureDetector(
                        onTap: () {
                          PortfolioLinkScope.of(context)(
                            PortfolioLinkX.fromProjectTitle(widget.title),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1.w,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: const Color(0xFF8C73FF),
                                size: 20.sp,
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
    );
  }
}

class _CustomMacElement extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final BoxBorder boxBorder;
  final Widget? child;

  const _CustomMacElement({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.boxBorder,
    this.child,
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
