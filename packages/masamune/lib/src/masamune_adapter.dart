part of masamune;

/// Adapter for easily adding functions to Masamune Framework.
///
/// Setting [runZonedGuarded] to `true` allows wrapping [runApp] with [runZonedGuarded].
/// At that time, [onPreRunApp] can be used to execute the process before [runApp], and [onError] can be used to describe the process in case of an error.
///
/// You can set up observers to monitor transitions between pages at [navigatorObservers].
///
/// Widgets can be added during the build of [MasamuneApp] with [onBuildApp].
///
/// Masamune Frameworkに機能を手軽に追加するためのアダプター。
///
/// アプリ起動時と[MasamuneApp]に渡す処理を記述することができます。
///
/// [runZonedGuarded]を`true`にすると[runApp]を[runZonedGuarded]でラッピングすることができます。
/// その際、[onPreRunApp]で[runApp]前の処理を実行することができ、[onError]でエラー時の処理を記述することができます。
///
/// [navigatorObservers]でページ間の遷移を監視するためのオブザーバーを設置することができます。
///
/// [onBuildApp]で[MasamuneApp]のビルド時にウィジェットを追加することが可能です。
abstract class MasamuneAdapter {
  /// Adapter for easily adding functions to Masamune Framework.
  ///
  /// Setting [runZonedGuarded] to `true` allows wrapping [runApp] with [runZonedGuarded].
  /// At that time, [onPreRunApp] can be used to execute the process before [runApp], and [onError] can be used to describe the process in case of an error.
  ///
  /// You can set up observers to monitor transitions between pages at [navigatorObservers].
  ///
  /// Widgets can be added during the build of [MasamuneApp] with [onBuildApp].
  ///
  /// Masamune Frameworkに機能を手軽に追加するためのアダプター。
  ///
  /// アプリ起動時と[MasamuneApp]に渡す処理を記述することができます。
  ///
  /// [runZonedGuarded]を`true`にすると[runApp]を[runZonedGuarded]でラッピングすることができます。
  /// その際、[onPreRunApp]で[runApp]前の処理を実行することができ、[onError]でエラー時の処理を記述することができます。
  ///
  /// [navigatorObservers]でページ間の遷移を監視するためのオブザーバーを設置することができます。
  ///
  /// [onBuildApp]で[MasamuneApp]のビルド時にウィジェットを追加することが可能です。
  const MasamuneAdapter();

  /// If you set this to `true`, you can wrap [runApp] with [runZonedGuarded].
  ///
  /// これを`true`にした場合、[runApp]を[runZonedGuarded]でラッピングすることができます。
  bool get runZonedGuarded;

  /// Observers can be set up to monitor transitions between pages.
  ///
  /// ページ間の遷移を監視するためのオブザーバーを設置することができます。
  List<NavigatorObserver> get navigatorObservers;

  /// Widgets can be added during the build of [MasamuneApp].
  ///
  /// The widget generated in [MasamuneApp] is passed to [app].
  ///
  /// Returning [Widget] will build the widget.
  ///
  /// [MasamuneApp]のビルド時にウィジェットを追加することが可能です。
  ///
  /// [app]に[MasamuneApp]内で生成されたウィジェットが渡されます。
  ///
  /// [Widget]を返すとそのウィジェットがビルドされます。
  Widget onBuildApp(BuildContext context, Widget app);

  /// You can describe the process before [runApp].
  ///
  /// [runApp]前の処理を記述することができます。
  FutureOr<void>? onPreRunApp();

  /// You can describe the process when [runZonedGuarded] is set to `true`.
  ///
  /// The object in which the error occurred is passed to [error] and [stackTrace].
  ///
  /// [runZonedGuarded]を`true`にした場合の処理を記述することができます。
  ///
  /// [error]と[stackTrace]にエラーが起きた際のオブジェクトが渡されます。
  void onError(Object error, StackTrace stackTrace);
}
