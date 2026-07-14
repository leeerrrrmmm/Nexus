import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DeviceType { mobile, tablet, desktop }

/// Central breakpoints + design canvases for ScreenUtil.
///
/// Absolute [Positioned] layouts stay stable when `.w` and `.h` share one
/// scale factor. That is achieved by syncing [designSize] height to the
/// viewport aspect ratio (see [designSizeFor]).
class DeviceBreakpoints {
  DeviceBreakpoints._();

  static const double mobileMax = 768;
  static const double tabletMax = 1024;

  /// Reference design drafts (width is the scale anchor).
  static const Size mobileDesign = Size(412, 917);
  static const Size tabletDesign = Size(768, 1024);
  static const Size desktopDesign = Size(1283, 834);

  static DeviceType of(double width) {
    if (width < mobileMax) return DeviceType.mobile;
    if (width < tabletMax) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static Size baseDesign(DeviceType type) => switch (type) {
        DeviceType.mobile => mobileDesign,
        DeviceType.tablet => tabletDesign,
        DeviceType.desktop => desktopDesign,
      };

  /// Design size where [ScreenUtil.scaleWidth] == [ScreenUtil.scaleHeight].
  ///
  /// Prevents shear/drift in Stack + Positioned compositions when the
  /// viewport aspect ratio differs from the draft.
  static Size designSizeFor(DeviceType type, Size screen) {
    final base = baseDesign(type);
    if (screen.width <= 0 || screen.height <= 0) return base;
    return Size(base.width, base.width * screen.height / screen.width);
  }
}

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  DeviceType get deviceType => DeviceBreakpoints.of(screenWidth);

  bool get isMobile => deviceType == DeviceType.mobile;

  bool get isTablet => deviceType == DeviceType.tablet;

  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Full viewport height in logical pixels (safe for section min-heights).
  double get viewHeight => screenHeight;

  /// Maps a draft-Y fraction (0–1 on the base design height) to scaled px.
  double designY(double fraction) {
    final baseH = DeviceBreakpoints.baseDesign(deviceType).height;
    return (baseH * fraction).h;
  }

  /// Maps a draft-X fraction (0–1 on the base design width) to scaled px.
  double designX(double fraction) {
    final baseW = DeviceBreakpoints.baseDesign(deviceType).width;
    return (baseW * fraction).w;
  }
}
