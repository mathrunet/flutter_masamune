part of "/masamune_experiment.dart";

/// [MasamuneAdapter] for running A/B tests and feature switches with [Experiment].
///
/// Values are loaded through [modelAdapter] as a document.
/// By default, [FirebaseRemoteConfigModelAdapter] is used, so pass [FirebaseOptions] or a [FirebaseRemoteConfig] instance to it.
///
/// [defaults] are the values used before loading. If not specified, [FirebaseRemoteConfigModelAdapter.initialValue] is used.
///
/// [overrides] always take precedence over loaded values. Use them to fix a specific branch for debugging and testing.
/// Do not pass [overrides] in production flavors.
///
/// [Experiment]でA/Bテストや機能の切り替えを行うための[MasamuneAdapter]。
///
/// 値は[modelAdapter]を通してドキュメントとして読み込まれます。
/// デフォルトでは[FirebaseRemoteConfigModelAdapter]が利用されるため、そちらに[FirebaseOptions]や[FirebaseRemoteConfig]のインスタンスを渡してください。
///
/// [defaults]は読み込み前に利用される値です。指定されない場合は[FirebaseRemoteConfigModelAdapter.initialValue]が利用されます。
///
/// [overrides]は読み込んだ値よりも常に優先されます。デバッグやテストで特定の分岐を固定するために利用してください。
/// 本番用のFlavorでは[overrides]を渡さないでください。
///
/// ```dart
/// ExperimentMasamuneAdapter(
///   modelAdapter: FirebaseRemoteConfigModelAdapter(
///     options: DefaultFirebaseOptions.currentPlatform,
///     initialValue: {"new_button": "control"},
///   ),
/// );
/// ```
class ExperimentMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for running A/B tests and feature switches with [Experiment].
  ///
  /// Values are loaded through [modelAdapter] as a document.
  /// By default, [FirebaseRemoteConfigModelAdapter] is used, so pass [FirebaseOptions] or a [FirebaseRemoteConfig] instance to it.
  ///
  /// [defaults] are the values used before loading. If not specified, [FirebaseRemoteConfigModelAdapter.initialValue] is used.
  ///
  /// [overrides] always take precedence over loaded values. Use them to fix a specific branch for debugging and testing.
  /// Do not pass [overrides] in production flavors.
  ///
  /// [Experiment]でA/Bテストや機能の切り替えを行うための[MasamuneAdapter]。
  ///
  /// 値は[modelAdapter]を通してドキュメントとして読み込まれます。
  /// デフォルトでは[FirebaseRemoteConfigModelAdapter]が利用されるため、そちらに[FirebaseOptions]や[FirebaseRemoteConfig]のインスタンスを渡してください。
  ///
  /// [defaults]は読み込み前に利用される値です。指定されない場合は[FirebaseRemoteConfigModelAdapter.initialValue]が利用されます。
  ///
  /// [overrides]は読み込んだ値よりも常に優先されます。デバッグやテストで特定の分岐を固定するために利用してください。
  /// 本番用のFlavorでは[overrides]を渡さないでください。
  const ExperimentMasamuneAdapter({
    this.modelAdapter = const FirebaseRemoteConfigModelAdapter(),
    Map<String, Object?>? defaults,
    this.overrides = const {},
  }) : _defaults = defaults;

  /// [ExperimentMasamuneAdapter] for testing.
  ///
  /// [values] are used as both the loaded values and the values before loading.
  /// [overrides] always take precedence over [values].
  ///
  /// Firebase is not used, so it can be used in unit tests and widget tests.
  ///
  /// テスト用の[ExperimentMasamuneAdapter]。
  ///
  /// [values]は読み込まれる値と読み込み前の値の両方に利用されます。
  /// [overrides]は[values]よりも常に優先されます。
  ///
  /// Firebaseを利用しないため、単体テストやウィジェットテストで利用できます。
  factory ExperimentMasamuneAdapter.test({
    Map<String, Object?> values = const {},
    Map<String, Object?> overrides = const {},
  }) {
    return ExperimentMasamuneAdapter(
      modelAdapter: RuntimeModelAdapter(
        database: NoSqlDatabase(),
        initialValue: [
          DynamicModelInitialDocument(documentPath, values),
        ],
      ),
      defaults: values,
      overrides: overrides,
    );
  }

  /// Path of the document used to load values.
  ///
  /// [FirebaseRemoteConfigModelAdapter] ignores the path.
  ///
  /// 値を読み込むためのドキュメントのパス。
  ///
  /// [FirebaseRemoteConfigModelAdapter]はパスを無視します。
  static const String documentPath = "app/experiment";

  /// [ModelAdapter] to load values.
  ///
  /// 値を読み込むための[ModelAdapter]。
  final ModelAdapter modelAdapter;

  /// Values that always take precedence over loaded values.
  ///
  /// Use them to fix a specific branch for debugging and testing.
  ///
  /// 読み込んだ値よりも常に優先される値。
  ///
  /// デバッグやテストで特定の分岐を固定するために利用します。
  final Map<String, Object?> overrides;

  /// Values used before loading.
  ///
  /// If not specified in the constructor, [FirebaseRemoteConfigModelAdapter.initialValue] is used.
  ///
  /// 読み込み前に利用される値。
  ///
  /// コンストラクタで指定されない場合は[FirebaseRemoteConfigModelAdapter.initialValue]が利用されます。
  Map<String, Object?> get defaults {
    final defaults = _defaults;
    if (defaults != null) {
      return defaults;
    }
    final adapter = modelAdapter;
    if (adapter is FirebaseRemoteConfigModelAdapter) {
      return adapter.initialValue ?? const {};
    }
    return const {};
  }

  final Map<String, Object?>? _defaults;

  /// You can retrieve the [ExperimentMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[ExperimentMasamuneAdapter]を取得することができます。
  static ExperimentMasamuneAdapter get primary {
    assert(
      _primary != null,
      "ExperimentMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static ExperimentMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! ExperimentMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<ExperimentMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
