import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/responsive/responsive.dart';

/// Decode-size for every photo so preload and first paint share one cache key.
///
/// [Image.asset] `cacheWidth` and [ResizeImage] must use the same physical
/// width, otherwise Flutter decodes the asset twice on the first scroll.
class AssetImageCache {
  AssetImageCache._();

  static const List<String> allImages = [
    'assets/images/acta_logo.png',
    'assets/images/back_pattern.png',
    'assets/images/bg.png',
    'assets/images/collabix_oreview.png',
    'assets/images/contact_me_img.png',
    'assets/images/content_flipper.png',
    'assets/images/curl_text_lib.png',
    'assets/images/echat.png',
    'assets/images/flod_lib.png',
    'assets/images/i.png',
    'assets/images/lib_bg.png',
    'assets/images/me.png',
    'assets/images/mind_map.png',
    'assets/images/project_bg.png',
    'assets/images/row.png',
    'assets/images/slack.png',
    'assets/images/sous_vide.png',
    'assets/images/sous_vide_logo.png',
  ];

  static const _projectThumbs = {
    'assets/images/echat.png',
    'assets/images/mind_map.png',
    'assets/images/slack.png',
    'assets/images/collabix_oreview.png',
    'assets/images/sous_vide.png',
  };

  static const _libraryThumbs = {
    'assets/images/content_flipper.png',
    'assets/images/flod_lib.png',
    'assets/images/curl_text_lib.png',
  };

  static const _liveLogos = {
    'assets/images/acta_logo.png',
    'assets/images/sous_vide_logo.png',
  };

  static const _fullBleed = {
    AppAssets.backgroundPatterImage,
    AppAssets.projectBg,
    'assets/images/lib_bg.png',
    'assets/images/back_pattern.png',
  };

  /// Physical pixel width used for decode + [ImageCache] key.
  static int cacheWidth(BuildContext context, String path) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return (logicalWidth(context, path) * dpr).round().clamp(1, 4096);
  }

  static ImageProvider provider(BuildContext context, String path) {
    return ResizeImage(AssetImage(path), width: cacheWidth(context, path));
  }

  /// On-screen logical width for this asset on the current breakpoint.
  static double logicalWidth(BuildContext context, String path) {
    final screenW = MediaQuery.sizeOf(context).width;

    if (_fullBleed.contains(path)) return screenW;

    if (path == AppAssets.lermImage || path == 'assets/images/i.png') {
      if (context.isMobile) return 240.w;
      if (context.isTablet) return 390.w;
      return 484.w;
    }

    if (path == AppAssets.rowImage) {
      return context.isDesktop ? 132.w : 118.w;
    }

    if (path == AppAssets.contactMeBg) {
      if (context.isMobile) return 782 / 2;
      if (context.isTablet) return 782 / 1.35;
      return 782;
    }

    if (_projectThumbs.contains(path)) {
      if (context.isMobile) return 280.w;
      if (context.isTablet) return 356.w;
      return 481.w;
    }

    if (_libraryThumbs.contains(path)) {
      if (context.isMobile) return 168.r;
      if (context.isTablet) return 210.r;
      return 340.r;
    }

    if (_liveLogos.contains(path)) {
      if (context.isMobile) return 140.w;
      if (context.isTablet) return 260.w;
      return 500.w;
    }

    return screenW;
  }
}
