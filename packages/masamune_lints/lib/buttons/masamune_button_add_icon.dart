part of '/masamune_lints.dart';

class _MasamuneButtonAddIcon extends DartAssist {
  _MasamuneButtonAddIcon();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!target.intersects(node.constructorName.sourceRange)) {
        return;
      }
      final createdType = node.constructorName.type.type;
      if (createdType == null ||
          !TypeChecker.any(_MaterialButtonType.values.map((e) => e.typeChecker))
              .isExactlyType(createdType)) {
        return;
      }
      final simpleIdentifier = node.constructorName.name;
      final supportedIdentifier = simpleIdentifier?.toSupportedIdentifier();

      if (supportedIdentifier != null && supportedIdentifier.hasIcon) {
        return;
      }
      final changeBuilder = reporter.createChangeBuilder(
        message: "Add icon to button",
        priority: _kAddOrRemoveIconPriority,
      );

      changeBuilder.addDartFileEdit((builder) {
        if (supportedIdentifier == _SupportedIdentifier.tonal) {
          builder.addSimpleReplacement(
            node.constructorName.sourceRange,
            "FilledButton.tonalIcon",
          );
        } else {
          builder.addSimpleInsertion(
            node.constructorName.sourceRange.end,
            ".icon",
          );
        }

        bool existIcon = false;
        for (var argument in node.argumentList.arguments) {
          if (argument is NamedExpression) {
            if (argument.name.label.name == "child") {
              builder.addSimpleReplacement(
                argument.name.sourceRange,
                "label:",
              );
            }
            if (argument.name.label.name == "icon") {
              existIcon = true;
            }
          }
        }
        if (!existIcon) {
          builder.addSimpleInsertion(
            node.argumentList.arguments.last.sourceRange.end,
            ", icon: Icon(Icons.add // TODO: Change icon)",
          );
        }
      });
    });
  }
}
