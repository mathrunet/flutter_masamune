part of masamune_ads.mobile;

/// Display banner ads.
class AdsBanner extends StatefulWidget {
  /// Display banner ads.
  const AdsBanner({
    required this.unitId,
    this.bannerSize = AdsSize.banner,
  });

  /// Admob advertising ID.
  final String unitId;

  /// Admob banner size.
  final AdsSize bannerSize;

  @override
  State<StatefulWidget> createState() => _AdsBannerState();
}

class _AdsBannerState extends State<AdsBanner> {
  late final BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd =
        _AdsBannerCacheManager._getBannerAd(widget.unitId, widget.bannerSize);
  }

  @override
  void dispose() {
    super.dispose();
    _AdsBannerCacheManager._disposeBannerAd(
      widget.unitId,
      widget.bannerSize,
      _bannerAd,
    );
  }

  /// Run build.
  ///
  /// [context]: Build Context.
  @override
  Widget build(BuildContext context) {
    final version = Config.androidDeviceInfo?.version.sdkInt;
    return _CustomAdWidget(
      ad: _bannerAd,
      useVirtualDisplay: version != null && version >= 29,
    );
  }
}

class _AdsBannerCacheManager {
  const _AdsBannerCacheManager();

  static final Map<String, List<BannerAd>> _bannerAdCache = {};
  static BannerAd _getBannerAd(String unitId, AdsSize bannerSize) {
    final contextId = "${unitId}_${bannerSize.width}x${bannerSize.height}";
    if (_bannerAdCache.containsKey(contextId)) {
      final cache = _bannerAdCache[contextId];
      if (cache.isNotEmpty) {
        return cache!.removeLast();
      }
    }
    final banner = _createBannerAd(unitId, bannerSize);
    return banner;
  }

  static BannerAd _createBannerAd(String unitId, AdsSize bannerSize) {
    return BannerAd(
      adUnitId: unitId,
      size: AdSize(width: bannerSize.width, height: bannerSize.height),
      request: const AdRequest(),
      listener: const BannerAdListener(),
    )..load();
  }

  static void _disposeBannerAd(
    String unitId,
    AdsSize bannerSize,
    BannerAd? banner,
  ) {
    if (banner == null) {
      return;
    }
    final contextId = "${unitId}_${bannerSize.width}x${bannerSize.height}";
    if (_bannerAdCache.containsKey(contextId)) {
      _bannerAdCache[contextId]!.add(banner);
    } else {
      _bannerAdCache[contextId] = [banner];
    }
  }
}

class _CustomAdWidget extends StatefulWidget {
  const _CustomAdWidget({
    Key? key,
    required this.ad,
    this.useVirtualDisplay = false,
  }) : super(key: key);

  final AdWithView ad;
  final bool useVirtualDisplay;

  @override
  _CustomAdWidgetState createState() => _CustomAdWidgetState();
}

class _CustomAdWidgetState extends State<_CustomAdWidget> {
  bool _adIdAlreadyMounted = false;

  @override
  void initState() {
    super.initState();
    final adId = instanceManager.adIdFor(widget.ad);
    if (adId == null) {
      return;
    }
    if (instanceManager.isWidgetAdIdMounted(adId)) {
      _adIdAlreadyMounted = true;
    }
    instanceManager.mountWidgetAdId(adId);
  }

  @override
  void dispose() {
    super.dispose();
    final adId = instanceManager.adIdFor(widget.ad);
    if (adId == null) {
      return;
    }
    instanceManager.unmountWidgetAdId(adId);
  }

  @override
  Widget build(BuildContext context) {
    if (_adIdAlreadyMounted) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary("This AdWidget is already in the Widget tree"),
        ErrorHint(
          "If you placed this AdWidget in a list, make sure you create a new instance "
          "in the builder function with a unique ad object.",
        ),
        ErrorHint(
          "Make sure you are not using the same ad object in more than one AdWidget.",
        ),
      ]);
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (widget.useVirtualDisplay) {
        return AndroidView(
          viewType: "${instanceManager.channel.name}/ad_widget",
          creationParamsCodec: const StandardMessageCodec(),
          creationParams: instanceManager.adIdFor(widget.ad),
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
        );
      } else {
        return PlatformViewLink(
          viewType: "${instanceManager.channel.name}/ad_widget",
          surfaceFactory:
              (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const <
                  Factory<OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: "${instanceManager.channel.name}/ad_widget",
              layoutDirection: TextDirection.ltr,
              creationParams: instanceManager.adIdFor(widget.ad),
              // ignore: prefer_const_constructors
              creationParamsCodec: StandardMessageCodec(),
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..create();
          },
        );
      }
    }

    return UiKitView(
      viewType: "${instanceManager.channel.name}/ad_widget",
      creationParams: instanceManager.adIdFor(widget.ad),
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
