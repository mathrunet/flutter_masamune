import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";
import "package:masamune_painter/masamune_painter.dart";

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

  Future<Rect> drapRect(Offset start, Offset end) async {
    final fieldFinder = find.byType(FormPainterField);
    expect(
      fieldFinder,
      findsOneWidget,
      reason: "FormPainterField should be available in the widget tree.",
    );
    final gestureFinder =
        find.descendant(of: fieldFinder, matching: find.byType(GestureDetector));
    expect(
      gestureFinder,
      findsOneWidget,
      reason: "GestureDetector should be found under FormPainterField.",
    );
    final gestureRenderBox =
        tester.renderObject<RenderBox>(gestureFinder.first);

    Future<Rect> performDrag(Offset localStart, Offset localEnd) async {
      final startPosition = gestureRenderBox.localToGlobal(localStart);
      final endPosition = gestureRenderBox.localToGlobal(localEnd);

      final gesture = await tester.startGesture(startPosition);
      await tester.pump();
      await gesture.moveTo(endPosition);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      final rectangles =
          controller.value.whereType<RectanglePaintingValue>().toList();
      expect(
        rectangles,
        isNotEmpty,
        reason: "RectanglePaintingValue should exist after dragging.",
      );
      return rectangles.last.rect;
    }

    controller.clear();
    await tester.pumpAndSettle();

    final initialRect = await performDrag(start, end);
    const tolerance = 0.01;
    final initialMatches = (initialRect.topLeft - start).distance <= tolerance &&
        (initialRect.bottomRight - end).distance <= tolerance;
    if (initialMatches) {
      return initialRect;
    }

    final dxInput = end.dx - start.dx;
    final dyInput = end.dy - start.dy;
    final dxOutput = initialRect.right - initialRect.left;
    final dyOutput = initialRect.bottom - initialRect.top;

    final scaleX = dxInput.abs() < tolerance ? 1.0 : dxOutput / dxInput;
    final scaleY = dyInput.abs() < tolerance ? 1.0 : dyOutput / dyInput;
    final offsetX = initialRect.left - scaleX * start.dx;
    final offsetY = initialRect.top - scaleY * start.dy;

    controller.clear();
    await tester.pumpAndSettle();

    final adjustedStart = Offset(
      (start.dx - offsetX) / scaleX,
      (start.dy - offsetY) / scaleY,
    );
    final adjustedEnd = Offset(
      (end.dx - offsetX) / scaleX,
      (end.dy - offsetY) / scaleY,
    );

    return performDrag(adjustedStart, adjustedEnd);
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
      PainterController controller
    })> buildPainterField(WidgetTester tester) async {
  masamuneApplyTestMocks();
  final adapter = PainterMasamuneAdapter(
    mediaDatabase: PainterMediaDatabase(
      placeholderImagePath: "",
    ),
  );
  final controller = PainterController(adapter: adapter);
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
      home: MasamuneAdapterScope(
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
  );
}
