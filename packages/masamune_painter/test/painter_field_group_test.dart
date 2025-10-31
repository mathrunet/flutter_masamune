// Package imports:
import "package:flutter_test/flutter_test.dart";

// Project imports:
import "package:masamune_painter/masamune_painter.dart";
import "functions.dart";

void main() {
  // ========================================
  // 1. グループの基本操作（8テスト）
  // ========================================

  testWidgets("PainterField.group.create.rectangles", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Draw two rectangles
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));
    await tester.pumpAndSettle();

    // Select both rectangles
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    await tester.pumpAndSettle();

    expect(context.controller.currentValues.length, 2);

    // Create group
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    expect(group, isNotNull);
    expect(group!.children.length, 2);
    expect(context.controller.value.length, 1);
    expect(context.controller.value.first, isA<GroupPaintingValue>());
  });

  testWidgets("PainterField.group.create.mixed", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));

    await helper.reset();

    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    // Select both
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    await tester.pumpAndSettle();

    expect(context.controller.currentValues.length, 2);

    // Create group
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    expect(group, isNotNull);
    expect(group!.children.length, 2);
    expect(group.children[0], isA<RectanglePaintingValue>());
    expect(group.children[1], isA<TextPaintingValue>());
  });

  testWidgets("PainterField.group.ungroup.rectangles", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Draw and group two rectangles
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    await tester.pumpAndSettle();

    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);

    // Ungroup
    context.controller.ungroup(group!.id);
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    expect(context.controller.value[0], isA<RectanglePaintingValue>());
    expect(context.controller.value[1], isA<RectanglePaintingValue>());
  });

  testWidgets("PainterField.group.ungroup.mixed", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Draw rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));

    await helper.reset();

    // Draw text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();

    // Group
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Ungroup
    context.controller.ungroup(group!.id);
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    expect(context.controller.currentValues.length, 2);
  });

  testWidgets("PainterField.group.select", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Deselect and select group
    context.controller.unselectAll();
    await tester.pumpAndSettle();
    context.controller.select(group!);
    await tester.pumpAndSettle();

    expect(context.controller.currentValues.length, 3); // group + 2 children
    expect(context.controller.currentValues.first, equals(group));
  });

  testWidgets("PainterField.group.move", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    final originalStart = group!.start;

    // Move group
    await helper.drag(const Offset(200, 150), const Offset(250, 200));
    await tester.pumpAndSettle();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    expect(updatedGroup.start.dx, greaterThan(originalStart.dx));
    expect(updatedGroup.start.dy, greaterThan(originalStart.dy));
  });

  testWidgets("PainterField.group.resize", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    final originalEnd = group!.end;

    // Resize group from bottom-right
    await helper.drag(originalEnd, const Offset(400, 250));
    await tester.pumpAndSettle();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    expect(updatedGroup.end.dx, greaterThan(originalEnd.dx));
    expect(updatedGroup.end.dy, greaterThan(originalEnd.dy));
  });

  testWidgets("PainterField.group.nested", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create first group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await helper.reset();

    // Add another rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(320, 100), const Offset(420, 200));

    // Select group and new rectangle to create nested group
    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group2 = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    expect(group2!.children.length, 3); // Flattened: 2 from group1 + 1 new
  });

  // ========================================
  // 2. グループへのオブジェクト追加・削除（8テスト）
  // ========================================

  testWidgets("PainterField.group.addToGroup.rectangle", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group with 2 rectangles
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await helper.reset();

    // Add new rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(400, 100), const Offset(500, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    final newRectId = context.controller.value.last.id;

    // Add to group
    context.controller.addToGroup(newRectId, group!.id);
    await tester.pumpAndSettle();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    expect(updatedGroup.children.length, 3);
  });

  testWidgets("PainterField.group.addToGroup.text", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await helper.reset();

    // Add text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(400, 100), const Offset(500, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    final textId = context.controller.value.last.id;

    // Add to group
    context.controller.addToGroup(textId, group!.id);
    await tester.pumpAndSettle();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    expect(updatedGroup.children.length, 3);
    expect(updatedGroup.children.last, isA<TextPaintingValue>());
  });

  testWidgets("PainterField.group.removeFromGroup.rectangle", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;
    final controller = context.controller;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    controller.selectAll();
    final group = controller.createGroupFromSelection();
    await helper.reset();

    final childId = group!.children.first.id;

    // Remove from group
    final sourceGroup = controller.value
        .firstWhere((v) => v is GroupPaintingValue) as GroupPaintingValue;
    expect(sourceGroup.children.length, 2);
    controller.removeFromGroup(childId);
    await tester.pumpAndSettle();

    expect(controller.value.length, 2);
    final updatedGroup = controller.value
        .firstWhere((v) => v is GroupPaintingValue) as GroupPaintingValue;
    expect(updatedGroup.children.length, 1);
  });

  testWidgets("PainterField.group.removeFromGroup.text", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create mixed group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();

    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await helper.reset();

    final textChild = group!.children.firstWhere((c) => c is TextPaintingValue);

    // Remove text from group
    context.controller.removeFromGroup(textChild.id);
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    final updatedGroup = context.controller.value
        .firstWhere((v) => v is GroupPaintingValue) as GroupPaintingValue;
    expect(updatedGroup.children.length, 1);
    expect(updatedGroup.children.first, isA<RectanglePaintingValue>());
  });

  testWidgets("PainterField.group.removeFromGroup.lastElement", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group with 2 elements
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await helper.reset();

    // Remove first element
    context.controller.removeFromGroup(group!.children.first.id);
    await tester.pumpAndSettle();

    // Should still have group with 1 element
    expect(context.controller.value.length, 2);

    // Remove last element - group should be deleted
    final remainingGroup = context.controller.value
        .firstWhere((v) => v is GroupPaintingValue) as GroupPaintingValue;
    context.controller.removeFromGroup(remainingGroup.children.first.id);
    await tester.pumpAndSettle();

    // Group should be gone, only standalone rectangles remain
    expect(
        context.controller.value.every((v) => v is! GroupPaintingValue), true);
  });

  testWidgets("PainterField.group.moveToGroup.rectangle", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create two groups
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();

    await tester.pumpAndSettle();
    final group1 = context.controller.createGroupFromSelection();
    await helper.reset();

    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(460, 100), const Offset(560, 200));
    await helper.reset();

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    // Select only the two new rectangles
    context.controller.unselectAll();

    await helper.reset();

    context.controller.select(context.controller.value[1]);
    context.controller.select(context.controller.value[2]);
    final group2 = context.controller.createGroupFromSelection();
    await helper.reset();

    final itemId = group1!.children.first.id;

    // Move from group1 to group2
    context.controller.moveToGroup(itemId, group1.id, group2!.id, 0);
    await tester.pumpAndSettle();

    final updatedGroup1 = context.controller.value
        .firstWhere((v) => v.id == group1.id) as GroupPaintingValue;
    final updatedGroup2 = context.controller.value
        .firstWhere((v) => v.id == group2.id) as GroupPaintingValue;

    expect(updatedGroup1.children.length, 1);
    expect(updatedGroup2.children.length, 3);
  });

  testWidgets("PainterField.group.moveToGroup.text", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group1 with rectangle and text
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();

    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group1 = context.controller.createGroupFromSelection();
    await helper.reset();

    // Create group2
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(460, 100), const Offset(560, 200));
    await tester.pumpAndSettle();

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.unselectAll();
    await helper.reset();

    context.controller.select(context.controller.value[1]);
    context.controller.select(context.controller.value[2]);
    final group2 = context.controller.createGroupFromSelection();
    await helper.reset();

    final textChild =
        group1!.children.firstWhere((c) => c is TextPaintingValue);

    // Move text from group1 to group2
    context.controller.moveToGroup(textChild.id, group1.id, group2!.id, 0);
    await tester.pumpAndSettle();

    final updatedGroup2 = context.controller.value
        .firstWhere((v) => v.id == group2.id) as GroupPaintingValue;
    expect(updatedGroup2.children.first, isA<TextPaintingValue>());
  });

  testWidgets("PainterField.group.addMultipleToGroup", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    await helper.reset();

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await helper.reset();

    // Add multiple new objects
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));

    await helper.reset();

    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(460, 100), const Offset(560, 200));
    await tester.pumpAndSettle();

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    final newRect = context.controller.value[1];
    final newText = context.controller.value[2];

    // Add both to group
    context.controller.addToGroup(newRect.id, group!.id);
    context.controller.addToGroup(newText.id, group.id);
    await helper.reset();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    expect(updatedGroup.children.length, 4);
  });

  // ========================================
  // 3. グループ内の重ね合わせ順変更（8テスト）
  // ========================================

  testWidgets("PainterField.group.reorderInGroup.forward", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group with 3 rectangles
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));

    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(320, 100), const Offset(420, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await helper.reset();

    final firstChildId = group!.children[0].id;

    // Reorder: move first to second position
    context.controller.reorderInGroup(group.id, 0, 1);
    await helper.reset();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    expect(updatedGroup.children[1].id, firstChildId);
  });

  testWidgets("PainterField.group.reorderInGroup.backward", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group with 3 rectangles
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(320, 100), const Offset(420, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    final lastChildId = group!.children[2].id;

    // Reorder: move last to second position
    context.controller.reorderInGroup(group.id, 2, 1);
    await tester.pumpAndSettle();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    expect(updatedGroup.children[1].id, lastChildId);
  });

  testWidgets("PainterField.group.reorderInGroup.toFront", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(320, 100), const Offset(420, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    final firstChildId = group!.children[0].id;

    // Move first to last (front)
    context.controller.reorderInGroup(group.id, 0, 2);
    await tester.pumpAndSettle();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    expect(updatedGroup.children[2].id, firstChildId);
  });

  testWidgets("PainterField.group.reorderInGroup.toBack", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(320, 100), const Offset(420, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    final lastChildId = group!.children[2].id;

    // Move last to first (back)
    context.controller.reorderInGroup(group.id, 2, 0);
    await tester.pumpAndSettle();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    expect(updatedGroup.children[0].id, lastChildId);
  });

  testWidgets("PainterField.group.reorderInGroup.mixed", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create mixed group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();

    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));
    await helper.reset();

    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(320, 100), const Offset(420, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Text is at index 1, move it to index 0
    context.controller.reorderInGroup(group!.id, 1, 0);
    await tester.pumpAndSettle();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    expect(updatedGroup.children[0], isA<TextPaintingValue>());
    expect(updatedGroup.children[1], isA<RectanglePaintingValue>());
  });

  testWidgets("PainterField.group.reorder.groupItself", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Add standalone rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value.length, 2);
    expect(context.controller.value[0].id, group!.id);

    // Reorder: move group from index 0 to index 1
    context.controller.reorder(0, 1);
    await tester.pumpAndSettle();

    expect(context.controller.value[1].id, group.id);
  });

  testWidgets("PainterField.group.reorder.nestedGroup", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create first group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Add standalone rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    // Create outer group (nested)
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value.length, 1);
    expect(context.controller.value[0], isA<GroupPaintingValue>());

    final outerGroup = context.controller.value[0] as GroupPaintingValue;
    // Should have 3 children (flattened from inner group + 1 rectangle)
    expect(outerGroup.children.length, 3);
  });

  testWidgets("PainterField.group.reorderInGroup.multipleElements",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group with 4 elements
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(160, 100), const Offset(210, 150));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(220, 100), const Offset(270, 150));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(280, 100), const Offset(330, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    final secondId = group!.children[1].id;
    final fourthId = group.children[3].id;

    // Multiple reorders
    context.controller.reorderInGroup(group.id, 1, 2);
    await tester.pumpAndSettle();
    await helper.reset();
    context.controller.reorderInGroup(group.id, 2, 3);
    await tester.pumpAndSettle();

    final updatedGroup = context.controller.value.first as GroupPaintingValue;
    // After reorderInGroup(1, 2): [first, third, second, fourth]
    // After reorderInGroup(2, 3): [first, third, fourth, second]
    expect(updatedGroup.children[3].id, secondId);
    expect(updatedGroup.children[2].id, fourthId);
  });

  // ========================================
  // 4. グループと非グループの重ね合わせ順（8テスト）
  // ========================================

  testWidgets("PainterField.group.layerOrder.moveForward", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Add rectangle on top
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group!.id);

    // Select group and move forward
    context.controller.unselectAll();
    await helper.reset();
    context.controller.select(group);
    context.controller.moveSelectedLayersForward();
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value[1].id, group.id);
  });

  testWidgets("PainterField.group.layerOrder.moveBackward", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Add rectangle first
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();

    // Create group
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();

    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    // Select only the two rectangles for grouping
    context.controller.unselectAll();
    context.controller.select(context.controller.value[1]);
    context.controller.select(context.controller.value[2]);
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value[1].id, group!.id);

    // Select group and move backward
    context.controller.unselectAll();
    context.controller.select(group);
    context.controller.moveSelectedLayersBackward();
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value[0].id, group.id);
  });

  testWidgets("PainterField.group.layerOrder.multipleForward", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Add standalone rectangle and text
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));
    await helper.reset();

    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(460, 100), const Offset(560, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    // Select group and rectangle, move forward
    final rectAngle = context.controller.value[1];
    context.controller.unselectAll();
    await helper.reset();
    context.controller.select(group!);
    context.controller.select(context.controller.value[1]);
    context.controller.moveSelectedLayersForward();
    await tester.pumpAndSettle();
    await helper.reset();

    // Both should have moved
    expect(context.controller.value[1].id, group.id);
    expect(context.controller.value[2].id, rectAngle.id);
  });

  testWidgets("PainterField.group.layerOrder.multipleBackward", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Add standalone text first
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(460, 100), const Offset(560, 200));
    await helper.reset();

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.unselectAll();
    await helper.reset();
    context.controller.select(context.controller.value[1]);
    context.controller.select(context.controller.value[2]);
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Add another rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    // Select group and rectangle, move backward
    context.controller.unselectAll();
    await helper.reset();
    context.controller.select(group!);
    context.controller.select(context.controller.value[2]);
    context.controller.moveSelectedLayersBackward();
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value[0].id, group.id);
  });

  testWidgets("PainterField.group.layerOrder.complexOrder", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create first group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(160, 100), const Offset(210, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group1 = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Add rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(220, 100), const Offset(270, 150));

    await helper.reset();
    // Add text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(280, 100), const Offset(330, 150));
    await helper.reset();

    // Create second group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(340, 100), const Offset(390, 150));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(400, 100), const Offset(450, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.unselectAll();
    await helper.reset();
    context.controller.select(context.controller.value[3]);
    context.controller.select(context.controller.value[4]);
    final group2 = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Verify order: group1, rect, text, group2
    expect(context.controller.value[0].id, group1!.id);
    expect(context.controller.value[1], isA<RectanglePaintingValue>());
    expect(context.controller.value[2], isA<TextPaintingValue>());
    expect(context.controller.value[3].id, group2!.id);

    // Move group2 backward twice
    context.controller.unselectAll();
    context.controller.select(group2);
    context.controller.moveSelectedLayersBackward();
    await tester.pumpAndSettle();
    context.controller.moveSelectedLayersBackward();
    await tester.pumpAndSettle();
    await helper.reset();

    // New order should be: group1, group2, rect, text
    expect(context.controller.value[0].id, group1.id);
    expect(context.controller.value[1].id, group2.id);
  });

  testWidgets("PainterField.group.layerOrder.nestedGroupOrder", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create nested group structure
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(160, 100), const Offset(210, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Add another rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(220, 100), const Offset(270, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    // Create outer nested group
    context.controller.selectAll();
    final nestedGroup = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Add standalone text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(280, 100), const Offset(330, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    // Move nested group forward
    context.controller.unselectAll();
    await helper.reset();
    context.controller.select(nestedGroup!);
    context.controller.moveSelectedLayersForward();
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value[1].id, nestedGroup.id);
  });

  testWidgets("PainterField.group.layerOrder.toFront", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group at back
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    // Add 3 more rectangles on top
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(460, 100), const Offset(560, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(570, 100), const Offset(670, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group!.id);

    // Move group to front (index 3)
    context.controller.unselectAll();
    await helper.reset();
    context.controller.select(group);
    context.controller.reorder(0, 3);
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value[3].id, group.id);
  });

  testWidgets("PainterField.group.layerOrder.toBack", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Add 3 rectangles first
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(460, 100), const Offset(560, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(570, 100), const Offset(670, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();

    // Create group on top
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.unselectAll();
    await helper.reset();
    context.controller.select(context.controller.value[3]);
    context.controller.select(context.controller.value[4]);
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value[3].id, group!.id);

    // Move group to back (index 0)
    context.controller.unselectAll();
    await helper.reset();
    context.controller.select(group);
    context.controller.reorder(3, 0);
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value[0].id, group.id);
  });

  // ========================================
  // 5. グループのクリップボード操作（8テスト）
  // ========================================

  testWidgets("PainterField.group.clipboard.copyPaste", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();
    await helper.reset();

    context.controller.select(group!);
    await tester.pumpAndSettle();

    // Copy
    await context.controller.clipboard.copy();
    await tester.pumpAndSettle();

    expect(context.controller.clipboard.canPaste, true);
    await helper.tap(const Offset(320, 210));
    await tester.pumpAndSettle();

    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();
    await helper.reset();

    expect(context.controller.value.length, 2);
    expect(context.controller.value[0], isA<GroupPaintingValue>());
    expect(context.controller.value[1], isA<GroupPaintingValue>());
  });

  testWidgets("PainterField.group.clipboard.copyPasteNested", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create nested group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.drag(const Offset(160, 100), const Offset(210, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(220, 100), const Offset(270, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();

    // Copy
    await context.controller.clipboard.copy();
    await tester.pumpAndSettle();

    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    final pastedGroup = context.controller.value[1] as GroupPaintingValue;
    expect(pastedGroup.children.length, 3); // Flattened
  });

  testWidgets("PainterField.group.clipboard.cutPaste", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();

    // Cut
    await context.controller.clipboard.cut();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 0);
    expect(context.controller.clipboard.canPaste, true);

    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    expect(context.controller.value[0], isA<GroupPaintingValue>());
  });

  testWidgets("PainterField.group.clipboard.cutPasteNested", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create nested group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.drag(const Offset(160, 100), const Offset(210, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(220, 100), const Offset(270, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();

    // Cut
    await context.controller.clipboard.cut();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 0);

    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    final pastedGroup = context.controller.value[0] as GroupPaintingValue;
    expect(pastedGroup.children.length, 3);
  });

  testWidgets("PainterField.group.clipboard.copyMultipleGroups",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create first group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.drag(const Offset(160, 100), const Offset(210, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Create second group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(220, 100), const Offset(270, 150));
    await helper.drag(const Offset(280, 100), const Offset(330, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.unselectAll();
    context.controller.select(context.controller.value[1]);
    context.controller.select(context.controller.value[2]);
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Select both groups
    context.controller.selectAll();
    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();

    // Copy
    await context.controller.clipboard.copy();
    await tester.pumpAndSettle();

    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 4); // 2 original + 2 copied
  });

  testWidgets("PainterField.group.clipboard.copyGroupAndNonGroup",
      (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.drag(const Offset(160, 100), const Offset(210, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Add standalone rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(220, 100), const Offset(270, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    // Select both
    context.controller.selectAll();
    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();

    // Copy
    await context.controller.clipboard.copy();
    await tester.pumpAndSettle();

    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 4); // group + rect + copied
  });

  testWidgets("PainterField.group.clipboard.cutGroupAndText", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.drag(const Offset(160, 100), const Offset(210, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Add text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(220, 100), const Offset(320, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    // Select both
    context.controller.selectAll();
    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();

    // Cut
    await context.controller.clipboard.cut();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 0);

    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    expect(context.controller.value.any((v) => v is GroupPaintingValue), true);
    expect(context.controller.value.any((v) => v is TextPaintingValue), true);
  });

  testWidgets("PainterField.group.clipboard.copyGroupChild", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Select group child directly (this will also select parent in current implementation)
    context.controller.unselectAll();
    context.controller.select(group!.children.first);
    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();

    // Copy
    await context.controller.clipboard.copy();
    await tester.pumpAndSettle();

    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();

    // Should paste the child element
    expect(context.controller.value.length, 2);
  });

  // ========================================
  // 6. グループ操作のUndoRedo（20テスト）
  // ========================================

  testWidgets("PainterField.group.undoRedo.create", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create two rectangles
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    await tester.pumpAndSettle();

    // Create group
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    expect(context.controller.value.first, isA<GroupPaintingValue>());

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    expect(context.controller.value.every((v) => v is RectanglePaintingValue),
        true);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    expect(context.controller.value.first, isA<GroupPaintingValue>());
    final redoneGroup = context.controller.value.first as GroupPaintingValue;
    expect(redoneGroup.children.length, 2);
  });

  testWidgets("PainterField.group.undoRedo.ungroup", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create and group rectangles
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Ungroup
    context.controller.ungroup(group!.id);
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    expect(context.controller.value.first, isA<GroupPaintingValue>());

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    expect(context.controller.value.every((v) => v is RectanglePaintingValue),
        true);
  });

  testWidgets("PainterField.group.undoRedo.addToGroup", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Add new rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(400, 100), const Offset(500, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    final newRectId = context.controller.value.last.id;

    // Add to group
    context.controller.addToGroup(newRectId, group!.id);
    await tester.pumpAndSettle();

    final groupAfterAdd = context.controller.value.first as GroupPaintingValue;
    expect(groupAfterAdd.children.length, 3);

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    final groupAfterUndo = context.controller.value.first as GroupPaintingValue;
    expect(groupAfterUndo.children.length, 2);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    final groupAfterRedo = context.controller.value.first as GroupPaintingValue;
    expect(groupAfterRedo.children.length, 3);
  });

  testWidgets("PainterField.group.undoRedo.removeFromGroup", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group with 3 rectangles
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(210, 100), const Offset(310, 200));
    await helper.drag(const Offset(320, 100), const Offset(420, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    final childId = group!.children.first.id;

    // Remove from group
    context.controller.removeFromGroup(childId);
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    final groupAfterRemove = context.controller.value
        .firstWhere((v) => v is GroupPaintingValue) as GroupPaintingValue;
    expect(groupAfterRemove.children.length, 2);

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    final groupAfterUndo = context.controller.value.first as GroupPaintingValue;
    expect(groupAfterUndo.children.length, 3);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    final groupAfterRedo = context.controller.value
        .firstWhere((v) => v is GroupPaintingValue) as GroupPaintingValue;
    expect(groupAfterRedo.children.length, 2);
  });

  testWidgets("PainterField.group.undoRedo.moveToGroup", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create two groups
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group1 = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));
    await helper.drag(const Offset(460, 100), const Offset(560, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.unselectAll();
    context.controller.select(context.controller.value[1]);
    context.controller.select(context.controller.value[2]);
    final group2 = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    final itemId = group1!.children.first.id;

    // Move from group1 to group2
    context.controller.moveToGroup(itemId, group1.id, group2!.id, 0);
    await tester.pumpAndSettle();

    final group1AfterMove = context.controller.value
        .firstWhere((v) => v.id == group1.id) as GroupPaintingValue;
    final group2AfterMove = context.controller.value
        .firstWhere((v) => v.id == group2.id) as GroupPaintingValue;
    expect(group1AfterMove.children.length, 1);
    expect(group2AfterMove.children.length, 3);

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    final group1AfterUndo = context.controller.value
        .firstWhere((v) => v.id == group1.id) as GroupPaintingValue;
    final group2AfterUndo = context.controller.value
        .firstWhere((v) => v.id == group2.id) as GroupPaintingValue;
    expect(group1AfterUndo.children.length, 2);
    expect(group2AfterUndo.children.length, 2);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    final group1AfterRedo = context.controller.value
        .firstWhere((v) => v.id == group1.id) as GroupPaintingValue;
    final group2AfterRedo = context.controller.value
        .firstWhere((v) => v.id == group2.id) as GroupPaintingValue;
    expect(group1AfterRedo.children.length, 1);
    expect(group2AfterRedo.children.length, 3);
  });

  testWidgets("PainterField.group.undoRedo.reorderInGroup", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group with 3 rectangles
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(210, 100), const Offset(310, 200));
    await helper.reset();
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(320, 100), const Offset(420, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    final firstChildId = group!.children[0].id;
    final secondChildId = group.children[1].id;

    // Reorder: move first to second position
    context.controller.reorderInGroup(group.id, 0, 1);
    await tester.pumpAndSettle();

    final groupAfterReorder =
        context.controller.value.first as GroupPaintingValue;
    expect(groupAfterReorder.children[0].id, secondChildId);
    expect(groupAfterReorder.children[1].id, firstChildId);

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    final groupAfterUndo = context.controller.value.first as GroupPaintingValue;
    expect(groupAfterUndo.children[0].id, firstChildId);
    expect(groupAfterUndo.children[1].id, secondChildId);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    final groupAfterRedo = context.controller.value.first as GroupPaintingValue;
    expect(groupAfterRedo.children[0].id, secondChildId);
    expect(groupAfterRedo.children[1].id, firstChildId);
  });

  testWidgets("PainterField.group.undoRedo.moveForward", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Add rectangle on top
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group!.id);

    // Move forward
    context.controller.unselectAll();
    context.controller.select(group);
    context.controller.moveSelectedLayersForward();
    await tester.pumpAndSettle();

    expect(context.controller.value[1].id, group.id);

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group.id);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value[1].id, group.id);
  });

  testWidgets("PainterField.group.undoRedo.moveBackward", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Add rectangle first
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));

    // Create group
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.unselectAll();
    context.controller.select(context.controller.value[1]);
    context.controller.select(context.controller.value[2]);
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    expect(context.controller.value[1].id, group!.id);

    // Move backward
    context.controller.unselectAll();
    context.controller.select(group);
    context.controller.moveSelectedLayersBackward();
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group.id);

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value[1].id, group.id);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group.id);
  });

  testWidgets("PainterField.group.undoRedo.reorder", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Add two rectangles
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));
    await helper.drag(const Offset(460, 100), const Offset(560, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group!.id);

    // Reorder: move group from index 0 to index 2
    context.controller.reorder(0, 2);
    await tester.pumpAndSettle();

    expect(context.controller.value[2].id, group.id);

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group.id);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value[2].id, group.id);
  });

  testWidgets("PainterField.group.undoRedo.move", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    final originalStart = group!.start;

    // Move group
    await helper.drag(const Offset(200, 150), const Offset(250, 200));
    await tester.pumpAndSettle();

    final movedGroup = context.controller.value.first as GroupPaintingValue;
    expect(movedGroup.start.dx, greaterThan(originalStart.dx));
    expect(movedGroup.start.dy, greaterThan(originalStart.dy));

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    final undoneGroup = context.controller.value.first as GroupPaintingValue;
    expect(undoneGroup.start.dx, originalStart.dx);
    expect(undoneGroup.start.dy, originalStart.dy);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    final redoneGroup = context.controller.value.first as GroupPaintingValue;
    expect(redoneGroup.start.dx, greaterThan(originalStart.dx));
    expect(redoneGroup.start.dy, greaterThan(originalStart.dy));
  });

  testWidgets("PainterField.group.undoRedo.resize", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    final originalEnd = group!.end;

    // Resize group
    await helper.drag(originalEnd, const Offset(400, 250));
    await tester.pumpAndSettle();

    final resizedGroup = context.controller.value.first as GroupPaintingValue;
    expect(resizedGroup.end.dx, greaterThan(originalEnd.dx));
    expect(resizedGroup.end.dy, greaterThan(originalEnd.dy));

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    final undoneGroup = context.controller.value.first as GroupPaintingValue;
    expect(undoneGroup.end.dx, originalEnd.dx);
    expect(undoneGroup.end.dy, originalEnd.dy);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    final redoneGroup = context.controller.value.first as GroupPaintingValue;
    expect(redoneGroup.end.dx, greaterThan(originalEnd.dx));
    expect(redoneGroup.end.dy, greaterThan(originalEnd.dy));
  });

  testWidgets("PainterField.group.undoRedo.copyPaste", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();

    // Copy and paste
    await context.controller.clipboard.copy();
    await tester.pumpAndSettle();
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    expect(context.controller.value[0], isA<GroupPaintingValue>());
    expect(context.controller.value[1], isA<GroupPaintingValue>());
  });

  testWidgets("PainterField.group.undoRedo.cutPaste", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    context.controller.saveCurrentValue();
    await tester.pumpAndSettle();

    // Cut
    await context.controller.clipboard.cut();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 0);

    // Undo cut
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);

    // Redo cut
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 0);

    // Paste
    await context.controller.clipboard.paste();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);

    // Undo paste
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 0);

    // Redo paste
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    expect(context.controller.value[0], isA<GroupPaintingValue>());
  });

  testWidgets("PainterField.group.undoRedo.createMixed", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));

    // Create text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    await tester.pumpAndSettle();

    // Create group
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    expect(group!.children[0], isA<RectanglePaintingValue>());
    expect(group.children[1], isA<TextPaintingValue>());

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    expect(context.controller.value[0], isA<RectanglePaintingValue>());
    expect(context.controller.value[1], isA<TextPaintingValue>());

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    final redoneGroup = context.controller.value.first as GroupPaintingValue;
    expect(redoneGroup.children[0], isA<RectanglePaintingValue>());
    expect(redoneGroup.children[1], isA<TextPaintingValue>());
  });

  testWidgets("PainterField.group.undoRedo.addTextToGroup", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Add text
    toolbar.toggleMode(const TextPainterPrimaryTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(400, 100), const Offset(500, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    final textId = context.controller.value.last.id;

    // Add to group
    context.controller.addToGroup(textId, group!.id);
    await tester.pumpAndSettle();

    final groupAfterAdd = context.controller.value.first as GroupPaintingValue;
    expect(groupAfterAdd.children.length, 3);
    expect(groupAfterAdd.children.last, isA<TextPaintingValue>());

    // Undo
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    final groupAfterUndo = context.controller.value.first as GroupPaintingValue;
    expect(groupAfterUndo.children.length, 2);

    // Redo
    context.controller.history.redo();
    await tester.pumpAndSettle();

    final groupAfterRedo = context.controller.value.first as GroupPaintingValue;
    expect(groupAfterRedo.children.length, 3);
    expect(groupAfterRedo.children.last, isA<TextPaintingValue>());
  });

  testWidgets("PainterField.group.undoRedo.multipleReorder", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group with 4 elements
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.drag(const Offset(160, 100), const Offset(210, 150));
    await helper.drag(const Offset(220, 100), const Offset(270, 150));
    await helper.drag(const Offset(280, 100), const Offset(330, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    final firstId = group!.children[0].id;
    final secondId = group.children[1].id;
    final thirdId = group.children[2].id;

    // Multiple reorders
    context.controller.reorderInGroup(group.id, 0, 2);
    await tester.pumpAndSettle();
    context.controller.reorderInGroup(group.id, 2, 3);
    await tester.pumpAndSettle();

    final groupAfterReorders =
        context.controller.value.first as GroupPaintingValue;
    expect(groupAfterReorders.children[3].id, firstId);

    // Undo second reorder
    context.controller.history.undo();
    await tester.pumpAndSettle();

    final groupAfterFirstUndo =
        context.controller.value.first as GroupPaintingValue;
    expect(groupAfterFirstUndo.children[2].id, firstId);

    // Undo first reorder
    context.controller.history.undo();
    await tester.pumpAndSettle();

    final groupAfterSecondUndo =
        context.controller.value.first as GroupPaintingValue;
    expect(groupAfterSecondUndo.children[0].id, firstId);
    expect(groupAfterSecondUndo.children[1].id, secondId);
    expect(groupAfterSecondUndo.children[2].id, thirdId);

    // Redo first reorder
    context.controller.history.redo();
    await tester.pumpAndSettle();

    final groupAfterFirstRedo =
        context.controller.value.first as GroupPaintingValue;
    expect(groupAfterFirstRedo.children[2].id, firstId);

    // Redo second reorder
    context.controller.history.redo();
    await tester.pumpAndSettle();

    final groupAfterSecondRedo =
        context.controller.value.first as GroupPaintingValue;
    expect(groupAfterSecondRedo.children[3].id, firstId);
  });

  testWidgets("PainterField.group.undoRedo.complexSequence", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(210, 100), const Offset(310, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Add rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(350, 100), const Offset(450, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    final newRectId = context.controller.value.last.id;

    // Add to group
    context.controller.addToGroup(newRectId, group!.id);
    await tester.pumpAndSettle();

    // Reorder within group
    context.controller.reorderInGroup(group.id, 2, 0);
    await tester.pumpAndSettle();

    // Move group
    await helper.drag(const Offset(200, 150), const Offset(250, 200));
    await tester.pumpAndSettle();

    // Verify final state
    final finalGroup = context.controller.value.first as GroupPaintingValue;
    expect(finalGroup.children.length, 3);

    // Undo move
    context.controller.history.undo();
    await tester.pumpAndSettle();

    // Undo reorder
    context.controller.history.undo();
    await tester.pumpAndSettle();

    // Undo addToGroup
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);
    final groupAfterUndos =
        context.controller.value.first as GroupPaintingValue;
    expect(groupAfterUndos.children.length, 2);

    // Redo all
    context.controller.history.redo();
    await tester.pumpAndSettle();
    context.controller.history.redo();
    await tester.pumpAndSettle();
    context.controller.history.redo();
    await tester.pumpAndSettle();

    final groupAfterRedos =
        context.controller.value.first as GroupPaintingValue;
    expect(groupAfterRedos.children.length, 3);
  });

  testWidgets("PainterField.group.undoRedo.nestedGroup", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create first group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.drag(const Offset(160, 100), const Offset(210, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Add rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(220, 100), const Offset(270, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();

    // Create nested group
    context.controller.selectAll();
    final nestedGroup = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    expect(nestedGroup!.children.length, 3); // Flattened

    // Undo nested group creation
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 2);

    // Redo nested group creation
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    final redoneGroup = context.controller.value.first as GroupPaintingValue;
    expect(redoneGroup.children.length, 3);
  });

  testWidgets("PainterField.group.undoRedo.removeLastElement", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create group with 2 elements
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(200, 200));
    await helper.drag(const Offset(250, 100), const Offset(350, 200));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    final firstId = group!.children.first.id;

    // Remove first element
    context.controller.removeFromGroup(firstId);
    await tester.pumpAndSettle();

    // Remove last element (should delete group)
    final remainingGroup = context.controller.value
        .firstWhere((v) => v is GroupPaintingValue) as GroupPaintingValue;
    context.controller.removeFromGroup(remainingGroup.children.first.id);
    await tester.pumpAndSettle();

    expect(
        context.controller.value.every((v) => v is! GroupPaintingValue), true);

    // Undo last removal
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.any((v) => v is GroupPaintingValue), true);

    // Undo first removal
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value.length, 1);
    final restoredGroup = context.controller.value.first as GroupPaintingValue;
    expect(restoredGroup.children.length, 2);

    // Redo removals
    context.controller.history.redo();
    await tester.pumpAndSettle();
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(
        context.controller.value.every((v) => v is! GroupPaintingValue), true);
  });

  testWidgets("PainterField.group.undoRedo.layerOrderComplex", (tester) async {
    final context = await buildPainterField(tester);
    final toolbar = context.toolbar;
    final helper = context.input;

    // Create first group
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(100, 100), const Offset(150, 150));
    await helper.drag(const Offset(160, 100), const Offset(210, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.selectAll();
    final group1 = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Add standalone rectangle
    toolbar.toggleMode(const RectangleShapePainterInlineTools());
    await tester.pumpAndSettle();
    await helper.drag(const Offset(220, 100), const Offset(270, 150));

    // Create second group
    await helper.drag(const Offset(280, 100), const Offset(330, 150));
    await helper.drag(const Offset(340, 100), const Offset(390, 150));

    toolbar.toggleMode(const SelectPainterInlineTools());
    await tester.pumpAndSettle();
    context.controller.unselectAll();
    context.controller.select(context.controller.value[2]);
    context.controller.select(context.controller.value[3]);
    final group2 = context.controller.createGroupFromSelection();
    await tester.pumpAndSettle();

    // Initial order: group1, rect, group2
    expect(context.controller.value[0].id, group1!.id);
    expect(context.controller.value[1], isA<RectanglePaintingValue>());
    expect(context.controller.value[2].id, group2!.id);

    // Move group2 backward
    context.controller.unselectAll();
    context.controller.select(group2);
    context.controller.moveSelectedLayersBackward();
    await tester.pumpAndSettle();

    // Order: group1, group2, rect
    expect(context.controller.value[1].id, group2.id);

    // Move group1 forward
    context.controller.unselectAll();
    context.controller.select(group1);
    context.controller.moveSelectedLayersForward();
    await tester.pumpAndSettle();

    // Order: group2, group1, rect
    expect(context.controller.value[0].id, group2.id);
    expect(context.controller.value[1].id, group1.id);

    // Undo group1 forward
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group1.id);
    expect(context.controller.value[1].id, group2.id);

    // Undo group2 backward
    context.controller.history.undo();
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group1.id);
    expect(context.controller.value[1], isA<RectanglePaintingValue>());
    expect(context.controller.value[2].id, group2.id);

    // Redo both
    context.controller.history.redo();
    await tester.pumpAndSettle();
    context.controller.history.redo();
    await tester.pumpAndSettle();

    expect(context.controller.value[0].id, group2.id);
    expect(context.controller.value[1].id, group1.id);
  });
}
