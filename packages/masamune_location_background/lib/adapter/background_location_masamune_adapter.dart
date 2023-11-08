part of '/masamune_location_background.dart';

/// Initial settings for handling location information [MasamuneAdapter].
///
/// 位置情報を取り扱うための初期設定を行う[MasamuneAdapter]。
class BackgroundLocationMasamuneAdapter extends MasamuneAdapter {
  /// Initial settings for handling location information [MasamuneAdapter].
  ///
  /// 位置情報を取り扱うための初期設定を行う[MasamuneAdapter]。
  const BackgroundLocationMasamuneAdapter({
    this.defaultAccuracy = LocationAccuracy.high,
    this.defaultDistanceFilterMeters = 10,
    this.defaultUpdateInterval = const Duration(seconds: 60),
    this.location,
    this.listenOnBoot = false,
    this.androidNotificationSettings =
        const BackgroundLocationAndroidNotificationSettings(),
    this.stopOnTerminate = false,
    this.onResume,
    this.onUpdate,
  });

  /// Interval to update location data.
  ///
  /// 位置情報のデータを更新するインターバル。
  final Duration defaultUpdateInterval;

  /// Callback called when location information is updated.
  ///
  /// 位置情報がアップデートされたときに呼び出されるコールバック。
  final FutureOr<void> Function(BackgroundLocation location)? onUpdate;

  /// Callback called when the app resumes.
  ///
  /// アプリがレジュームしたときに呼び出されるコールバック。
  final FutureOr<void> Function(BackgroundLocation location)? onResume;

  /// Specifies the accuracy of location information.
  ///
  /// 位置情報の正確さを指定します。
  final LocationAccuracy defaultAccuracy;

  /// Minimum distance in meters for location updates.
  ///
  /// 位置情報を更新する際の最低距離（m）。
  final double defaultDistanceFilterMeters;

  /// `true` if the app is stopped when it is killed.
  ///
  /// アプリがkillされたときに停止する場合`true`。
  final bool stopOnTerminate;

  /// Notification settings for Android.
  ///
  /// Android用の通知設定。
  final BackgroundLocationAndroidNotificationSettings
      androidNotificationSettings;

  /// Specify the object of [BackgroundLocation].
  ///
  /// After specifying this, execute [onMaybeBoot] to start initialization automatically.
  ///
  /// [BackgroundLocation]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で初期化を開始します。
  final BackgroundLocation? location;

  /// `true` if [location] is set to `true` to start acquiring location information when [onMaybeBoot] is executed.
  ///
  /// [location]が設定されている場合、[onMaybeBoot]を実行した際合わせて位置情報の取得も開始する場合`true`。
  final bool listenOnBoot;

  /// You can retrieve the [BackgroundLocationMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[BackgroundLocationMasamuneAdapter]を取得することができます。
  static BackgroundLocationMasamuneAdapter get primary {
    assert(
      _primary != null,
      "BackgroundLocationMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static BackgroundLocationMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! BackgroundLocationMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<BackgroundLocationMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }

  @override
  FutureOr<void> onMaybeBoot() async {
    await super.onMaybeBoot();
    if (listenOnBoot) {
      await location?.listen();
    } else {
      await location?.initialize();
    }
  }
}
