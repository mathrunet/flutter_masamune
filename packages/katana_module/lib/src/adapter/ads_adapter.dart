part of katana_module;

/// Module adapter for setting up ads.
///
/// [AdsAdapter] can switch the data
/// when the module is used by passing it to [UIMaterialApp].
@immutable
abstract class AdsAdapter extends AdapterModule {
  const AdsAdapter();

  /// Display banner ads.
  Widget? banner(BuildContext context);
}
