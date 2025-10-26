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
    final rect = await helper.drapRect(
      const Offset(100, 100),
      const Offset(150, 150),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    expect(rect.topLeft, const Offset(100, 100));
    expect(rect.bottomRight, const Offset(150, 150));
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(100, 100),
          property: expectedProperty,
          end: const Offset(150, 150),
        )
      ].toDebug(),
    );
  });
}
