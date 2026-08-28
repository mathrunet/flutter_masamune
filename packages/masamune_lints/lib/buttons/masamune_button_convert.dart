part of "/masamune_lints.dart";

class _MasamuneButtonConvert extends ResolvedCorrectionProducer {
  static const _assistKind = AssistKind(
    "masamune_lints.assist.convert_button",
    _kConvertToOtherButtonPriority,
    "Convert to {0}",
  );

  _MasamuneButtonConvert({required super.context, required this.targetType});
  final _MaterialButtonType targetType;

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  List<String> get assistArguments => [targetType.buttonName];

  @override
  AssistKind get assistKind => _assistKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final creation = _buttonInvocation(node);
    if (creation == null || !_isMaterialButtonType(creation.type)) {
      return;
    }
    final identifier = creation.identifier;
    final currentClass = creation.className;
    final currentIsTonal = identifier?.isTonal ?? false;
    if (currentClass == targetType.className &&
        ((targetType == _MaterialButtonType.filledTonal && currentIsTonal) ||
            (targetType == _MaterialButtonType.filled && !currentIsTonal))) {
      return;
    }
    if (currentClass == targetType.className &&
        targetType != _MaterialButtonType.filled &&
        targetType != _MaterialButtonType.filledTonal) {
      return;
    }
    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(
        creation.nameRange,
        targetType.className +
            _getReplacementIdentifier(identifier, targetType),
      );
    });
  }

  String _getReplacementIdentifier(
    _SupportedIdentifier? identifier,
    _MaterialButtonType targetType,
  ) {
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
