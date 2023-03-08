part of masamune_ai_openai;

class OpenAIMasamuneAdapter extends MasamuneAdapter {
  const OpenAIMasamuneAdapter({
    required this.apiKey,
  });

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
