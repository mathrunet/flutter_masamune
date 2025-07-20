// ignore_for_file: avoid_field_initializers_in_const_classes

part of "others.dart";

/// A [PlatformInfoAdapter] that actually acquires OS-specific information.
///
/// OSごとの情報を実際に取得する[PlatformInfoAdapter]。
@immutable
class LocalPlatformInfoAdapter extends PlatformInfoAdapter {
  /// A [PlatformInfoAdapter] that actually acquires OS-specific information.
  ///
  /// OSごとの情報を実際に取得する[PlatformInfoAdapter]。
  const LocalPlatformInfoAdapter();

  @override
  Future<String> getApplicationId() async {
    final packageInfo = await package_info.PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  @override
  Future<String> getApplicationVersion() async {
    final packageInfo = await package_info.PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Future<String> getApplicationBuildNumber() async {
    final packageInfo = await package_info.PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  @override
  Future<Uri> getTemporaryDirectory() async {
    final directory = await path_provider.getTemporaryDirectory();
    return directory.uri;
  }

  @override
  Future<Uri> getApplicationDocumentsDirectory() async {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    return directory.uri;
  }

  @override
  Future<Uri> getLibraryDirectory() async {
    final directory = await path_provider.getLibraryDirectory();
    return directory.uri;
  }

  @override
  bool get isIOS => UniversalPlatform.isIOS;

  @override
  bool get isAndroid => UniversalPlatform.isAndroid;

  @override
  bool get isWeb => UniversalPlatform.isWeb;

  @override
  bool get isDesktop => UniversalPlatform.isDesktop;

  @override
  bool get isMacOS => UniversalPlatform.isMacOS;

  @override
  bool get isLinux => UniversalPlatform.isLinux;

  @override
  bool get isWindows => UniversalPlatform.isWindows;

  @override
  bool get isFuchsia => UniversalPlatform.isFuchsia;

  @override
  bool get isMobile => UniversalPlatform.isMobile;

  @override
  Future<Uint8List?> get debugImageData => Future.value(null);
}
