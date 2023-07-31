part of masamune_ads_google.others;

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
class GoogleAdInterstitial extends ChangeNotifier {
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
  GoogleAdInterstitial(
    this.adUnitId,
  ) {
    _initialize();
  }

  /// Ad unit ID.
  ///
  /// 広告ユニットID。
  final String adUnitId;

  /// Returns `true` if initialization is complete.
  ///
  /// 初期化が完了している場合`true`を返します。
  bool get initialized => _ad != null;
  InterstitialAd? _ad;

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

  Future<void> _initialize() async {
    _loadCompleter = Completer<void>();
    try {
      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdManagerAdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _ad = ad;
            _ad!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (error) {
            debugPrint("InterstitialAd failed to load: $error.");
            _ad = null;
          },
        ),
      );
      notifyListeners();
      _loadCompleter?.complete();
      _loadCompleter = null;
    } catch (e) {
      _loadCompleter?.completeError(e);
      _loadCompleter = null;
    } finally {
      _loadCompleter?.complete();
      _loadCompleter = null;
    }
  }

  /// Display the advertisement.
  ///
  /// You can specify a callback when an ad is clicked with [onAdClicked].
  ///
  /// 広告を表示します。
  ///
  /// [onAdClicked]で広告がクリックされた時のコールバックを指定できます。
  Future<void> show({
    VoidCallback? onAdClicked,
  }) async {
    if (!initialized) {
      throw Exception("InterstitialAd is not initialized.");
    }
    if (_showCompleter != null) {
      return _showCompleter!.future;
    }
    _showCompleter = Completer<void>();
    try {
      _ad!.fullScreenContentCallback = FullScreenContentCallback(
        onAdClicked: (ad) {
          onAdClicked?.call();
        },
      );
      await _ad!.show();
      notifyListeners();
      _showCompleter?.complete();
      _showCompleter = null;
    } catch (e) {
      _showCompleter?.completeError(e);
      _showCompleter = null;
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
class GoogleAdRewardedInterstitial extends ChangeNotifier {
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
  GoogleAdRewardedInterstitial(
    this.adUnitId,
  ) {
    _initialize();
  }

  /// Ad unit ID.
  ///
  /// 広告ユニットID。
  final String adUnitId;

  /// Returns `true` if initialization is complete.
  ///
  /// 初期化が完了している場合`true`を返します。
  bool get initialized => _ad != null;
  RewardedInterstitialAd? _ad;

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

  Future<void> _initialize() async {
    _loadCompleter = Completer<void>();
    try {
      await RewardedInterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdManagerAdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _ad = ad;
            _ad!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (error) {
            debugPrint("RewardedInterstitialAd failed to load: $error");
            _ad = null;
          },
        ),
      );
      notifyListeners();
      _loadCompleter?.complete();
      _loadCompleter = null;
    } catch (e) {
      _loadCompleter?.completeError(e);
      _loadCompleter = null;
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
    if (!initialized) {
      throw Exception("RewardedInterstitialAd is not initialized.");
    }
    if (_showCompleter != null) {
      return _showCompleter!.future;
    }
    _showCompleter = Completer<void>();
    try {
      _ad!.fullScreenContentCallback = FullScreenContentCallback(
        onAdClicked: (ad) {
          onAdClicked?.call();
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
      notifyListeners();
      _showCompleter?.complete();
      _showCompleter = null;
    } catch (e) {
      _showCompleter?.completeError(e);
      _showCompleter = null;
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
