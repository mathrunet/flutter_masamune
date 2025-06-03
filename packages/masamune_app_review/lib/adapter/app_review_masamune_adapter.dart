part of "/masamune_app_review.dart";

/// [MasamuneAdapter] to support app reviews in the store.
///
/// [googlePlayStoreUrl] specifies the Google Play Store URL.
///
/// [appStoreUrl] specifies the App Store URL.
///
/// ストアにおけるアプリレビューをサポートするための[MasamuneAdapter]。
///
/// [googlePlayStoreUrl]にはGooglePlayStoreのURLを指定します。
///
/// [appStoreUrl]にはAppStoreのURLを指定します。
class AppReviewMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] to support app reviews in the store.
  ///
  /// [googlePlayStoreUrl] specifies the Google Play Store URL.
  ///
  /// [appStoreUrl] specifies the App Store URL.
  ///
  /// ストアにおけるアプリレビューをサポートするための[MasamuneAdapter]。
  ///
  /// [googlePlayStoreUrl]にはGooglePlayStoreのURLを指定します。
  ///
  /// [appStoreUrl]にはAppStoreのURLを指定します。
  const AppReviewMasamuneAdapter({
    this.googlePlayStoreUrl,
    this.appStoreUrl,
  });

  /// The [googlePlayStoreUrl] field specifies the google play store url.
  ///
  /// GooglePlayStoreのURL。
  final String? googlePlayStoreUrl;

  /// The [appStoreUrl] field specifies the app store url.
  ///
  /// AppStoreのURL。
  final String? appStoreUrl;

  /// You can retrieve the [AppReviewMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[AppReviewMasamuneAdapter]を取得することができます。
  static AppReviewMasamuneAdapter get primary {
    assert(
      _primary != null,
      "AppReviewMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static AppReviewMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! AppReviewMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<AppReviewMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
