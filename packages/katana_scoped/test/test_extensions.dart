// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_test/flutter_test.dart";

Text? text(String key) {
  final elements = find.byKey(ValueKey(key)).evaluate();
  if (elements.isEmpty) {
    return null;
  }
  return elements.single.widget as Text;
}

extension TesterExtensions on WidgetTester {
  Future<void> tapWithIcon(IconData icon) {
    return tap(find.byIcon(icon));
  }

  Future<void> tapByKey(String key) {
    return tap(find.byKey(ValueKey(key)));
  }
}
