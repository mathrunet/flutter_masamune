// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_test/flutter_test.dart";
import "package:katana/katana.dart";

// Project imports:
import "package:masamune_painter/masamune_painter.dart";
import "functions.dart";

void main() {
  testWidgets("PainterField.field.rectangle", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
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

  testWidgets("PainterField.field.rectangle.resize.topLeft", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Resize from top-left corner
    await helper.drag(
      const Offset(150, 150),
      const Offset(100, 100),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(100, 100),
          property: expectedProperty,
          end: const Offset(250, 250),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.resize.topRight", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Resize from top-right corner
    await helper.drag(
      const Offset(250, 150),
      const Offset(300, 100),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(150, 250),
          property: expectedProperty,
          end: const Offset(300, 100),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.resize.bottomRight",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Resize from bottom-right corner
    await helper.drag(
      const Offset(250, 250),
      const Offset(300, 300),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(300, 300),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.resize.bottomLeft", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Resize from bottom-left corner
    await helper.drag(
      const Offset(150, 250),
      const Offset(100, 300),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(100, 150),
          property: expectedProperty,
          end: const Offset(250, 300),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.resize.top", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Resize from top edge
    await helper.drag(
      const Offset(200, 150),
      const Offset(200, 100),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(150, 100),
          property: expectedProperty,
          end: const Offset(250, 250),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.resize.right", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Resize from right edge
    await helper.drag(
      const Offset(250, 200),
      const Offset(300, 200),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(300, 250),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.resize.bottom", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Resize from bottom edge
    await helper.drag(
      const Offset(200, 250),
      const Offset(200, 300),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(250, 300),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.resize.left", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Resize from left edge
    await helper.drag(
      const Offset(150, 200),
      const Offset(100, 200),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(100, 150),
          property: expectedProperty,
          end: const Offset(250, 250),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.move.up", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Move from center upward
    await helper.drag(
      const Offset(200, 200),
      const Offset(200, 150),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(150, 100),
          property: expectedProperty,
          end: const Offset(250, 200),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.move.down", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Move from center downward
    await helper.drag(
      const Offset(200, 200),
      const Offset(200, 250),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(150, 200),
          property: expectedProperty,
          end: const Offset(250, 300),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.move.left", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Move from center to left
    await helper.drag(
      const Offset(200, 200),
      const Offset(150, 200),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(100, 150),
          property: expectedProperty,
          end: const Offset(200, 250),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.move.right", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Move from center to right
    await helper.drag(
      const Offset(200, 200),
      const Offset(250, 200),
    );
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(200, 150),
          property: expectedProperty,
          end: const Offset(300, 250),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.property.backgroundColor",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Change background color
    context.controller.property.setValues(
      backgroundColor: const Color(0xFFFF0000),
    );
    await tester.pumpAndSettle();
    expect(
      context.controller.value.first.property.backgroundColor,
      const Color(0xFFFF0000),
    );
  });

  testWidgets("PainterField.field.rectangle.property.foregroundColor",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Change foreground color
    context.controller.property.setValues(
      foregroundColor: const Color(0xFF0000FF),
    );
    await tester.pumpAndSettle();
    expect(
      context.controller.value.first.property.foregroundColor,
      const Color(0xFF0000FF),
    );
  });

  testWidgets("PainterField.field.rectangle.property.line", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Change line width
    context.controller.property.setValues(
      line: const Solid10pxLinePainterBlockTools(),
    );
    await tester.pumpAndSettle();
    expect(
      context.controller.value.first.property.line?.id,
      const Solid10pxLinePainterBlockTools().id,
    );
  });

  testWidgets("PainterField.field.rectangle.clipboard.copy_paste",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Save current value before clipboard operations
    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();
    // Copy
    await context.controller.clipboard.copy();
    await tester.pumpAndSettle();
    // Verify can paste
    expect(context.controller.clipboard.canPaste, true);
    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();
    // Verify object was duplicated
    expect(context.controller.value.length, 2);
    // Verify pasted object is offset by 20px
    expect(context.controller.value[1].start.dx, 170.0);
    expect(context.controller.value[1].start.dy, 170.0);
  });

  testWidgets("PainterField.field.rectangle.clipboard.cut_paste",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Save current value before clipboard operations
    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();
    // Cut
    await context.controller.clipboard.cut();
    await tester.pumpAndSettle();
    // Verify object was deleted
    expect(context.controller.value.length, 0);
    // Verify can paste
    expect(context.controller.clipboard.canPaste, true);
    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();
    // Verify object was restored
    expect(context.controller.value.length, 1);
    // Verify pasted object is offset by 20px from original
    expect(context.controller.value[0].start.dx, 170.0);
    expect(context.controller.value[0].start.dy, 170.0);
  });

  testWidgets("PainterField.field.rectangle.history.resize_undo_redo",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    final expectedProperty = context.controller.property.currentToolProperty;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    // Resize
    await helper.drag(
      const Offset(250, 250),
      const Offset(300, 300),
    );
    await tester.pumpAndSettle();
    // Verify resized
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(300, 300),
        )
      ].toDebug(),
    );
    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();
    // Verify undone
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
    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();
    // Verify redone
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(300, 300),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.history.move_undo_redo",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    final expectedProperty = context.controller.property.currentToolProperty;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    // Move
    await helper.drag(
      const Offset(200, 200),
      const Offset(250, 250),
    );
    await tester.pumpAndSettle();
    // Verify moved
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(200, 200),
          property: expectedProperty,
          end: const Offset(300, 300),
        )
      ].toDebug(),
    );
    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();
    // Verify undone
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
    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();
    // Verify redone
    expect(
      context.controller.value.toDebug(),
      [
        RectanglePaintingValue(
          id: uuid(),
          start: const Offset(200, 200),
          property: expectedProperty,
          end: const Offset(300, 300),
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.rectangle.history.backgroundColor_undo_redo",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final originalBackgroundColor =
        context.controller.value.first.property.backgroundColor;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    // Change background color
    context.controller.property.setValues(
      backgroundColor: const Color(0xFFFF0000),
    );
    await tester.pumpAndSettle();
    // Verify changed
    expect(
      context.controller.value.first.property.backgroundColor,
      const Color(0xFFFF0000),
    );
    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();
    // Verify undone
    expect(
      context.controller.value.first.property.backgroundColor,
      originalBackgroundColor,
    );
    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();
    // Verify redone
    expect(
      context.controller.value.first.property.backgroundColor,
      const Color(0xFFFF0000),
    );
  });

  testWidgets("PainterField.field.rectangle.history.foregroundColor_undo_redo",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final originalForegroundColor =
        context.controller.value.first.property.foregroundColor;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    // Change foreground color
    context.controller.property.setValues(
      foregroundColor: const Color(0xFF0000FF),
    );
    await tester.pumpAndSettle();
    // Verify changed
    expect(
      context.controller.value.first.property.foregroundColor,
      const Color(0xFF0000FF),
    );
    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();
    // Verify undone
    expect(
      context.controller.value.first.property.foregroundColor,
      originalForegroundColor,
    );
    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();
    // Verify redone
    expect(
      context.controller.value.first.property.foregroundColor,
      const Color(0xFF0000FF),
    );
  });

  testWidgets("PainterField.field.rectangle.history.line_undo_redo",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final originalLineId = context.controller.value.first.property.line?.id;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    // Change line width
    context.controller.property.setValues(
      line: const Solid10pxLinePainterBlockTools(),
    );
    await tester.pumpAndSettle();
    // Verify changed
    expect(
      context.controller.value.first.property.line?.id,
      const Solid10pxLinePainterBlockTools().id,
    );
    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();
    // Verify undone
    expect(
      context.controller.value.first.property.line?.id,
      originalLineId,
    );
    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();
    // Verify redone
    expect(
      context.controller.value.first.property.line?.id,
      const Solid10pxLinePainterBlockTools().id,
    );
  });
}
