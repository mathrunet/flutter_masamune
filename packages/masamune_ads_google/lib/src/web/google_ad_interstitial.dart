part of "web.dart";

/// This class displays interstitial advertisements.
///
/// Display interstitial ads by specifying [adUnitId].
///
/// After [loading] finishes, [show] displays the advertisement.
///
/// インタースティシャル広告を表示するクラスです。
///
/// [adUnitId]を指定してインタースティシャル広告を表示します。
///
/// [loading]が終了した後、[show]で広告を表示します。
class GoogleAdInterstitial
    extends MasamuneControllerBase<void, GoogleAdsMasamuneAdapter> {
  /// This class displays interstitial advertisements.
  ///
  /// Display interstitial ads by specifying [adUnitId].
  ///
  /// After [loading] finishes, [show] displays the advertisement.
  ///
  /// インタースティシャル広告を表示するクラスです。
  ///
  /// [adUnitId]を指定してインタースティシャル広告を表示します。
  ///
  /// [loading]が終了した後、[show]で広告を表示します。
  GoogleAdInterstitial({
    this.adUnitId,
    super.adapter,
  });

  @override
  GoogleAdsMasamuneAdapter get primaryAdapter =>
      GoogleAdsMasamuneAdapter.primary;

  /// Query for GoogleAdInterstitial.
  ///
  /// ```dart
  /// appRef.controller(GoogleAdInterstitial.query(parameters));     // Get from application scope.
  /// ref.app.controller(GoogleAdInterstitial.query(parameters));    // Watch at application scope.
  /// ref.page.controller(GoogleAdInterstitial.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$GoogleAdInterstitialQuery();

  /// Ad unit ID.
  ///
  /// 広告ユニットID。
  final String? adUnitId;

  /// Returns `true` if initialization is complete.
  ///
  /// 初期化が完了している場合`true`を返します。
  bool get initialized => true;

  /// Returns [Future] if reading is in progress.
  ///
  /// 読み込み中の場合は[Future]を返します。
  Future<void>? get loading => null;

  /// Returns [Future] if displaying is in progress.
  ///
  /// 表示中の場合は[Future]を返します。
  Future<void>? get showing => null;

  /// Initialize and load ads.
  ///
  /// 広告の初期化とロードを行います。
  Future<void> load() => Future.value();

  /// Display the advertisement.
  ///
  /// You can specify a callback when an ad is clicked with [onAdClicked].
  ///
  /// 広告を表示します。
  ///
  /// [onAdClicked]で広告がクリックされた時のコールバックを指定できます。
  Future<void> show({
    VoidCallback? onAdClicked,
  }) =>
      Future.value();
}

@immutable
class _$GoogleAdInterstitialQuery {
  const _$GoogleAdInterstitialQuery();

  @useResult
  _$_GoogleAdInterstitialQuery call({String? adUnitId}) =>
      _$_GoogleAdInterstitialQuery(
        adUnitId ?? hashCode.toString(),
        adUnitId: adUnitId,
      );
}

@immutable
class _$_GoogleAdInterstitialQuery
    extends ControllerQueryBase<GoogleAdInterstitial> {
  const _$_GoogleAdInterstitialQuery(
    this._name, {
    required this.adUnitId,
  });

  final String _name;
  final String? adUnitId;

  @override
  GoogleAdInterstitial Function() call(Ref ref) {
    return () => GoogleAdInterstitial(
          adUnitId: adUnitId,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}

/// This class displays a rewarded interstitial ad.
///
/// Display interstitial ads by specifying [adUnitId].
///
/// After [loading] finishes, [show] displays the advertisement.
///
/// リワード付きのインタースティシャル広告を表示するクラスです。
///
/// [adUnitId]を指定してインタースティシャル広告を表示します。
///
/// [loading]が終了した後、[show]で広告を表示します。
class GoogleAdRewardedInterstitial
    extends MasamuneControllerBase<void, GoogleAdsMasamuneAdapter> {
  /// This class displays a rewarded interstitial ad.
  ///
  /// Display interstitial ads by specifying [adUnitId].
  ///
  /// After [loading] finishes, [show] displays the advertisement.
  ///
  /// リワード付きのインタースティシャル広告を表示するクラスです。
  ///
  /// [adUnitId]を指定してインタースティシャル広告を表示します。
  ///
  /// [loading]が終了した後、[show]で広告を表示します。
  GoogleAdRewardedInterstitial({
    this.adUnitId,
    super.adapter,
  });

  @override
  GoogleAdsMasamuneAdapter get primaryAdapter =>
      GoogleAdsMasamuneAdapter.primary;

  /// Query for GoogleAdRewardedInterstitial.
  ///
  /// ```dart
  /// appRef.controller(GoogleAdRewardedInterstitial.query(parameters));     // Get from application scope.
  /// ref.app.controller(GoogleAdRewardedInterstitial.query(parameters));    // Watch at application scope.
  /// ref.page.controller(GoogleAdRewardedInterstitial.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$GoogleAdRewardedInterstitialQuery();

  /// Ad unit ID.
  ///
  /// 広告ユニットID。
  final String? adUnitId;

  /// Returns `true` if initialization is complete.
  ///
  /// 初期化が完了している場合`true`を返します。
  bool get initialized => true;

  /// Returns [Future] if reading is in progress.
  ///
  /// 読み込み中の場合は[Future]を返します。
  Future<void>? get loading => null;

  /// Returns [Future] if displaying is in progress.
  ///
  /// 表示中の場合は[Future]を返します。
  Future<void>? get showing => null;

  /// Initialize and load ads.
  ///
  /// 広告の初期化とロードを行います。
  Future<void> load() => Future.value();

  /// Display the advertisement.
  ///
  /// You can specify a callback when a reward is earned with [onEarnedReward].
  ///
  /// You can specify a callback when an ad is clicked with [onAdClicked].
  ///
  /// 広告を表示します。
  ///
  /// [onEarnedReward]でリワードを獲得した時のコールバックを指定できます。
  ///
  /// [onAdClicked]で広告がクリックされた時のコールバックを指定できます。
  Future<void> show({
    required FutureOr<void> Function(double amount, String type) onEarnedReward,
    VoidCallback? onAdClicked,
  }) =>
      Future.value();
}

@immutable
class _$GoogleAdRewardedInterstitialQuery {
  const _$GoogleAdRewardedInterstitialQuery();

  @useResult
  _$_GoogleAdRewardedInterstitialQuery call({String? adUnitId}) =>
      _$_GoogleAdRewardedInterstitialQuery(
        adUnitId ?? hashCode.toString(),
        adUnitId: adUnitId,
      );
}

@immutable
class _$_GoogleAdRewardedInterstitialQuery
    extends ControllerQueryBase<GoogleAdRewardedInterstitial> {
  const _$_GoogleAdRewardedInterstitialQuery(
    this._name, {
    required this.adUnitId,
  });

  final String _name;
  final String? adUnitId;

  @override
  GoogleAdRewardedInterstitial Function() call(Ref ref) {
    return () => GoogleAdRewardedInterstitial(
          adUnitId: adUnitId,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
