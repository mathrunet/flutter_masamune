part of "/masamune_test.dart";

/// Wrapper for testing widgets (primarily screens) with device constraints.
///
/// デバイスの制約を持つウィジェットをテストするためのラッパー。
class MasamuneTestLoader<T extends ModelRefBase> extends StatefulWidget {
  /// Wrapper for testing widgets (primarily screens) with device constraints.
  ///
  /// デバイスの制約を持つウィジェットをテストするためのラッパー。
  const MasamuneTestLoader({
    required this.ref,
    this.document,
    required this.builder,
    super.key,
  });

  /// The ref of the scenario.
  ///
  /// シナリオのref。
  final MasamuneTestRef ref;

  /// The document of the scenario.
  ///
  /// シナリオのドキュメント。
  final T Function(MasamuneTestRef ref)? document;

  /// The builder of the scenario.
  ///
  /// シナリオのビルダー。
  final Widget Function(BuildContext context, MasamuneTestRef ref, T? document)
      builder;

  @override
  State<StatefulWidget> createState() => _MasamuneTestLoaderState<T>();
}

class _MasamuneTestLoaderState<T extends ModelRefBase>
    extends State<MasamuneTestLoader<T>> {
  T? document;

  @override
  void initState() {
    super.initState();
    document = widget.document?.call(widget.ref);
    document?.load().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.backgroundColor,
      child: widget.builder(context, widget.ref, document),
    );
  }
}
