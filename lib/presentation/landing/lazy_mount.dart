import 'package:flutter/widgets.dart';

/// Holds [placeholderHeight] until [isReady], then builds the real child.
///
/// [builder] runs only after reveal, so the section constructor, [State.initState],
/// images, and animation controllers stay off the first landing frame.
class LazyMount extends StatelessWidget {
  const LazyMount({
    super.key,
    required this.isReady,
    required this.placeholderHeight,
    required this.builder,
  });

  final bool isReady;
  final double placeholderHeight;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return SizedBox(width: double.infinity, height: placeholderHeight);
    }
    return builder(context);
  }
}
