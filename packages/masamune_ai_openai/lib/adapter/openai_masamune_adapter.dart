part of masamune_ai_openai;

/// MasamuneAdapter] for configuring OpenAI features.
///
/// Set the API key issued by your OpenAI account in [apiKey].
///
/// OpenAIの機能を設定するための[MasamuneAdapter]。
///
/// [apiKey]にOpenAIのアカウントで発行したAPIキーを設定してください。
class OpenAIMasamuneAdapter extends MasamuneAdapter {
  /// MasamuneAdapter] for configuring OpenAI features.
  ///
  /// Set the API key issued by your OpenAI account in [apiKey].
  ///
  /// OpenAIの機能を設定するための[MasamuneAdapter]。
  ///
  /// [apiKey]にOpenAIのアカウントで発行したAPIキーを設定してください。
  const OpenAIMasamuneAdapter({
    required this.apiKey,
  });

  /// API key for OpenAI.
  ///
  /// OpenAIのAPIキー。
  final String apiKey;

  @override
  FutureOr<void> onPreRunApp() {
    OpenAI.apiKey = apiKey;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<OpenAIMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
