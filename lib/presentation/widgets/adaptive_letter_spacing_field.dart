import 'package:flutter/material.dart';

/// Uses Kosugi for English (Latin) input; system default for other scripts.
class AdaptiveInputTypography extends ChangeNotifier {
  AdaptiveInputTypography({required this.textController}) {
    textController.addListener(_onTextChanged);
    _update();
  }

  final TextEditingController textController;

  static final RegExp _nonAscii = RegExp(r'[^\x00-\x7F]');

  String? _fontFamily = 'Kosugi';
  String? get fontFamily => _fontFamily;

  void _onTextChanged() {
    final next = _resolve(textController.text);
    if (next == _fontFamily) return;
    _fontFamily = next;
    notifyListeners();
  }

  void _update() {
    _fontFamily = _resolve(textController.text);
  }

  String? _resolve(String text) {
    if (text.isEmpty) return 'Kosugi';
    if (_nonAscii.hasMatch(text)) return null;
    return 'Kosugi';
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    super.dispose();
  }
}
