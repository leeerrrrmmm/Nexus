import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/const/app_assets/asset_image_cache.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/core/links/portfolio_link_scope.dart';
import 'package:portfolio/core/responsive/responsive.dart';
import 'package:portfolio/features/contact/data/remote/contact_me_remote_datasource.dart';
import 'package:portfolio/features/contact/data/repo_impl/contact_me_repo_impl.dart';
import 'package:portfolio/features/contact/domain/useCase/contact_me_usecase.dart';
import 'package:portfolio/features/state/cubit/contact_me_cubit.dart';
import 'package:portfolio/presentation/landing/lazy_mount.dart';
import 'package:portfolio/presentation/mobile/drawer/mobile_drawer.dart';
import 'package:portfolio/presentation/mobile/mobile_app_bar.dart';
import 'package:portfolio/presentation/mobile/mobile_contact_me_section.dart';
import 'package:portfolio/presentation/mobile/mobile_first_section.dart';
import 'package:portfolio/presentation/mobile/mobile_library_section.dart';
import 'package:portfolio/presentation/mobile/mobile_live_project_section.dart';
import 'package:portfolio/presentation/mobile/mobile_second_section.dart';
import 'package:portfolio/presentation/mobile/mobile_third_section.dart';
import 'package:portfolio/presentation/tablet/tablet_contact_me_section.dart';
import 'package:portfolio/presentation/tablet/tablet_custom_app_bar.dart';
import 'package:portfolio/presentation/tablet/tablet_first_section.dart';
import 'package:portfolio/presentation/tablet/tablet_library_section.dart';
import 'package:portfolio/presentation/tablet/tablet_life_project_section.dart';
import 'package:portfolio/presentation/tablet/tablet_second_section.dart';
import 'package:portfolio/presentation/tablet/tablet_third_section.dart';
import 'package:portfolio/presentation/web/animated_text_section.dart';
import 'package:portfolio/presentation/web/contact_me_section.dart';
import 'package:portfolio/presentation/web/custom_app_bar.dart';
import 'package:portfolio/presentation/web/first_section.dart';
import 'package:portfolio/presentation/web/library_section.dart';
import 'package:portfolio/presentation/web/live_project_section.dart';
import 'package:portfolio/presentation/web/second_section.dart';
import 'package:portfolio/presentation/web/third_section.dart';
import 'package:portfolio/presentation/widgets/private_project_warning.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Контроллер для отслеживания скролла
  late ScrollController _scrollController;

  // Текущий активный индекс для подсветки в AppBar
  int _currentPageIndex = 0;

  // Флаг, чтобы скролл-трекер не дергался во время программной анимации
  bool _isProgrammaticScroll = false;

  // Расширенный список GlobalKey для ВСЕХ навигационных секций
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectKey = GlobalKey();
  final GlobalKey _liveProjectsKey = GlobalKey();
  final GlobalKey _libraryKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  /// Slots below the hero. Header is always built; these start as height stubs.
  static const _aboutSlot = 0;
  static const _projectsSlot = 1;
  static const _ticker1Slot = 2;
  static const _liveSlot = 3;
  static const _ticker2Slot = 4;
  static const _librarySlot = 5;
  static const _contactSlot = 6;
  static const _slotCount = 7;

  final Set<int> _readySlots = <int>{};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _mountNext());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Автоматически определяет, какую секцию сейчас видит пользователь
  void _onScroll() {
    if (_isProgrammaticScroll) return;

    final List<GlobalKey> keys = [
      _headerKey,
      _aboutKey,
      _projectKey,
      _liveProjectsKey,
      _libraryKey,
      _contactKey,
    ];

    int newIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < keys.length; i++) {
      final context = keys[i].currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final double position = box.localToGlobal(Offset.zero).dy;

          if (position <= 120 && position.abs() < minDistance) {
            newIndex = i;
          }
        }
      }
    }

    if (newIndex != _currentPageIndex) {
      setState(() {
        _currentPageIndex = newIndex;
      });
    }
  }

  // Метод плавного скролла к нужному контексту ключа
  void _scrollToSection(GlobalKey key, int index) {
    final context = key.currentContext;
    if (context != null) {
      setState(() {
        _currentPageIndex = index;
        _isProgrammaticScroll = true;
      });

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      ).then((_) {
        _isProgrammaticScroll = false;
      });
    }
  }

  bool _isReady(int slot) => _readySlots.contains(slot);

  void _revealSlot(int slot) {
    if (!mounted || _readySlots.contains(slot)) return;
    setState(() => _readySlots.add(slot));
  }

  void _mountNext() {
    if (!mounted) return;
    for (var slot = 0; slot < _slotCount; slot++) {
      if (!_readySlots.contains(slot)) {
        _revealSlot(slot);
        WidgetsBinding.instance.addPostFrameCallback((_) => _mountNext());
        return;
      }
    }
  }

  static int _slotForNavIndex(int index) => switch (index) {
    1 => _aboutSlot,
    2 => _projectsSlot,
    3 => _liveSlot,
    4 => _librarySlot,
    5 => _contactSlot,
    _ => -1,
  };

  double _placeholderHeight(int slot, DeviceType deviceType, bool isMobile) {
    return switch (slot) {
      _aboutSlot => switch (deviceType) {
        DeviceType.mobile => 917.h,
        DeviceType.tablet => 1536.h,
        DeviceType.desktop => 1251.h,
      },
      _projectsSlot => switch (deviceType) {
        DeviceType.mobile => 0.88.sh,
        DeviceType.tablet => 0.95.sh,
        DeviceType.desktop => 1.1.sh,
      },
      _ticker1Slot || _ticker2Slot => isMobile ? 40.h : 92.h,
      _liveSlot => switch (deviceType) {
        DeviceType.mobile => 0.7.sh,
        DeviceType.tablet => 0.85.sh,
        DeviceType.desktop => 1.sh,
      },
      _librarySlot => switch (deviceType) {
        DeviceType.mobile => 0.8.sh,
        DeviceType.tablet => 0.9.sh,
        DeviceType.desktop => 1.sh,
      },
      _contactSlot => switch (deviceType) {
        DeviceType.mobile => 0.75.sh,
        DeviceType.tablet => 0.82.sh,
        DeviceType.desktop => 1.sh,
      },
      _ => 0,
    };
  }

  // Маппинг клика из AppBar/Drawer
  void _onNavTap(int index) {
    final slot = _slotForNavIndex(index);
    final needsReveal = slot >= 0 && !_isReady(slot);
    if (slot >= 0) _revealSlot(slot);

    void scroll() {
      switch (index) {
        case 0:
          _scrollToSection(_headerKey, index);
        case 1:
          _scrollToSection(_aboutKey, index);
        case 2:
          _scrollToSection(_projectKey, index);
        case 3:
          _scrollToSection(_liveProjectsKey, index);
        case 4:
          _scrollToSection(_libraryKey, index);
        case 5:
          _scrollToSection(_contactKey, index);
      }
    }

    if (needsReveal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) scroll();
      });
      return;
    }
    scroll();
  }

  /// Single place for all external / private destinations.
  /// Sections only call [PortfolioLinkScope.of] with a [PortfolioLink].
  Future<void> _openPortfolioLink(PortfolioLink link) async {
    if (link.isPrivateOrInProgress) {
      if (!mounted) return;
      await PrivateProjectWarning.show(context);
      return;
    }

    final rawUrl = link.url;
    if (rawUrl == null) return;

    final uri = Uri.parse(rawUrl);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open link: $rawUrl')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = context.deviceType;
    final isMobile = deviceType == DeviceType.mobile;
    final isTablet = deviceType == DeviceType.tablet;
    final screenWidth = context.screenWidth;

    return PortfolioLinkScope(
      open: _openPortfolioLink,
      child: Scaffold(
        backgroundColor: Colors.black,
        drawer: isMobile
            ? MobileDrawer(
                currentIndex: _currentPageIndex,
                onNavItemTap: _onNavTap,
              )
            : null,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(isMobile ? 50 : (isTablet ? 60 : 70)),
          child: isMobile
              ? MobileAppBar(
                  currentIndex: _currentPageIndex,
                  onNavItemTap: _onNavTap,
                )
              : isTablet
              ? TabletCustomAppBar(
                  currentIndex: _currentPageIndex,
                  onNavItemTap: _onNavTap,
                )
              : CustomAppBar(
                  currentIndex: _currentPageIndex,
                  onNavItemTap: _onNavTap,
                ),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Stack(
                    key: _headerKey,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        width: screenWidth,
                        child: IgnorePointer(
                          child: Builder(
                            builder: (context) {
                              final image = Image.asset(
                                AppAssets.backgroundPatterImage,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                cacheWidth: AssetImageCache.cacheWidth(
                                  context,
                                  AppAssets.backgroundPatterImage,
                                ),
                                color: Colors.black.withValues(alpha: 0.6),
                                colorBlendMode: BlendMode.darken,
                                filterQuality: FilterQuality.low,
                              );
                              if (kIsWeb) return image;
                              return ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 4.0,
                                  sigmaY: 4.0,
                                ),
                                child: image,
                              );
                            },
                          ),
                        ),
                      ),
                      switch (deviceType) {
                        DeviceType.mobile => const MobileFirstSection(),
                        DeviceType.tablet => const TabletFirstSection(),
                        DeviceType.desktop => const FirstSectionContent(),
                      },
                    ],
                  ),

                  LazyMount(
                    key: _aboutKey,
                    isReady: _isReady(_aboutSlot),
                    placeholderHeight: _placeholderHeight(
                      _aboutSlot,
                      deviceType,
                      isMobile,
                    ),
                    builder: (_) => switch (deviceType) {
                      DeviceType.mobile => const MobileSecondSection(),
                      DeviceType.tablet => const TabletSecondSection(),
                      DeviceType.desktop => const SecondSection(),
                    },
                  ),

                  LazyMount(
                    key: _projectKey,
                    isReady: _isReady(_projectsSlot),
                    placeholderHeight: _placeholderHeight(
                      _projectsSlot,
                      deviceType,
                      isMobile,
                    ),
                    builder: (_) => switch (deviceType) {
                      DeviceType.mobile => const MobileThirdSection(),
                      DeviceType.tablet => const TabletThirdSection(),
                      DeviceType.desktop => const ThirdSection(),
                    },
                  ),

                  LazyMount(
                    isReady: _isReady(_ticker1Slot),
                    placeholderHeight: _placeholderHeight(
                      _ticker1Slot,
                      deviceType,
                      isMobile,
                    ),
                    builder: (_) => AnimatedTextSection(isMobile: isMobile),
                  ),

                  LazyMount(
                    key: _liveProjectsKey,
                    isReady: _isReady(_liveSlot),
                    placeholderHeight: _placeholderHeight(
                      _liveSlot,
                      deviceType,
                      isMobile,
                    ),
                    builder: (_) => switch (deviceType) {
                      DeviceType.mobile => const MobileLiveProjectsSection(),
                      DeviceType.tablet => const TabletLiveProjectSection(),
                      DeviceType.desktop => const LiveProjectsSection(),
                    },
                  ),

                  LazyMount(
                    isReady: _isReady(_ticker2Slot),
                    placeholderHeight: _placeholderHeight(
                      _ticker2Slot,
                      deviceType,
                      isMobile,
                    ),
                    builder: (_) => AnimatedTextSection(isMobile: isMobile),
                  ),

                  LazyMount(
                    key: _libraryKey,
                    isReady: _isReady(_librarySlot),
                    placeholderHeight: _placeholderHeight(
                      _librarySlot,
                      deviceType,
                      isMobile,
                    ),
                    builder: (_) => switch (deviceType) {
                      DeviceType.mobile => const MobileLibrarySection(),
                      DeviceType.tablet => const TabletLibrarySection(),
                      DeviceType.desktop => const LibrarySection(),
                    },
                  ),

                  LazyMount(
                    key: _contactKey,
                    isReady: _isReady(_contactSlot),
                    placeholderHeight: _placeholderHeight(
                      _contactSlot,
                      deviceType,
                      isMobile,
                    ),
                    builder: (_) => BlocProvider(
                      create: (_) => ContactMeCubit(
                        contactMeUseCase: ContactMeUseCase(
                          contactMeRepo: ContactMeRepoImpl(
                            remoteDataSource: ContactMeRemoteDataSourceImpl(
                              dio: Dio(),
                            ),
                          ),
                        ),
                      ),
                      child: switch (deviceType) {
                        DeviceType.mobile => const MobileContactMeSection(),
                        DeviceType.tablet => const TabletContactMeSection(),
                        DeviceType.desktop => const ContactMeSection(),
                      },
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
