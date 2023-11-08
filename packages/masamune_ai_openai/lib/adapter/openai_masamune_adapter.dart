part of '/masamune_ai_openai.dart';

/// [MasamuneAdapter] for configuring OpenAI features.
///
/// Set the API key issued by your OpenAI account in [apiKey].
///
/// OpenAIの機能を設定するための[MasamuneAdapter]。
///
/// [apiKey]にOpenAIのアカウントで発行したAPIキーを設定してください。
class OpenAIMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for configuring OpenAI features.
  ///
  /// Set the API key issued by your OpenAI account in [apiKey].
  ///
  /// OpenAIの機能を設定するための[MasamuneAdapter]。
  ///
  /// [apiKey]にOpenAIのアカウントで発行したAPIキーを設定してください。
  const OpenAIMasamuneAdapter({
    required this.apiKey,
    this.defaultChatPromptBuilder,
  });

  /// API key for OpenAI.
  ///
  /// OpenAIのAPIキー。
  final String apiKey;

  /// Specifies the default prompt builder.
  ///
  /// The value specified in this class takes precedence over the value set in these.
  ///
  /// デフォルトプロンプトビルダーを指定します。
  ///
  /// これらで設定された値よりもこのクラスで指定された値のほうが優先されます。
  final OpenAIChatPromptBuilder? defaultChatPromptBuilder;

  @override
  FutureOr<void> onPreRunApp() {
    OpenAI.apiKey = apiKey;
  }

  /// You can retrieve the [OpenAIMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[OpenAIMasamuneAdapter]を取得することができます。
  static OpenAIMasamuneAdapter get primary {
    assert(
      _primary != null,
      "OpenAIMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static OpenAIMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! OpenAIMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<OpenAIMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
