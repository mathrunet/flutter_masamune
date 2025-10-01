part of "/masamune_markdown.dart";

/// Controller for [FormMarkdownField].
///
/// By passing this, you can integrate with [FormMarkdownToolbar] tools.
///
/// Also, you can control multiple [FormMarkdownField] instances with a single [FormMarkdownToolbar] tool.
///
/// [FormMarkdownField]用のコントローラー。
///
/// これを渡すことで[FormMarkdownToolbar]のツールと連携することができます。
///
/// また、複数の[FormMarkdownField]を一つの[FormMarkdownToolbar]のツールでコントロールすることができます。
class MarkdownController2 extends MasamuneControllerBase<List<TextEditingValue>,
    MarkdownMasamuneAdapter> {
  /// Controller for [FormMarkdownField].
  ///
  /// By passing this, you can integrate with [FormMarkdownToolbar] tools.
  ///
  /// Also, you can control multiple [FormMarkdownField] instances with a single [FormMarkdownToolbar] tool.
  ///
  /// [FormMarkdownField]用のコントローラー。
  ///
  /// これを渡すことで[FormMarkdownToolbar]のツールと連携することができます。
  ///
  /// また、複数の[FormMarkdownField]を一つの[FormMarkdownToolbar]のツールでコントロールすることができます。
  MarkdownController2({super.adapter});

  /// Query for MarkdownController.
  ///
  /// ```dart
  /// appRef.controller(MarkdownController.query(parameters));     // Get from application scope.
  /// ref.app.controller(MarkdownController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(MarkdownController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$MarkdownController2Query();

  @override
  MarkdownMasamuneAdapter get primaryAdapter => MarkdownMasamuneAdapter.primary;

  @override
  List<TextEditingValue>? get value => [];
}

@immutable
class _$MarkdownController2Query {
  const _$MarkdownController2Query();

  @useResult
  _$_MarkdownController2Query call({MarkdownMasamuneAdapter? adapter}) =>
      _$_MarkdownController2Query(
        hashCode.toString(),
        adapter: adapter,
      );
}

@immutable
class _$_MarkdownController2Query
    extends ControllerQueryBase<MarkdownController> {
  const _$_MarkdownController2Query(this._name, {this.adapter});

  final String _name;

  final MarkdownMasamuneAdapter? adapter;

  @override
  MarkdownController Function() call(Ref ref) {
    return () => MarkdownController(adapter: adapter);
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
