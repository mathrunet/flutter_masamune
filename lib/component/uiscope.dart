part of masamune;

/// You can load the model in the bottom widget
/// while constraining the rebuild location.
///
/// It is the same as [Counsumer] of riverpod.
class UIScope extends ConsumerWidget {
  /// You can load the model in the bottom widget
  /// while constraining the rebuild location.
  ///
  /// It is the same as [Counsumer] of riverpod.
  ///
  /// Specify a callback to build in [builder].
  const UIScope({
    Key key,
    @required ConsumerBuilder builder,
    Widget child,
  })  : _child = child,
        _builder = builder,
        assert(builder != null, "the parameter builder cannot be null"),
        super(key: key);

  final ConsumerBuilder _builder;
  final Widget _child;

  /// Build widget.
  ///
  /// [context]: Build context.
  /// [watch]: You can load a model from here.
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return _builder(context, watch, _child);
  }
}
