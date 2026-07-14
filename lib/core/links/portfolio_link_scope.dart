import 'package:flutter/widgets.dart';
import 'package:portfolio/core/links/portfolio_link.dart';

typedef PortfolioLinkHandler = void Function(PortfolioLink link);

/// Provides [open] from [LandingPage] so web / tablet / mobile sections only
/// pass a [PortfolioLink] — all URL / warning logic stays centralized.
class PortfolioLinkScope extends InheritedWidget {
  const PortfolioLinkScope({
    super.key,
    required this.open,
    required super.child,
  });

  final PortfolioLinkHandler open;

  static PortfolioLinkHandler of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<PortfolioLinkScope>();
    assert(scope != null, 'PortfolioLinkScope not found above this widget.');
    return scope!.open;
  }

  static PortfolioLinkHandler? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PortfolioLinkScope>()
        ?.open;
  }

  @override
  bool updateShouldNotify(PortfolioLinkScope oldWidget) =>
      open != oldWidget.open;
}
