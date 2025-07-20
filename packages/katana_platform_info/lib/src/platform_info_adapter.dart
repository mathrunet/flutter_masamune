part of "/katana_platform_info.dart";

/// An adapter to modify authentication behavior for each platform.
///
/// By passing an object that inherits this to `[PlatformInfoAdapterScope]`, you can change the app-wide authentication.
///
/// When actually acquiring various information, the `[PlatformInfo]` class is used, but all internal implementations are handled via this `[PlatformInfoAdapter]`.
///
/// プラットフォームごとの認証の振る舞いを変えるためのアダプター。
///
/// これを継承したオブジェクトを[PlatformInfoAdapterScope]で渡すことによりアプリ全体の認証を変更することができます。
///
/// 実際に各種情報を取得する際は[PlatformInfo]のクラスを用いて行ないますが、内部実装はすべてこの[PlatformInfoAdapter]経由で行われます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return PlatformInfoAdapterScope(
///       adapter: const RuntimePlatformInfoAdapter(),
///       child: MaterialApp(
///         home: const PlatformInfoPage(),
///       ),
///     );
///   }
/// }
/// ```
abstract class PlatformInfoAdapter {
  /// An adapter to modify authentication behavior for each platform.
  ///
  /// By passing an object that inherits this to `[PlatformInfoAdapterScope]`, you can change the app-wide authentication.
  ///
  /// When actually acquiring various information, the `[PlatformInfo]` class is used, but all internal implementations are handled via this `[PlatformInfoAdapter]`.
  ///
  /// プラットフォームごとの認証の振る舞いを変えるためのアダプター。
  ///
  /// これを継承したオブジェクトを[PlatformInfoAdapterScope]で渡すことによりアプリ全体の認証を変更することができます。
  ///
  /// 実際に各種情報を取得する際は[PlatformInfo]のクラスを用いて行ないますが、内部実装はすべてこの[PlatformInfoAdapter]経由で行われます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return PlatformInfoAdapterScope(
  ///       adapter: const RuntimePlatformInfoAdapter(),
  ///       child: MaterialApp(
  ///         home: const PlatformInfoPage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const PlatformInfoAdapter();

  /// You can retrieve the [PlatformInfoAdapter] first given by [PlatformInfoAdapterScope].
  ///
  /// 最初に[PlatformInfoAdapterScope]で与えた[PlatformInfoAdapter]を取得することができます。
  static PlatformInfoAdapter get primary {
    return _primary ?? const LocalPlatformInfoAdapter();
  }

  static PlatformInfoAdapter? _primary;
  static PlatformInfoAdapter? _test;

  /// Get the application ID.
  ///
  /// アプリケーションIDを取得します。
  Future<String> getApplicationId();

  /// Get the application version.
  ///
  /// アプリケーションバージョンを取得します。
  Future<String> getApplicationVersion();

  /// Get the application build number.
  ///
  /// アプリケーションビルド番号を取得します。
  Future<String> getApplicationBuildNumber();

  /// Get the temporary directory.
  ///
  /// 一時的なディレクトリを取得します。
  Future<Uri> getTemporaryDirectory();

  /// Get the application documents directory.
  ///
  /// アプリケーションのドキュメントディレクトリを取得します。
  Future<Uri> getApplicationDocumentsDirectory();

  /// Get the library directory.
  ///
  /// ライブラリディレクトリを取得します。
  Future<Uri> getLibraryDirectory();

  /// Check if the platform is iOS.
  ///
  /// プラットフォームがiOSかどうかを確認します。
  ///
  ///
  bool get isIOS;

  /// Check if the platform is Android.
  ///
  /// プラットフォームがAndroidかどうかを確認します。
  bool get isAndroid;

  /// Check if the platform is Web.
  ///
  /// プラットフォームがWebかどうかを確認します。
  bool get isWeb;

  /// Check if the platform is Desktop.
  ///
  /// プラットフォームがデスクトップかどうかを確認します。
  bool get isDesktop;

  /// Check if the platform is macOS.
  ///
  /// プラットフォームがmacOSかどうかを確認します。
  bool get isMacOS;

  /// Check if the platform is Linux.
  ///
  /// プラットフォームがLinuxかどうかを確認します。
  bool get isLinux;

  /// Check if the platform is Windows.
  ///
  /// プラットフォームがWindowsかどうかを確認します。
  bool get isWindows;

  /// Check if the platform is Fuchsia.
  ///
  /// プラットフォームがFuchsiaかどうかを確認します。
  bool get isFuchsia;

  /// Check if the platform is mobile.
  ///
  /// プラットフォームがモバイルかどうかを確認します。
  bool get isMobile;
}

/// Place it on top of [MaterialApp], etc., and set [PlatformInfoAdapter] for the entire app.
///
/// Pass [PlatformInfoAdapter] to [adapter].
///
/// Also, by using [PlatformInfoAdapterScope.of] in a descendant widget, you can retrieve the [PlatformInfoAdapter] set in the [PlatformInfoAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[PlatformInfoAdapter]を設定します。
///
/// [adapter]に[PlatformInfoAdapter]を渡してください。
///
/// また[PlatformInfoAdapterScope.of]を子孫のウィジェット内で利用することにより[PlatformInfoAdapterScope]で設定された[PlatformInfoAdapter]を取得することができます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return PlatformInfoAdapterScope(
///       adapter: const RuntimePlatformInfoAdapter(),
///       child: MaterialApp(
///         home: const AuthPage(),
///       ),
///     );
///   }
/// }
/// ```
class PlatformInfoAdapterScope extends InheritedWidget {
  /// Place it on top of [MaterialApp], etc., and set [PlatformInfoAdapter] for the entire app.
  ///
  /// Pass [PlatformInfoAdapter] to [adapter].
  ///
  /// Also, by using [PlatformInfoAdapterScope.of] in a descendant widget, you can retrieve the [PlatformInfoAdapter] set in the [PlatformInfoAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[PlatformInfoAdapter]を設定します。
  ///
  /// [adapter]に[PlatformInfoAdapter]を渡してください。
  ///
  /// また[PlatformInfoAdapterScope.of]を子孫のウィジェット内で利用することにより[PlatformInfoAdapterScope]で設定された[PlatformInfoAdapter]を取得することができます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return PlatformInfoAdapterScope(
  ///       adapter: const RuntimePlatformInfoAdapter(),
  ///       child: MaterialApp(
  ///         home: const AuthPage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const PlatformInfoAdapterScope({
    required super.child,
    required this.adapter,
    super.key,
  });

  /// [PlatformInfoAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[PlatformInfoAdapter]。
  final PlatformInfoAdapter adapter;

  /// By passing [context], the [PlatformInfoAdapter] set in [PlatformInfoAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [PlatformInfoAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[PlatformInfoAdapterScope]で設定された[PlatformInfoAdapter]を取得することができます。
  ///
  /// 祖先に[PlatformInfoAdapterScope]がない場合はエラーになります。
  static PlatformInfoAdapter? of(BuildContext context) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<PlatformInfoAdapterScope>();
    assert(
      scope != null,
      "PlatformInfoAdapterScope is not found. Place [PlatformInfoAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as PlatformInfoAdapterScope?)?.adapter;
  }

  @override
  bool updateShouldNotify(covariant PlatformInfoAdapterScope oldWidget) =>
      false;
}

/// Test scope for [PlatformInfoAdapter].
///
/// [PlatformInfoAdapter]のテスト用スコープ。
class TestPlatformInfoAdapterScope {
  const TestPlatformInfoAdapterScope._();

  /// Set the [PlatformInfoAdapter] for testing.
  ///
  /// テスト用に[PlatformInfoAdapter]を設定します。
  static void setTestAdapter(PlatformInfoAdapter adapter) {
    PlatformInfoAdapter._test = adapter;
  }
}
