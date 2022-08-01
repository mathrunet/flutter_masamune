part of masamune_ads.others;

/// Class for managing ads.
///
/// This handle Admob and Adsense.
///
/// Execute [initialize] to initialize.
class AdsCore {
  const AdsCore._();

  static AdsModel get _ads {
    return readProvider(adsModelProvider);
  }

  /// Class for managing ads.
  ///
  /// This handle Admob and Adsense.
  ///
  /// Execute [initialize] to initialize.
  static Future<AdsModel> initialize() {
    return _ads.initialize();
  }
}
