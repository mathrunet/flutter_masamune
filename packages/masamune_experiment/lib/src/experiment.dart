part of "/masamune_experiment.dart";

/// Controller for A/B tests and feature switches.
///
/// Load the values in advance with [load], then define all branches in [run].
/// When loading is complete, the listeners are notified and the screen is updated.
///
/// A/Bテストや機能の切り替えを行うためのコントローラー。
///
/// [load]で事前に値を読み込み、[run]の中にすべての分岐を定義します。
/// 読み込みが完了するとリスナーに通知され、画面が更新されます。
///
/// ```dart
/// final experiment = ref.app.controller(Experiment.query())..load();
/// final button = experiment.run(
///   (config) => config.getString("new_button"),
///   [
///     ExperimentCase.equals("treatment", label: "treatment", run: () => const NewButton()),
///     ExperimentCase.otherwise(label: "control", run: () => const OldButton()),
///   ],
/// );
/// ```
class Experiment
    extends MasamuneControllerBase<void, ExperimentMasamuneAdapter> {
  /// Controller for A/B tests and feature switches.
  ///
  /// Load the values in advance with [load], then define all branches in [run].
  /// When loading is complete, the listeners are notified and the screen is updated.
  ///
  /// A/Bテストや機能の切り替えを行うためのコントローラー。
  ///
  /// [load]で事前に値を読み込み、[run]の中にすべての分岐を定義します。
  /// 読み込みが完了するとリスナーに通知され、画面が更新されます。
  Experiment({super.adapter});

  /// Query for Experiment.
  ///
  /// ```dart
  /// appRef.controller(Experiment.query());     // Get from application scope.
  /// ref.app.controller(Experiment.query());    // Watch at application scope.
  /// ref.page.controller(Experiment.query());   // Watch at page scope.
  /// ```
  static const query = _$ExperimentQuery();

  /// Maximum number of labels kept in [selectedLabels].
  ///
  /// [selectedLabels]に保持するラベルの最大数。
  static const int maxSelectedLabels = 100;

  @override
  ExperimentMasamuneAdapter get primaryAdapter =>
      ExperimentMasamuneAdapter.primary;

  _ExperimentDocument get _document {
    return __document ??= _ExperimentDocument(
      DocumentModelQuery(
        ExperimentMasamuneAdapter.documentPath,
        adapter: adapter.modelAdapter,
      ),
    );
  }

  _ExperimentDocument? __document;

  /// Returns `true` if the values have been loaded.
  ///
  /// 値が読み込まれている場合`true`を返します。
  bool get loaded => _loaded;
  bool _loaded = false;

  /// Returns [Future] while loading. Returns [Null] otherwise.
  ///
  /// 読み込み中は[Future]を返します。それ以外は[Null]を返します。
  Future<void>? get loading => _loadCompleter?.future;
  Completer<void>? _loadCompleter;

  /// Current values.
  ///
  /// [ExperimentMasamuneAdapter.defaults], the loaded values and [ExperimentMasamuneAdapter.overrides] are merged in this order.
  ///
  /// 現在の値。
  ///
  /// [ExperimentMasamuneAdapter.defaults]、読み込んだ値、[ExperimentMasamuneAdapter.overrides]の順に統合されます。
  ExperimentConfig get config {
    return ExperimentConfig({
      ...adapter.defaults,
      ...?_document.value,
      ...adapter.overrides,
    });
  }

  /// Labels selected by [run], in the order of selection.
  ///
  /// Use this to verify which branch was executed in tests. Up to [maxSelectedLabels] labels are kept.
  ///
  /// [run]で選ばれたラベルを選ばれた順に返します。
  ///
  /// テストでどの分岐が実行されたかを検証するために利用します。最大[maxSelectedLabels]件まで保持されます。
  List<String> get selectedLabels => List.unmodifiable(_selectedLabels);
  final List<String> _selectedLabels = [];

  /// Clear [selectedLabels].
  ///
  /// [selectedLabels]をクリアします。
  void clearSelectedLabels() {
    _selectedLabels.clear();
  }

  /// Load the values.
  ///
  /// Loading is performed only once. Use [reload] to load again.
  ///
  /// When loading is complete, the listeners are notified.
  ///
  /// 値を読み込みます。
  ///
  /// 読み込みは一度だけ行われます。再度読み込む場合は[reload]を利用してください。
  ///
  /// 読み込みが完了するとリスナーに通知されます。
  Future<void> load() async {
    if (_loaded) {
      return;
    }
    if (_loadCompleter != null) {
      return loading;
    }
    await _load(_document.load);
  }

  /// Reload the values.
  ///
  /// When loading is complete, the listeners are notified.
  ///
  /// 値を再読み込みします。
  ///
  /// 読み込みが完了するとリスナーに通知されます。
  Future<void> reload() async {
    if (_loadCompleter != null) {
      await loading;
    }
    await _load(_document.reload);
  }

  Future<void> _load(Future<DynamicMap?> Function() callback) async {
    final completer = _loadCompleter = Completer<void>();
    // Observe the shared future even when only the calling operation is awaited.
    completer.future.ignore();
    try {
      await callback();
      _loaded = true;
      completer.complete();
      notifyListeners();
    } catch (e, stackTrace) {
      completer.completeError(e, stackTrace);
      rethrow;
    } finally {
      if (_loadCompleter == completer) {
        _loadCompleter = null;
      }
    }
  }

  /// Execute the branch that matches the current values.
  ///
  /// [value] receives [config] and returns the value used for the conditions.
  /// It is evaluated only once.
  ///
  /// [cases] are evaluated from the top. The [ExperimentCase.run] of the first [ExperimentCase] whose [ExperimentCase.when] returns `true` is executed,
  /// and the subsequent [ExperimentCase]s are not evaluated. The return value of [ExperimentCase.run] is returned.
  /// If no [ExperimentCase] matches, [Null] is returned.
  ///
  /// If [fixed] is specified, the [ExperimentCase] with the same [ExperimentCase.label] is always executed regardless of the conditions.
  /// Use this to fix the winner after the A/B test is finished.
  ///
  /// This method is synchronous. If [ExperimentCase.run] returns a [Future], the return value is a [Future].
  /// It can be used before loading. In that case, [ExperimentMasamuneAdapter.defaults] are used.
  ///
  /// If the return types of [cases] differ, specify the type arguments explicitly, such as `run<String, Widget>(...)`.
  ///
  /// 現在の値に一致する分岐を実行します。
  ///
  /// [value]は[config]を受け取り、条件に利用する値を返します。
  /// 一度だけ評価されます。
  ///
  /// [cases]は上から評価され、[ExperimentCase.when]が最初に`true`を返した[ExperimentCase]の[ExperimentCase.run]が実行され、
  /// 以降の[ExperimentCase]は評価されません。[ExperimentCase.run]の戻り値が返されます。
  /// どの[ExperimentCase]にも一致しなかった場合は[Null]が返されます。
  ///
  /// [fixed]を指定すると、同じ[ExperimentCase.label]を持つ[ExperimentCase]が条件に関係なく必ず実行されます。
  /// A/Bテスト終了後に勝者を固定するために利用してください。
  ///
  /// このメソッドは同期的に実行されます。[ExperimentCase.run]が[Future]を返す場合は戻り値が[Future]になります。
  /// 読み込み前でも利用できます。その場合は[ExperimentMasamuneAdapter.defaults]が利用されます。
  ///
  /// [cases]の戻り値の型が異なる場合は`run<String, Widget>(...)`のように型引数を明示してください。
  TResult? run<TValue, TResult>(
    TValue Function(ExperimentConfig config) value,
    List<ExperimentCase<TValue, TResult>> cases, {
    String? fixed,
  }) {
    assert(
      cases.map((e) => e.label).toSet().length == cases.length,
      "The labels of ExperimentCase must be unique: ${cases.map((e) => e.label).join(", ")}",
    );
    if (fixed != null) {
      for (final experimentCase in cases) {
        if (experimentCase.label == fixed) {
          _select(experimentCase.label);
          return experimentCase._run();
        }
      }
      assert(
        false,
        "The fixed label [$fixed] is not found in: ${cases.map((e) => e.label).join(", ")}",
      );
    }
    final current = value(config);
    for (final experimentCase in cases) {
      if (experimentCase._matches(current)) {
        _select(experimentCase.label);
        return experimentCase._run();
      }
    }
    return null;
  }

  void _select(String label) {
    _selectedLabels.add(label);
    if (_selectedLabels.length > maxSelectedLabels) {
      _selectedLabels.removeAt(0);
    }
  }

  @override
  void dispose() {
    __document?.dispose();
    super.dispose();
  }
}

@immutable
class _$ExperimentQuery {
  const _$ExperimentQuery();

  @useResult
  _$_ExperimentQuery call() => _$_ExperimentQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_ExperimentQuery extends ControllerQueryBase<Experiment> {
  const _$_ExperimentQuery(
    this._name,
  );

  final String _name;

  @override
  Experiment Function() call(Ref ref) => Experiment.new;

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
