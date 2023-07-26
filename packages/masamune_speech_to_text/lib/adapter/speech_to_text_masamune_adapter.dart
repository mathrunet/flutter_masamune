part of masamune_speech_to_text;

/// [MasamuneAdapter], which is the initial setup for handling Speech-to-Text.
///
/// Speech-to-Textを取り扱うための初期設定を行う[MasamuneAdapter]。
class SpeechToTextMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter], which is the initial setup for handling Speech-to-Text.
  ///
  /// Speech-to-Textを取り扱うための初期設定を行う[MasamuneAdapter]。
  const SpeechToTextMasamuneAdapter({
    required this.defaultLocale,
  });

  /// Default language.
  ///
  /// デフォルトの言語。
  final Locale defaultLocale;

  /// You can retrieve the [SttMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[SttMasamuneAdapter]を取得することができます。
  static SpeechToTextMasamuneAdapter get primary {
    assert(
      _primary != null,
      "SpeechToTextMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static SpeechToTextMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! SpeechToTextMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<SpeechToTextMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
