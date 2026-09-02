// Dart imports:
import "dart:convert";
import "dart:typed_data";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_test/flutter_test.dart";

// Project imports:
import "package:katana_ui/katana_ui.dart";

void main() {
  testWidgets("SquareAvatar passes its fixed size to the inner image", (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SquareAvatar(
          width: 64,
          height: 48,
          backgroundImage: MemoryImage(_transparentImage),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));

    expect(image.width, 64);
    expect(image.height, 48);
  });

  testWidgets("SquareAvatar keeps the inner image unconstrained without size", (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SquareAvatar(
          backgroundImage: MemoryImage(_transparentImage),
        ),
      ),
    );

    final image = tester.widget<Image>(find.byType(Image));

    expect(image.width, isNull);
    expect(image.height, isNull);
  });
}

final Uint8List _transparentImage = base64Decode(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=",
);
