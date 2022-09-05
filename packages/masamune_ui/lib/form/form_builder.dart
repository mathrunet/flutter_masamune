part of masamune_ui.form;

class FormBuilder extends StatelessWidget {
  const FormBuilder({
    required GlobalKey<FormState> key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    this.type = FormBuilderType.listView,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.alwaysShowScrollbar = false,
  }) : _key = key;

  final GlobalKey<FormState> _key;
  final List<Widget> children;
  final FormBuilderType type;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;
  final bool alwaysShowScrollbar;

  @override
  Widget build(BuildContext context) {
    return Form(key: _key, child: _buildInternal(context));
  }

  Widget _buildInternal(BuildContext context) {
    switch (type) {
      case FormBuilderType.fixed:
        return Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          ),
        );
      case FormBuilderType.center:
        return ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: crossAxisAlignment,
                  children: children,
                ),
              ),
            ),
          ),
        );
      default:
        if (alwaysShowScrollbar || !Config.isMobile) {
          return Scrollbar(
            child: _scollView(context),
            thumbVisibility: true,
          );
        } else {
          return _scollView(context);
        }
    }
  }

  Widget _scollView(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}

enum FormBuilderType { listView, center, fixed }
