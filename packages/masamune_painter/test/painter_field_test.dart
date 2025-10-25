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
    expect(context.controller.value.length, 1);
    final rectangle =
        context.controller.value.single as RectanglePaintingValue;
    final size = rectangle.rect.size;
    expect(rectangle.category, PaintingValueCategory.shape);
    expect(size.width, greaterThanOrEqualTo(rectangle.minimumSize.width));
    expect(size.height, greaterThanOrEqualTo(rectangle.minimumSize.height));
    expect(rectangle.start, isNot(rectangle.end));
    expect(rectangle.property, context.controller.property.currentToolProperty);
  });
}
