import "package:katana/katana.dart";
import "package:masamune_painter/masamune_painter.dart";
import "package:flutter_test/flutter_test.dart";

import "functions.dart";

void main() {
  testWidgets("PainterField.field.rectangle", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = TestTextInputHelper(tester, context.controller);
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    expect(context.controller.currentTool,
        const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(250, 250),
        )
      ].toDebug(),
    );
  });
}
