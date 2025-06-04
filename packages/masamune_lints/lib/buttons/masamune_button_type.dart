part of "/masamune_lints.dart";

const _kConvertToOtherButtonPriority = 27;
const _kAddOrRemoveIconPriority = 27;

enum _MaterialButtonType {
  elevated(
    buttonName: "ElevatedButton",
    className: "ElevatedButton",
    priority: _kConvertToOtherButtonPriority,
    typeChecker: TypeChecker.fromName(
      "ElevatedButton",
      packageName: "flutter",
    ),
  ),
  filled(
    buttonName: "FilledButton",
    className: "FilledButton",
    priority: _kConvertToOtherButtonPriority,
    typeChecker: TypeChecker.fromName(
      "FilledButton",
      packageName: "flutter",
    ),
  ),
  filledTonal(
    buttonName: "FilledTonalButton",
    className: "FilledButton",
    priority: _kConvertToOtherButtonPriority,
    typeChecker: TypeChecker.fromName(
      "FilledButton",
      packageName: "flutter",
    ),
  ),
  outlined(
    buttonName: "OutlinedButton",
    className: "OutlinedButton",
    priority: _kConvertToOtherButtonPriority,
    typeChecker: TypeChecker.fromName(
      "OutlinedButton",
      packageName: "flutter",
    ),
  ),
  text(
    buttonName: "TextButton",
    className: "TextButton",
    priority: _kConvertToOtherButtonPriority,
    typeChecker: TypeChecker.fromName(
      "TextButton",
      packageName: "flutter",
    ),
  );

  const _MaterialButtonType({
    required this.buttonName,
    required this.className,
    required this.priority,
    required this.typeChecker,
  });
  final String buttonName;
  final String className;
  final int priority;
  final TypeChecker typeChecker;

  TypeChecker getBaseType() {
    return TypeChecker.any(
      _MaterialButtonType.values
          .where((e) => e != this)
          .map((e) => e.typeChecker),
    );
  }
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
