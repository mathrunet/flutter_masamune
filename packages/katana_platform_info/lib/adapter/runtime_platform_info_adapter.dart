// ignore_for_file: avoid_field_initializers_in_const_classes

part of "/katana_platform_info.dart";

/// [PlatformInfoAdapter] to pre-configure and retrieve platform information.
///
/// プラットフォームの情報を予め設定して取得する[PlatformInfoAdapter]。
@immutable
class RuntimePlatformInfoAdapter extends PlatformInfoAdapter {
  /// [PlatformInfoAdapter] to pre-configure and retrieve platform information.
  ///
  /// プラットフォームの情報を予め設定して取得する[PlatformInfoAdapter]。
  const RuntimePlatformInfoAdapter({
    required this.platformType,
    required this.applicationId,
    this.applicationVersion = "1.0.0",
    this.applicationBuildNumber = "1",
    this.temporaryDirectory = "tmp",
    this.applicationDocumentsDirectory = "documents",
    this.libraryDirectory = "library",
  });

  /// The platform type.
  ///
  /// プラットフォームの種類。
  final PlatformType platformType;

  /// The application ID.
  ///
  /// アプリケーションID。
  final String applicationId;

  /// The application version.
  ///
  /// アプリケーションバージョン。
  final String applicationVersion;

  /// The application build number.
  ///
  /// アプリケーションビルド番号。
  final String applicationBuildNumber;

  /// The temporary directory.
  ///
  /// 一時ディレクトリ。
  final String temporaryDirectory;

  /// The application documents directory.
  ///
  /// アプリケーションドキュメントディレクトリ。
  final String applicationDocumentsDirectory;

  /// The library directory.
  ///
  /// ライブラリディレクトリ。
  final String libraryDirectory;

  @override
  Future<String> getApplicationId() async {
    return applicationId;
  }

  @override
  Future<String> getApplicationVersion() async {
    return applicationVersion;
  }

  @override
  Future<String> getApplicationBuildNumber() async {
    return applicationBuildNumber;
  }

  @override
  Future<Uri> getTemporaryDirectory() async {
    return Uri.file(temporaryDirectory);
  }

  @override
  Future<Uri> getApplicationDocumentsDirectory() async {
    return Uri.file(applicationDocumentsDirectory);
  }

  @override
  Future<Uri> getLibraryDirectory() async {
    return Uri.file(libraryDirectory);
  }

  @override
  bool get isAndroid => platformType == PlatformType.android;

  @override
  bool get isDesktop =>
      platformType == PlatformType.windows ||
      platformType == PlatformType.linux ||
      platformType == PlatformType.macOS;

  @override
  bool get isFuchsia => platformType == PlatformType.fuchsia;

  @override
  bool get isIOS => platformType == PlatformType.iOS;

  @override
  bool get isLinux => platformType == PlatformType.linux;

  @override
  bool get isMacOS => platformType == PlatformType.macOS;

  @override
  bool get isMobile =>
      platformType == PlatformType.android || platformType == PlatformType.iOS;

  @override
  bool get isWeb => platformType == PlatformType.web;

  @override
  bool get isWindows => platformType == PlatformType.windows;
}
