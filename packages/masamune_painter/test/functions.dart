import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";
import "package:masamune_painter/masamune_painter.dart";

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
