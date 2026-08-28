part of "/masamune_lints.dart";

class _MasamuneButtonAddIcon extends ResolvedCorrectionProducer {
  static const _assistKind = AssistKind(
    "masamune_lints.assist.add_button_icon",
    _kAddOrRemoveIconPriority,
    "Add icon to button",
  );

  _MasamuneButtonAddIcon({required super.context});

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
    if (identifier?.hasIcon ?? false) {
      return;
    }
    await builder.addDartFileEdit(file, (builder) {
      if (identifier == _SupportedIdentifier.tonal) {
        builder.addSimpleReplacement(
          creation.nameRange,
          "FilledButton.tonalIcon",
        );
      } else {
        builder.addSimpleInsertion(creation.nameRange.end, ".icon");
      }
      var hasIcon = false;
      for (final argument in creation.argumentList.arguments) {
        final name = _namedArgumentName(argument);
        final nameRange = _namedArgumentNameRange(argument);
        if (name == "child" && nameRange != null) {
          builder.addSimpleReplacement(nameRange, "label");
        } else if (name == "icon") {
          hasIcon = true;
        }
      }
      if (!hasIcon) {
        final arguments = creation.argumentList.arguments;
        final insertionOffset = arguments.isEmpty
            ? creation.argumentList.leftParenthesis.end
            : arguments.last.end;
        builder.addSimpleInsertion(
          insertionOffset,
          arguments.isEmpty
              ? "icon: const Icon(Icons.add), label: const SizedBox.shrink()"
              : ", icon: const Icon(Icons.add)",
        );
      }
    });
  }
}
