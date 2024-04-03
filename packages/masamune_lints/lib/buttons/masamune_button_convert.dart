part of '/masamune_lints.dart';

class _MasamuneButtonConvert extends DartAssist {
  _MasamuneButtonConvert({
    required this.targetType,
  });
  final _MaterialButtonType targetType;
  late final baseType = targetType != _MaterialButtonType.filled
      ? targetType.getBaseType()
      : null;

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
          !(baseType?.isExactlyType(createdType) ?? false)) {
        return;
      }

      final simpleIdentifier = node.constructorName.name;
      final isFilledButton = const TypeChecker.fromName(
        "FilledButton",
        packageName: "flutter",
      ).isExactlyType(createdType);
      final supportedIdentifier = simpleIdentifier?.toSupportedIdentifier();

      if (isFilledButton) {
        if (supportedIdentifier?.isTonal ?? false) {
          if (targetType == _MaterialButtonType.filledTonal) {
            return;
          }
        } else {
          if (targetType == _MaterialButtonType.filled) {
            return;
          }
        }
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: "Convert to ${targetType.buttonName}",
        priority: targetType.priority,
      );

      changeBuilder.addDartFileEdit(
        (builder) {
          builder.addSimpleReplacement(
            node.constructorName.sourceRange,
            targetType.className +
                _getReplacementIdentifier(supportedIdentifier, targetType),
          );
        },
      );
    });
  }

  String _getReplacementIdentifier(
      _SupportedIdentifier? identifier, _MaterialButtonType targetType) {
    if (identifier?.hasIcon ?? false) {
      if (targetType == _MaterialButtonType.filledTonal) {
        return ".tonalIcon";
      } else {
        return ".icon";
      }
    } else {
      if (targetType == _MaterialButtonType.filledTonal) {
        return ".tonal";
      } else {
        return "";
      }
    }
  }
}
