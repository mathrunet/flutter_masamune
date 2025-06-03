part of "/masamune_lints.dart";

class _MasamuneButtonRemoveIcon extends DartAssist {
  _MasamuneButtonRemoveIcon();

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

      if (supportedIdentifier != null && !supportedIdentifier.hasIcon) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: "Remove icon from button",
        priority: _kAddOrRemoveIconPriority,
      );

      changeBuilder.addDartFileEdit((builder) {
        if (supportedIdentifier == _SupportedIdentifier.tonalIcon) {
          builder.addSimpleReplacement(
            node.constructorName.sourceRange,
            "FilledButton.tonal",
          );
        } else {
          builder.addSimpleReplacement(
            node.constructorName.sourceRange,
            node.constructorName.type.name2.lexeme,
          );
        }

        for (var argument in node.argumentList.arguments) {
          if (argument is NamedExpression) {
            if (argument.name.label.name == "label") {
              builder.addSimpleReplacement(
                argument.name.sourceRange,
                "child:",
              );
            }

            if (argument.name.label.name == "icon") {
              builder.addDeletion(
                SourceRange(
                  argument.sourceRange.offset,
                  argument.sourceRange.length +
                      (argument.endToken.next?.lexeme == "," ? 1 : 0),
                ),
              );
            }
          }
        }
      });
    });
  }
}
