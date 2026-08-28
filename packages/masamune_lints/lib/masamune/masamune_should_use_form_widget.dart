part of "/masamune_lints.dart";

class _MasamuneShouldUseFormWidget extends _MasamuneAnalysisRule {
  _MasamuneShouldUseFormWidget() : super(code);

  static const code = LintCode(
    "masamune_should_use_form_widget",
    "Consider using {0} instead of {1}. {0}はKatanaFormの一部でより多くの機能を提供します。",
    severity: DiagnosticSeverity.WARNING,
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
  void run(_MasamuneRuleContext context) {
    context.registry.addInstanceCreationExpression((node) {
      final constructorName = node.constructorName;
      final typeName = constructorName.type.name.lexeme;

      if (_widgetSuggestions.containsKey(typeName)) {
        final suggestedWidget = _widgetSuggestions[typeName]!;

        reportAtNode(node, arguments: [suggestedWidget, typeName]);
      }
    });
    context.registry.addMethodInvocation((node) {
      if (node.target != null || node.staticType is! InterfaceType) {
        return;
      }
      final typeName = node.staticType!.getDisplayString().split("<").first;
      final suggestedWidget = _widgetSuggestions[typeName];
      if (suggestedWidget != null) {
        reportAtNode(node, arguments: [suggestedWidget, typeName]);
      }
    });
  }
}
