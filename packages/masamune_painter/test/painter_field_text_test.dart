import "package:flutter/material.dart";
import "package:katana/katana.dart";
import "package:masamune_painter/masamune_painter.dart";
import "package:flutter_test/flutter_test.dart";

import "functions.dart";

void main() {
  testWidgets("PainterField.field.text", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    toolbar.toggleMode(const TextPainterPrimaryTools());
    expect(context.controller.currentTool, const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    expect(
      context.controller.value.toDebug(),
      [
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(250, 250),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.resize.topLeft", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(100, 100),
          property: expectedProperty,
          end: const Offset(250, 250),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.resize.topRight", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 250),
          property: expectedProperty,
          end: const Offset(300, 100),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.resize.bottomRight", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(300, 300),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.resize.bottomLeft", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(100, 150),
          property: expectedProperty,
          end: const Offset(250, 300),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.resize.top", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 100),
          property: expectedProperty,
          end: const Offset(250, 250),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.resize.right", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(300, 250),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.resize.bottom", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(250, 300),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.resize.left", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(100, 150),
          property: expectedProperty,
          end: const Offset(250, 250),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.move.up", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 100),
          property: expectedProperty,
          end: const Offset(250, 200),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.move.down", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 200),
          property: expectedProperty,
          end: const Offset(250, 300),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.move.left", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(100, 150),
          property: expectedProperty,
          end: const Offset(200, 250),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.move.right", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(200, 150),
          property: expectedProperty,
          end: const Offset(300, 250),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.property.foregroundColor",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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

  testWidgets("PainterField.field.text.property.fontSize", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Change font size
    context.controller.property.setValues(
      fontSize: const Size32pxFontPainterBlockTools(),
    );
    await tester.pumpAndSettle();
    expect(
      context.controller.value.first.property.fontSize?.id,
      const Size32pxFontPainterBlockTools().id,
    );
  });

  testWidgets("PainterField.field.text.property.fontStyle", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Change font style
    context.controller.property.setValues(
      fontStyle: const StyleBoldFontPainterBlockTools(),
    );
    await tester.pumpAndSettle();
    expect(
      context.controller.value.first.property.fontStyle?.id,
      const StyleBoldFontPainterBlockTools().id,
    );
  });

  testWidgets("PainterField.field.text.text.simple", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode to enable text editing
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Set text
    context.controller.setText("Hello World");
    await tester.pumpAndSettle();
    expect(
      context.controller.value.toDebug(),
      [
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(250, 250),
          text: "Hello World",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.text.multiline", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(350, 350),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Set multiline text
    const multilineText = "Line 1\nLine 2\nLine 3";
    context.controller.setText(multilineText);
    await tester.pumpAndSettle();
    expect(
      context.controller.value.toDebug(),
      [
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(350, 350),
          text: multilineText,
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.text.long", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(450, 350),
    );
    final expectedProperty = context.controller.property.currentToolProperty;
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    expect(context.controller.currentValues.isNotEmpty, true);
    // Set long text (more than 100 characters)
    const longText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.";
    context.controller.setText(longText);
    await tester.pumpAndSettle();
    expect(
      context.controller.value.toDebug(),
      [
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(450, 350),
          text: longText,
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.clipboard.copy_paste", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Set text
    context.controller.setText("Test Text");
    await tester.pumpAndSettle();
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
    // Verify text was copied
    final pastedText = (context.controller.value[1] as TextPaintingValue).text;
    expect(pastedText, "Test Text");
  });

  testWidgets("PainterField.field.text.clipboard.cut_paste", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Set text
    context.controller.setText("Test Text");
    await tester.pumpAndSettle();
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
    // Verify text was preserved
    final pastedText = (context.controller.value[0] as TextPaintingValue).text;
    expect(pastedText, "Test Text");
  });

  testWidgets("PainterField.field.text.history.resize_undo_redo",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    final expectedProperty = context.controller.property.currentToolProperty;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(300, 300),
          text: "",
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(250, 250),
          text: "",
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(300, 300),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.history.move_undo_redo", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    final expectedProperty = context.controller.property.currentToolProperty;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(200, 200),
          property: expectedProperty,
          end: const Offset(300, 300),
          text: "",
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(250, 250),
          text: "",
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(200, 200),
          property: expectedProperty,
          end: const Offset(300, 300),
          text: "",
        )
      ].toDebug(),
    );
  });

  testWidgets("PainterField.field.text.history.foregroundColor_undo_redo",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
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

  testWidgets("PainterField.field.text.history.text_undo_redo", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    final expectedProperty = context.controller.property.currentToolProperty;
    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(
      const Offset(150, 150),
      const Offset(250, 250),
    );
    // Switch to select mode
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    // Set text
    context.controller.setText("Modified Text");
    await tester.pumpAndSettle();
    // Verify text changed
    expect(
      context.controller.value.toDebug(),
      [
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(250, 250),
          text: "Modified Text",
        )
      ].toDebug(),
    );
    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();
    // Verify undone (should be empty text)
    expect(
      context.controller.value.toDebug(),
      [
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(250, 250),
          text: "",
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
        TextPaintingValue(
          id: uuid(),
          start: const Offset(150, 150),
          property: expectedProperty,
          end: const Offset(250, 250),
          text: "Modified Text",
        )
      ].toDebug(),
    );
  });
}
