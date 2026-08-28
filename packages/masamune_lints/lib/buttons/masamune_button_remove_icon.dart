part of "/masamune_lints.dart";

class _MasamuneButtonRemoveIcon extends ResolvedCorrectionProducer {
  static const _assistKind = AssistKind(
    "masamune_lints.assist.remove_button_icon",
    _kAddOrRemoveIconPriority,
    "Remove icon from button",
  );

  _MasamuneButtonRemoveIcon({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  AssistKind get assistKind => _assistKind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final creation = _buttonInvocation(node);
    if (creation == null || !_isMaterialButtonType(creation.type)) {
      return;
    }
    final identifier = creation.identifier;
    if (!(identifier?.hasIcon ?? false)) {
      return;
    }
    await builder.addDartFileEdit(file, (builder) {
      if (identifier == _SupportedIdentifier.tonalIcon) {
        builder.addSimpleReplacement(creation.nameRange, "FilledButton.tonal");
      } else {
        builder.addSimpleReplacement(creation.nameRange, creation.className);
      }
      for (final argument in creation.argumentList.arguments) {
        final name = _namedArgumentName(argument);
        final nameRange = _namedArgumentNameRange(argument);
        if (name == "label" && nameRange != null) {
          builder.addSimpleReplacement(nameRange, "child");
        } else if (name == "icon") {
          builder.addDeletion(
            range.nodeInList(creation.argumentList.arguments, argument),
          );
        }
      }
    });
  }
}
