import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/core/links/portfolio_link_scope.dart';
import 'package:portfolio/core/responsive/responsive.dart';
import 'package:portfolio/features/contact/data/remote/contact_me_remote_datasource.dart';
import 'package:portfolio/features/contact/data/repo_impl/contact_me_repo_impl.dart';
import 'package:portfolio/features/contact/domain/useCase/contact_me_usecase.dart';
import 'package:portfolio/features/state/cubit/contact_me_cubit.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
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

  // Маппинг клика из AppBar/Drawer
  void _onNavTap(int index) {
    switch (index) {
      case 0:
        _scrollToSection(_headerKey, index);
        break;
      case 1:
        _scrollToSection(_aboutKey, index);
        break;
      case 2:
        _scrollToSection(_projectKey, index);
        break;
      case 3:
        _scrollToSection(_liveProjectsKey, index);
        break;
      case 4:
        _scrollToSection(_libraryKey, index);
        break;
      case 5:
        _scrollToSection(_contactKey, index);
        break;
    }
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
                              final dpr = MediaQuery.devicePixelRatioOf(
                                context,
                              );
                              final image = Image.asset(
                                AppAssets.backgroundPatterImage,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                cacheWidth: (screenWidth * dpr).round(),
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

                  switch (deviceType) {
                    DeviceType.mobile => MobileSecondSection(key: _aboutKey),
                    DeviceType.tablet => TabletSecondSection(key: _aboutKey),
                    DeviceType.desktop => SecondSection(key: _aboutKey),
                  },

                  switch (deviceType) {
                    DeviceType.mobile => MobileThirdSection(key: _projectKey),
                    DeviceType.tablet => TabletThirdSection(key: _projectKey),
                    DeviceType.desktop => ThirdSection(key: _projectKey),
                  },

                  AnimatedTextSection(isMobile: isMobile),

                  switch (deviceType) {
                    DeviceType.mobile => MobileLiveProjectsSection(
                      key: _liveProjectsKey,
                    ),
                    DeviceType.tablet => TabletLiveProjectSection(
                      key: _liveProjectsKey,
                    ),
                    DeviceType.desktop => LiveProjectsSection(
                      key: _liveProjectsKey,
                    ),
                  },

                  AnimatedTextSection(isMobile: isMobile),

                  switch (deviceType) {
                    DeviceType.mobile => MobileLibrarySection(key: _libraryKey),
                    DeviceType.tablet => TabletLibrarySection(key: _libraryKey),
                    DeviceType.desktop => LibrarySection(key: _libraryKey),
                  },

                  BlocProvider(
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
                      DeviceType.mobile => MobileContactMeSection(
                        key: _contactKey,
                      ),
                      DeviceType.tablet => TabletContactMeSection(
                        key: _contactKey,
                      ),
                      DeviceType.desktop => ContactMeSection(key: _contactKey),
                    },
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
