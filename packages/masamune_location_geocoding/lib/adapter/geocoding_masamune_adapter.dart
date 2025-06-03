part of "/masamune_location_geocoding.dart";

/// [MasamuneAdapter] for configuring Geocoding functions.
///
/// Geocoding機能を設定するための[MasamuneAdapter]。
class GeocodingMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for configuring Geocoding functions.
  ///
  /// Geocoding機能を設定するための[MasamuneAdapter]。
  const GeocodingMasamuneAdapter();

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<GeocodingMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
