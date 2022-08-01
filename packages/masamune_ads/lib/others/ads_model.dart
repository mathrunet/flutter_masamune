part of masamune_ads.others;

/// Class for managing ads.
///
/// This handle Admob and Adsense.
///
/// Execute [initialize] to initialize.
final adsModelProvider = ChangeNotifierProvider((_) => AdsModel());

/// Class for managing ads.
///
/// This handle Admob and Adsense.
///
/// Execute [initialize] to initialize.
class AdsModel extends Model {
  AdsModel() : super();

  /// Class for managing ads.
  ///
  /// This handle Admob and Adsense.
  ///
  /// Execute [initialize] to initialize.
  Future<AdsModel> initialize() async {
    if (isInitialized) {
      return this;
    }
    _isInitialized = true;
    return this;
  }

  /// True if the billing system has been initialized.
  bool get isInitialized => _isInitialized;
  bool _isInitialized = false;
}
