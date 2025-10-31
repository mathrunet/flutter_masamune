// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_painter/masamune_painter.dart";

const _kDragPerformCount = 10;

/// Helper for testing TextInput.
///
/// TextInputのテストを行うためのヘルパー。
class TestTextInputHelper {
  /// Helper for testing TextInput.
  ///
  /// TextInputのテストを行うためのヘルパー。
  TestTextInputHelper(this.tester, this.controller);

  final WidgetTester tester;
  final PainterController controller;

  /// Drag the canvas.
  ///
  /// キャンバスをドラッグします。
  Future<void> drag(Offset start, Offset end) async {
    controller.debugTapDown(start);
    await tester.pump();
    final delta = (end - start) / _kDragPerformCount.toDouble();
    for (var i = 0; i <= _kDragPerformCount; i++) {
      controller.debugDragging(start + Offset(i * delta.dx, i * delta.dy));
      await tester.pump();
    }
    controller.debugTapUp(end);
    await tester.pump();
  }

  /// Tap the canvas.
  ///
  /// キャンバスをタップします。
  Future<void> tap(Offset position) async {
    controller.debugTapDown(position);
    await tester.pump();
    controller.debugTapUp(position);
    await tester.pump();
  }
}

/// Will create a widget for testing Painter.
///
/// Painterのテストを行うためのウィジェットを作成します。
Future<
    ({
      Finder finder,
      FormPainterFieldState field,
      FormPainterToolbarState toolbar,
      PainterController controller,
      TestTextInputHelper input,
    })> buildPainterField(WidgetTester tester) async {
  masamuneApplyTestMocks();
  final adapter = PainterMasamuneAdapter(
    mediaDatabase: PainterMediaDatabase(
      placeholderImagePath: "",
    ),
  );
  final controller = PainterController(
    adapter: adapter,
    canvasSize: const Size(1920, 1920),
  );
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        textTheme: ThemeData.light().textTheme.copyWith(
              labelSmall: ThemeData.light()
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontSize: 10),
            ),
      ),
      home: Scaffold(
        body: MasamuneAdapterScope(
          adapter: adapter,
          child: SizedBox(
            width: 1920,
            height: 1920,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: FormPainterField(
                    minScale: 1.0,
                    maxScale: 1.0,
                    controller: controller,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: FormPainterToolbar(
                    controller: controller,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  final finder = find.byType(FormPainterField);
  final toolbar = find.byType(FormPainterToolbar);
  await tester.tap(finder);
  await tester.pump();

  return (
    finder: finder,
    controller: controller,
    field: tester.state<FormPainterFieldState>(finder),
    toolbar: tester.state<FormPainterToolbarState>(toolbar),
    input: TestTextInputHelper(tester, controller),
  );
}
