part of masamune.form;

class FormBuilder extends StatelessWidget {
  const FormBuilder({
    required GlobalKey<FormState> key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    this.type = FormBuilderType.listView,
  }) : _key = key;

  final GlobalKey<FormState> _key;
  final List<Widget> children;
  final FormBuilderType type;
  final EdgeInsetsGeometry padding;

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
          ),
        );
      default:
        return SingleChildScrollView(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        );
    }
  }
}

enum FormBuilderType { listView, center, fixed }
