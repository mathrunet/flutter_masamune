part of 'others.dart';

/// Class that manages all aspects of GoogleAd.
///
/// [initialize] is executed to initialize the advertisement.
///
/// GoogleAdの全般を管理するクラス。
///
/// [initialize]を実行することで広告の初期化を行います。
class GoogleAdsCore {
  GoogleAdsCore._();

  /// Returns `true` if initialization is complete.
  ///
  /// 初期化が完了している場合`true`を返します。
  static bool get initialized => _initialized;
  static bool _initialized = false;

  static Completer<void>? _completer;
  static Completer<void>? _permissionCompleter;

  static final Map<String, List<GoogleBannerAdUnit>> _bannerAdPool = {};

  /// Initialize the advertisement.
  ///
  /// 広告を初期化します。
  static Future<void> initialize() async {
    if (initialized) {
      return;
    }
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      await permission();
      await MobileAds.instance.initialize();
      _initialized = true;
      _completer = Completer<void>();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Request permission.
  ///
  /// 許可をリクエストします。
  static Future<void> permission() async {
    if (_permissionCompleter != null) {
      return _permissionCompleter!.future;
    }
    _permissionCompleter = Completer<void>();
    try {
      final status = await Permission.appTrackingTransparency.status;
      if (status != PermissionStatus.granted) {
        await Permission.appTrackingTransparency.request();
      }
      _permissionCompleter = Completer<void>();
      _permissionCompleter = null;
    } catch (e) {
      _permissionCompleter?.completeError(e);
      _permissionCompleter = null;
    } finally {
      _permissionCompleter?.complete();
      _permissionCompleter = null;
    }
  }

  /// Pre-load banner ads.
  ///
  /// Specify the ad unit ID in [adUnitId] and the ad size in [size].
  ///
  /// バナー広告を事前に読み込みます。
  ///
  /// [adUnitId]に広告ユニットIDを[size]に広告サイズを指定します。
  static Future<void> preloadBannerAd({
    String? adUnitId,
    required GoogleBannerAdSize size,
  }) async {
    await initialize();
    final unit = _rentBannerAd(size: size, adUnitId: adUnitId);
    _returnBannerAd(unit: unit);
    await unit.loading;
  }

  static GoogleBannerAdUnit _rentBannerAd({
    String? adUnitId,
    required GoogleBannerAdSize size,
  }) {
    adUnitId ??= GoogleAdsMasamuneAdapter.primary.defaultAdUnitId;
    final key =
        "$adUnitId:${size._toAdSize().width}x${size._toAdSize().height}";
    if (!_bannerAdPool.containsKey(key)) {
      _bannerAdPool[key] = [];
    }
    if (_bannerAdPool[key]!.isEmpty) {
      return GoogleBannerAdUnit._(adUnitId: adUnitId, size: size);
    }
    return _bannerAdPool[key]!.removeAt(0);
  }

  static void _returnBannerAd({
    GoogleBannerAdUnit? unit,
  }) {
    if (unit == null) {
      return;
    }
    final key =
        "${unit.adUnitId}:${unit.size._toAdSize().width}x${unit.size._toAdSize().height}";
    if (!_bannerAdPool.containsKey(key)) {
      _bannerAdPool[key] = [];
    }
    _bannerAdPool[key]!.add(unit);
  }
}
