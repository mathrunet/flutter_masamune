part of "others.dart";

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
  }) {
    _initialize();
  }

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
  bool get initialized => _ad != null;
  RewardedAd? _ad;

  /// Returns [Future] if reading is in progress.
  ///
  /// 読み込み中の場合は[Future]を返します。
  Future<void>? get loading => _loadCompleter?.future;
  Completer<void>? _loadCompleter;

  /// Returns [Future] if displaying is in progress.
  ///
  /// 表示中の場合は[Future]を返します。
  Future<void>? get showing => _showCompleter?.future;
  Completer<void>? _showCompleter;
  Completer<void>? _rewardCompleter;

  /// Initialize and load ads.
  ///
  /// 広告の初期化とロードを行います。
  Future<void> load() {
    return _initialize();
  }

  /// Initialize and reload the ad.
  ///
  /// 広告の初期化と再ロードを行います。
  Future<void> reload() {
    _ad = null;
    return _initialize();
  }

  Future<void> _initialize() async {
    if (_loadCompleter != null) {
      return _loadCompleter!.future;
    }
    if (_ad != null) {
      return;
    }
    _loadCompleter = Completer<void>();
    try {
      await GoogleAdsCore.initialize();
      await RewardedAd.load(
        adUnitId: adUnitId ?? adapter.defaultAdUnitId,
        request: const AdManagerAdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _ad = ad;
            _ad!.setImmersiveMode(true);
            _loadCompleter?.complete();
            _loadCompleter = null;
          },
          onAdFailedToLoad: (e) {
            debugPrint("RewardedAd failed to load: $e");
            _ad = null;
            if (e.code == 3 || e.code == 1) {
              final error = GoogleAdsNoFillError(
                adUnitId: adUnitId ?? adapter.defaultAdUnitId,
              );
              _loadCompleter?.completeError(error);
              _loadCompleter = null;
            } else {
              _loadCompleter?.completeError(e);
              _loadCompleter = null;
            }
          },
        ),
      );
      await _loadCompleter?.future;
      notifyListeners();
      _loadCompleter?.complete();
      _loadCompleter = null;
    } on LoadAdError catch (e) {
      if (e.code == 3 || e.code == 1) {
        final error = GoogleAdsNoFillError(
          adUnitId: adUnitId ?? adapter.defaultAdUnitId,
        );
        _loadCompleter?.completeError(error);
        _loadCompleter = null;
        throw error;
      } else {
        _loadCompleter?.completeError(e);
        _loadCompleter = null;
        rethrow;
      }
    } catch (e) {
      _loadCompleter?.completeError(e);
      _loadCompleter = null;
      rethrow;
    } finally {
      _loadCompleter?.complete();
      _loadCompleter = null;
    }
  }

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
  }) async {
    if (_showCompleter != null) {
      return _showCompleter!.future;
    }
    _showCompleter = Completer<void>();
    try {
      await load();
      _ad!.fullScreenContentCallback = FullScreenContentCallback(
        onAdClicked: (ad) {
          onAdClicked?.call();
        },
        onAdDismissedFullScreenContent: (ad) {
          reload();
        },
      );
      await _ad!.show(
        onUserEarnedReward: (ad, reward) async {
          _rewardCompleter = Completer<void>();
          try {
            await onEarnedReward.call(reward.amount.toDouble(), reward.type);
            _rewardCompleter?.complete();
            _rewardCompleter = null;
          } catch (e) {
            _rewardCompleter?.completeError(e);
            _rewardCompleter = null;
          } finally {
            _rewardCompleter?.complete();
            _rewardCompleter = null;
          }
        },
      );
      await _rewardCompleter?.future;
      _ad = null;
      notifyListeners();
      _showCompleter?.complete();
      _showCompleter = null;
    } catch (e) {
      _showCompleter?.completeError(e);
      _showCompleter = null;
      rethrow;
    } finally {
      _showCompleter?.complete();
      _showCompleter = null;
    }
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _ad?.dispose();
    _ad = null;
  }
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
