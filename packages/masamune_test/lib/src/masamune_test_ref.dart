part of "/masamune_test.dart";

/// Masamune Test References.
///
/// Masamune Testの各種参照。
class MasamuneTestRef {
  const MasamuneTestRef._({
    required this.appAuth,
    required this.appRef,
    required this.modelAdapter,
    required this.storageAdapter,
    required this.functionsAdapter,
    required this.loggerAdapters,
    required this.authAdapter,
    required this.theme,
    required this.masamuneAdapters,
    required this.platformInfoAdapter,
    this.localizationsDelegates,
  });

  /// The app reference.
  ///
  /// アプリの参照。
  final AppRef appRef;

  /// The app auth.
  ///
  /// アプリの認証。
  final Authentication? appAuth;

  /// The localizations delegates.
  ///
  /// ローカライゼーションデリゲート。
  final List<LocalizationsDelegate>? localizationsDelegates;

  /// The masamune adapters.
  ///
  /// Masamuneアダプタ。
  final List<MasamuneAdapter> masamuneAdapters;

  /// The theme.
  ///
  /// テーマ。
  final AppThemeData theme;

  /// The model adapter.
  ///
  /// モデルアダプタ。
  final RuntimeModelAdapter modelAdapter;

  /// The storage adapter.
  ///
  /// ストレージアダプタ。
  final RuntimeStorageAdapter storageAdapter;

  /// The functions adapter.
  ///
  /// 関数アダプタ。
  final RuntimeFunctionsAdapter functionsAdapter;

  /// The logger adapters.
  ///
  /// ロガーアダプタ。
  final List<RuntimeLoggerAdapter> loggerAdapters;

  /// The auth adapter.
  ///
  /// 認証アダプタ。
  final RuntimeAuthAdapter authAdapter;

  /// The platform info adapter.
  ///
  /// プラットフォーム情報アダプタ。
  final RuntimePlatformInfoAdapter platformInfoAdapter;
}
