part of "/masamune_test.dart";

/// Wrapper for testing widgets (primarily screens) with device constraints.
///
/// デバイスの制約を持つウィジェットをテストするためのラッパー。
class MasamuneTestLoader<T> extends StatefulWidget {
  /// Wrapper for testing widgets (primarily screens) with device constraints.
  ///
  /// デバイスの制約を持つウィジェットをテストするためのラッパー。
  const MasamuneTestLoader({
    required this.ref,
    required this.builder,
    this.onLoad,
    super.key,
  });

  /// The ref of the scenario.
  ///
  /// シナリオのref。
  final MasamuneTestRef ref;

  /// The document of the scenario.
  ///
  /// シナリオのドキュメント。
  final FutureOr<T?> Function(BuildContext context, MasamuneTestRef ref)?
      onLoad;

  /// The builder of the scenario.
  ///
  /// シナリオのビルダー。
  final Widget Function(BuildContext context, MasamuneTestRef ref, T? value)
      builder;

  @override
  State<StatefulWidget> createState() => _MasamuneTestLoaderState<T>();
}

class _MasamuneTestLoaderState<T> extends State<MasamuneTestLoader<T>> {
  T? value;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final newValue = await widget.onLoad?.call(context, widget.ref);
    setState(() {
      _isLoaded = true;
      value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_isLoaded || widget.onLoad == null) {
      return _MasamuneTestLoaded(
        child: Material(
          color: theme.backgroundColor,
          child: widget.builder(context, widget.ref, value),
        ),
      );
    }
    return Material(
      color: theme.backgroundColor,
      child: widget.builder(context, widget.ref, value),
    );
  }
}

class _MasamuneTestLoaded extends StatelessWidget {
  const _MasamuneTestLoaded({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
