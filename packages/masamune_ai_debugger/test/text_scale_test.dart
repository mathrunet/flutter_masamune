import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:masamune_ai_debugger/masamune_ai_debugger.dart";

void main() {
  // The overlay panel has a fixed size, so host accessibility text sizes
  // must not overflow its contents.
  for (final scale in [1.0, 2.0, 3.1]) {
    testWidgets("debug camera panel does not overflow at text scale $scale",
        (tester) async {
      tester.view.physicalSize = const Size(1206, 2622);
      tester.view.devicePixelRatio = 3;
      tester.platformDispatcher.textScaleFactorTestValue = scale;
      addTearDown(() {
        tester.platformDispatcher.clearTextScaleFactorTestValue();
        tester.view.reset();
      });
      const first = AIDebugCameraPicture(id: "first", label: "First picture");
      const second =
          AIDebugCameraPicture(id: "second", label: "Second picture");
      String? active = second.id;
      final adapter = AIDebuggerMasamuneAdapter(
        projectId: "Users-example-debug-camera-text-scale",
        cameraPictures: () => const [first, second],
        setCameraPicture: (picture) => active = picture.id,
        unsetCameraPicture: () => active = null,
        isCameraPictureSet: (picture) => active == picture.id,
      );
      await tester.pumpWidget(
        Builder(
          builder: (context) => adapter.onBuildApp(
            context,
            const MaterialApp(home: ColoredBox(color: Colors.blue)),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byIcon(Icons.auto_awesome));
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.tap(find.bySemanticsLabel("AIデバッガーカメラ管理"));
      await tester.pump();

      expect(find.text("デバッグカメラ"), findsOneWidget);
      expect(tester.takeException(), isNull);
      await adapter.controller.end();
    });
  }
}
