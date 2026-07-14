import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/core/responsive/responsive.dart';
import 'package:portfolio/presentation/loading/loading_page.dart';

export 'package:portfolio/core/responsive/responsive.dart'
    show DeviceType, DeviceBreakpoints;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height =
            constraints.maxHeight.isFinite && constraints.maxHeight > 0
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;

        final deviceType = DeviceBreakpoints.of(width);
        final designSize = DeviceBreakpoints.designSizeFor(
          deviceType,
          Size(width, height),
        );

        return ScreenUtilInit(
          // Remount only when the adaptive layout family changes.
          key: ValueKey(deviceType),
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: false,
          ensureScreenSize: true,
          rebuildFactor: RebuildFactors.size,
          fontSizeResolver: FontSizeResolvers.width,
          builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Nexus • Flutter Developer',
            builder: (context, appChild) {
              // Lock system text scaling so layout math stays predictable.
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  textScaler: media.textScaler.clamp(
                    minScaleFactor: 0.85,
                    maxScaleFactor: 1.15,
                  ),
                ),
                child: appChild ?? const SizedBox.shrink(),
              );
            },
            home: child,
          ),
          child: const LoadingScreen(),
        );
      },
    );
  }
}
