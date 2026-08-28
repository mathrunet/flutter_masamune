part of "/masamune_lints.dart";

const _kConvertToOtherButtonPriority = 27;
const _kAddOrRemoveIconPriority = 27;

enum _MaterialButtonType {
  elevated(
    buttonName: "ElevatedButton",
    className: "ElevatedButton",
    priority: _kConvertToOtherButtonPriority,
  ),
  filled(
    buttonName: "FilledButton",
    className: "FilledButton",
    priority: _kConvertToOtherButtonPriority,
  ),
  filledTonal(
    buttonName: "FilledTonalButton",
    className: "FilledButton",
    priority: _kConvertToOtherButtonPriority,
  ),
  outlined(
    buttonName: "OutlinedButton",
    className: "OutlinedButton",
    priority: _kConvertToOtherButtonPriority,
  ),
  text(
    buttonName: "TextButton",
    className: "TextButton",
    priority: _kConvertToOtherButtonPriority,
  );

  const _MaterialButtonType({
    required this.buttonName,
    required this.className,
    required this.priority,
  });
  final String buttonName;
  final String className;
  final int priority;
}

enum _SupportedIdentifier {
  icon,
  tonal,
  tonalIcon;

  bool get isTonal {
    switch (this) {
      case _SupportedIdentifier.icon:
        return false;
      case _SupportedIdentifier.tonal:
        return true;
      case _SupportedIdentifier.tonalIcon:
        return true;
    }
  }

  bool get hasIcon {
    switch (this) {
      case _SupportedIdentifier.icon:
        return true;
      case _SupportedIdentifier.tonal:
        return false;
      case _SupportedIdentifier.tonalIcon:
        return true;
    }
  }
}

bool _isMaterialButtonType(DartType? type) {
  if (type is! InterfaceType) {
    return false;
  }
  final name = type.getDisplayString().split("<").first;
  return _MaterialButtonType.values.any((value) => value.className == name);
}

class _ButtonInvocation {
  const _ButtonInvocation({
    required this.node,
    required this.type,
    required this.className,
    required this.identifier,
    required this.argumentList,
    required this.nameRange,
  });

  final AstNode node;
  final DartType? type;
  final String className;
  final _SupportedIdentifier? identifier;
  final ArgumentList argumentList;
  final SourceRange nameRange;
}

_ButtonInvocation? _buttonInvocation(AstNode selectedNode) {
  final creation = selectedNode is InstanceCreationExpression
      ? selectedNode
      : selectedNode.thisOrAncestorOfType<InstanceCreationExpression>();
  if (creation != null) {
    return _ButtonInvocation(
      node: creation,
      type: creation.constructorName.type.type,
      className: creation.constructorName.type.name.lexeme,
      identifier: creation.constructorName.name?.toSupportedIdentifier(),
      argumentList: creation.argumentList,
      nameRange: SourceRange(
        creation.constructorName.offset,
        creation.constructorName.length,
      ),
    );
  }
  final invocation = selectedNode is MethodInvocation
      ? selectedNode
      : selectedNode.thisOrAncestorOfType<MethodInvocation>();
  if (invocation == null) {
    return null;
  }
  final displayType =
      invocation.staticType?.getDisplayString().split("<").first;
  final className = _MaterialButtonType.values
          .map((value) => value.className)
          .contains(displayType)
      ? displayType!
      : invocation.target == null
          ? invocation.methodName.name
          : invocation.target.toString();
  if (!_MaterialButtonType.values.any(
    (value) => value.className == className,
  )) {
    return null;
  }
  return _ButtonInvocation(
    node: invocation,
    type: invocation.staticType,
    className: className,
    identifier: invocation.target == null
        ? null
        : invocation.methodName.toSupportedIdentifier(),
    argumentList: invocation.argumentList,
    nameRange: SourceRange(
      invocation.offset,
      invocation.argumentList.leftParenthesis.offset - invocation.offset,
    ),
  );
}

extension _SimpleIdentifierExtensions on SimpleIdentifier {
  _SupportedIdentifier? toSupportedIdentifier() {
    switch (name) {
      case "icon":
        return _SupportedIdentifier.icon;
      case "tonal":
        return _SupportedIdentifier.tonal;
      case "tonalIcon":
        return _SupportedIdentifier.tonalIcon;
    }
    return null;
  }
}
