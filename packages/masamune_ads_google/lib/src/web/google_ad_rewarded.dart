part of "web.dart";

/// This class displays video ads with rewards.
///
/// Display interstitial ads by specifying [adUnitId].
///
/// After [loading] finishes, [show] displays the advertisement.
///
/// リワード付きの動画広告を表示するクラスです。
///
/// [adUnitId]を指定してインタースティシャル広告を表示します。
///
/// [loading]が終了した後、[show]で広告を表示します。
class GoogleAdRewarded
    extends MasamuneControllerBase<void, GoogleAdsMasamuneAdapter> {
  /// This class displays video ads with rewards.
  ///
  /// Display interstitial ads by specifying [adUnitId].
  ///
  /// After [loading] finishes, [show] displays the advertisement.
  ///
  /// リワード付きの動画広告を表示するクラスです。
  ///
  /// [adUnitId]を指定してインタースティシャル広告を表示します。
  ///
  /// [loading]が終了した後、[show]で広告を表示します。
  GoogleAdRewarded({
    this.adUnitId,
    super.adapter,
  });

  @override
  GoogleAdsMasamuneAdapter get primaryAdapter =>
      GoogleAdsMasamuneAdapter.primary;

  /// Query for GoogleAdRewarded.
  ///
  /// ```dart
  /// appRef.controller(GoogleAdRewarded.query(parameters));     // Get from application scope.
  /// ref.app.controller(GoogleAdRewarded.query(parameters));    // Watch at application scope.
  /// ref.page.controller(GoogleAdRewarded.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$GoogleAdRewardedQuery();

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
class _$GoogleAdRewardedQuery {
  const _$GoogleAdRewardedQuery();

  @useResult
  _$_GoogleAdRewardedQuery call({String? adUnitId}) => _$_GoogleAdRewardedQuery(
        adUnitId ?? hashCode.toString(),
        adUnitId: adUnitId,
      );
}

@immutable
class _$_GoogleAdRewardedQuery extends ControllerQueryBase<GoogleAdRewarded> {
  const _$_GoogleAdRewardedQuery(
    this._name, {
    required this.adUnitId,
  });

  final String _name;
  final String? adUnitId;

  @override
  GoogleAdRewarded Function() call(Ref ref) {
    return () => GoogleAdRewarded(
          adUnitId: adUnitId,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
