part of '/masamune_ai.dart';

/// Abstract class of [MasamuneAdapter] for configuring AI functions.
///
/// Inherit this class to set up AI functions.
///
/// AIの機能を設定するための[MasamuneAdapter]の抽象クラス。
///
/// このクラスを継承してAIの機能を設定してください。
abstract class AIMasamuneAdapter extends MasamuneAdapter {
  /// Abstract class of [MasamuneAdapter] for configuring AI functions.
  ///
  /// Inherit this class to set up AI functions.
  ///
  /// AIの機能を設定するための[MasamuneAdapter]の抽象クラス。
  ///
  /// このクラスを継承してAIの機能を設定してください。
  const AIMasamuneAdapter({
    this.defaultConfig = const AIConfig(),
  });

  /// The default configuration of the AI.
  ///
  /// AIのデフォルト設定。
  final AIConfig defaultConfig;

  @override
  FutureOr<void> onPreRunApp() {}

  /// You can retrieve the [AIMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[AIMasamuneAdapter]を取得することができます。
  static AIMasamuneAdapter get primary {
    assert(
      _primary != null,
      "AIMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static AIMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! AIMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<AIMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }

  /// Initialize the AI.
  ///
  /// AIを初期化します。
  Future<void> initialize({
    AIConfig? config,
  });

  /// Generate the content of the AI.
  ///
  /// AIの内容を生成します。
  Future<AIContent?> generateContent(
    List<AIContent> contents, {
    AIConfig? config,
  });
}
