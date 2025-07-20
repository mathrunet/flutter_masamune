part of "/katana_platform_info.dart";

/// A class that provides platform information.
///
/// プラットフォーム情報を提供するクラス。
@immutable
class PlatformInfo {
  /// A class that provides platform information.
  ///
  /// プラットフォーム情報を提供するクラス。
  const PlatformInfo({
    PlatformInfoAdapter? adapter,
  }) : _adapter = adapter;

  /// An adapter that defines the platform information.
  ///
  /// プラットフォーム情報を定義するアダプター。
  PlatformInfoAdapter get adapter {
    return PlatformInfoAdapter._test ?? _adapter ?? PlatformInfoAdapter.primary;
  }

  final PlatformInfoAdapter? _adapter;

  /// Get the application ID.
  ///
  /// アプリケーションIDを取得します。
  Future<String> getApplicationId() => adapter.getApplicationId();

  /// Get the application version.
  ///
  /// アプリケーションバージョンを取得します。
  Future<String> getApplicationVersion() => adapter.getApplicationVersion();

  /// Get the application build number.
  ///
  /// アプリケーションビルド番号を取得します。
  Future<String> getApplicationBuildNumber() =>
      adapter.getApplicationBuildNumber();

  /// Get the temporary directory.
  ///
  /// 一時的なディレクトリを取得します。
  Future<Uri> getTemporaryDirectory() => adapter.getTemporaryDirectory();

  /// Get the application documents directory.
  ///
  /// アプリケーションのドキュメントディレクトリを取得します。
  Future<Uri> getApplicationDocumentsDirectory() =>
      adapter.getApplicationDocumentsDirectory();

  /// Get the library directory.
  ///
  /// ライブラリディレクトリを取得します。
  Future<Uri> getLibraryDirectory() => adapter.getLibraryDirectory();

  /// Check if the platform is iOS.
  ///
  /// プラットフォームがiOSかどうかを確認します。
  ///
  ///
  bool get isIOS => adapter.isIOS;

  /// Check if the platform is Android.
  ///
  /// プラットフォームがAndroidかどうかを確認します。
  bool get isAndroid => adapter.isAndroid;

  /// Check if the platform is Web.
  ///
  /// プラットフォームがWebかどうかを確認します。
  bool get isWeb => adapter.isWeb;

  /// Check if the platform is Desktop.
  ///
  /// プラットフォームがデスクトップかどうかを確認します。
  bool get isDesktop => adapter.isDesktop;

  /// Check if the platform is macOS.
  ///
  /// プラットフォームがmacOSかどうかを確認します。
  bool get isMacOS => adapter.isMacOS;

  /// Check if the platform is Linux.
  ///
  /// プラットフォームがLinuxかどうかを確認します。
  bool get isLinux => adapter.isLinux;

  /// Check if the platform is Windows.
  ///
  /// プラットフォームがWindowsかどうかを確認します。
  bool get isWindows => adapter.isWindows;

  /// Check if the platform is Fuchsia.
  ///
  /// プラットフォームがFuchsiaかどうかを確認します。
  bool get isFuchsia => adapter.isFuchsia;

  /// Check if the platform is mobile.
  ///
  /// プラットフォームがモバイルかどうかを確認します。
  bool get isMobile => adapter.isMobile;

  /// Check if the platform is test.
  ///
  /// プラットフォームがテストかどうかを確認します。
  bool get isTest => adapter.isTest;

  /// Get image for debugging.
  ///
  /// If not [Null], all images will be replaced with this data.
  ///
  /// デバッグ用の画像を取得します。
  ///
  /// [Null]でない場合画像はすべてこのデータに入れ替わります。
  Future<Uint8List?> get debugImageData => adapter.debugImageData;
}
