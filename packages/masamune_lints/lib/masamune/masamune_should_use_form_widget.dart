part of '/masamune_lints.dart';

class _MasamuneShouldUseFormWidget extends DartLintRule {
  const _MasamuneShouldUseFormWidget()
      : super(
          code: _code,
        );

  static const _code = lint_codes.LintCode(
    name: "masamune_should_use_form_widget",
    problemMessage:
        """Masamuneフレームワークでは各種FormWidgetに対してKatanaFormを利用することを推奨しています。
下記の変換を行ってください。

- TextField -> FormTextField
- TextFormField -> FormTextField
- DropdownButton -> FormMapDropdownField
- DropdownButtonFormField -> FormMapDropdownField
- Checkbox -> FormCheckbox
- Switch -> FormSwitch
- Slider -> FormSlider
""",
    errorSeverity: ErrorSeverity.WARNING,
  );

  static const Map<String, String> _widgetSuggestions = {
    "TextField": "FormTextField",
    "TextFormField": "FormTextField",
    "DropdownButton": "FormMapDropdownField",
    "DropdownButtonFormField": "FormMapDropdownField",
    "Checkbox": "FormCheckbox",
    "Switch": "FormSwitch",
    "Slider": "FormSlider",
  };

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final constructorName = node.constructorName;
      final typeName = constructorName.type.name2.lexeme;

      if (_widgetSuggestions.containsKey(typeName)) {
        final suggestedWidget = _widgetSuggestions[typeName]!;

        final customCode = lint_codes.LintCode(
          name: "masamune_should_use_form_widget",
          problemMessage:
              "Consider using $suggestedWidget instead of $typeName. $suggestedWidgetはUniversalUIの一部でより多くの機能を提供します。",
          errorSeverity: ErrorSeverity.WARNING,
        );

        reporter.atNode(node, customCode);
      }
    });
  }
}
