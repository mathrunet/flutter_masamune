import "package:katana/katana.dart";
import "package:masamune_painter/masamune_painter.dart";
import "package:flutter_test/flutter_test.dart";

import "functions.dart";

void main() {
  testWidgets("PainterField.field.rectangle", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;

    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    expect(context.controller.currentTool,
        const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await tester.drag(context.finder, const Offset(100, 100));
    await tester.pumpAndSettle();
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(100, 100),
          property: const PaintingProperty(),
          end: const Offset(150, 150),
        )
      ].toDebug(),
    );
  });
}
