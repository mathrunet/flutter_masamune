part of '/masamune_module.dart';

/// [MasamuneAdapter] for creating module plug-ins for your application.
///
/// In addition to the normal modules listed below, [theme] and [localize] can be specified.
///
/// アプリケーションのモジュールプラグインを作成するための[MasamuneAdapter]。
///
/// 下記の通常のモジュールに加えて、[theme]と[localize]を指定することができます。
///
/// {@macro module_masamune_adapter}
@immutable
abstract class AppModuleMasamuneAdapter<TPages extends ModulePages,
        TOptions extends ModuleOptions>
    extends ModuleMasamuneAdapter<TPages, TOptions> {
  /// [MasamuneAdapter] for creating module plug-ins for your application.
  ///
  /// In addition to the normal modules listed below, [theme] and [localize] can be specified.
  ///
  /// アプリケーションのモジュールプラグインを作成するための[MasamuneAdapter]。
  ///
  /// 下記の通常のモジュールに加えて、[theme]と[localize]を指定することができます。
  ///
  /// {@macro module_masamune_adapter}
  const AppModuleMasamuneAdapter({
    required super.option,
    required super.page,
    super.appRef,
    super.router,
    super.function,
    super.auth,
    this.title,
    AppThemeData? theme,
    AppLocalizeBase? localize,
  })  : _localize = localize,
        _theme = theme;

  /// App Name.
  ///
  /// アプリ名。
  final LocalizedValue<String>? title;

  /// Translation config used by `katana_localization`.
  ///
  /// `katana_localization`で利用される翻訳のコンフィグ。
  AppLocalizeBase get localize {
    assert(
      _router != null,
      "[AppLocalizeBase] is not given. Please specify [localize] when creating [ModuleMasamuneAdapter].",
    );
    return _localize!;
  }

  final AppLocalizeBase? _localize;

  /// Theme config used by `katana_theme`.
  ///
  /// `katana_theme`で利用されるテーマのコンフィグ。
  AppThemeData get theme {
    assert(
      _router != null,
      "[AppThemeData] is not given. Please specify [theme] when creating [ModuleMasamuneAdapter].",
    );
    return _theme!;
  }

  final AppThemeData? _theme;

  /// Locale of the application.
  ///
  /// アプリのロケール。
  Locale get locale => localize.locale;
}
