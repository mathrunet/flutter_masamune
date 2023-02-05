part of masamune_logger_firebase;

/// Class for sending Firebase Analytics events, etc.
///
/// With [send], you can send an object in which [FirebaseLoggerAnalyticsValue] is implemented as an event.
///
/// If you want to send other Firebase Analytics events, you can use [analytics] to use the [FirebaseAnalytics] object directly.
///
/// If [adapter] is specified, it is possible to set up a separate [FirebaseLoggerMasamuneAdapter]. Normally, the adapter passed to [FirebaseLoggerMasamuneAdapterScope] is used.
///
/// Firebase Analyticsのイベントなどを送信するためのクラス。
///
/// [send]で[FirebaseLoggerAnalyticsValue]が実装されたオブジェクトをイベントとして送信できます。
///
/// その他Firebase Analyticsのイベントを送信したい場合は[analytics]を利用することで[FirebaseAnalytics]のオブジェクトを直接利用することができます。
///
/// [adapter]を指定すると[FirebaseLoggerMasamuneAdapter]を別に設定することが可能です。通常は[FirebaseLoggerMasamuneAdapterScope]に渡されたアダプターが利用されます。
class FirebaseLogger extends ChangeNotifier {
  /// Class for sending Firebase Analytics events, etc.
  ///
  /// With [send], you can send an object in which [FirebaseLoggerAnalyticsValue] is implemented as an event.
  ///
  /// If you want to send other Firebase Analytics events, you can use [analytics] to use the [FirebaseAnalytics] object directly.
  ///
  /// If [adapter] is specified, it is possible to set up a separate [FirebaseLoggerMasamuneAdapter]. Normally, the adapter passed to [FirebaseLoggerMasamuneAdapterScope] is used.
  ///
  /// Firebase Analyticsのイベントなどを送信するためのクラス。
  ///
  /// [send]で[FirebaseLoggerAnalyticsValue]が実装されたオブジェクトをイベントとして送信できます。
  ///
  /// その他Firebase Analyticsのイベントを送信したい場合は[analytics]を利用することで[FirebaseAnalytics]のオブジェクトを直接利用することができます。
  ///
  /// [adapter]を指定すると[FirebaseLoggerMasamuneAdapter]を別に設定することが可能です。通常は[FirebaseLoggerMasamuneAdapterScope]に渡されたアダプターが利用されます。
  FirebaseLogger({
    FirebaseLoggerMasamuneAdapter? adapter,
  }) : _adapter = adapter;

  /// [FirebaseLoggerMasamuneAdapter] in use.
  ///
  /// 利用している[FirebaseLoggerMasamuneAdapter]。
  FirebaseLoggerMasamuneAdapter get adapter {
    return _adapter ?? FirebaseLoggerMasamuneAdapter.primary;
  }

  final FirebaseLoggerMasamuneAdapter? _adapter;

  /// The instance of [FirebaseAnalytics] to be used.
  ///
  /// 使用する[FirebaseAnalytics]のインスタンス。
  FirebaseAnalytics get analytics => adapter.analytics;

  /// The instance of [FirebaseCrashlytics] to be used.
  ///
  /// 使用する[FirebaseCrashlytics]のインスタンス。
  FirebaseCrashlytics get crashlytics => adapter.crashlytics;

  /// [event] to FirebaseAnalytics.
  ///
  /// The class name of [event] is passed as the event name and the value output by [event.toJson] is passed as a parameter.
  ///
  /// If you want to send raw data, please use [analytics.logEvent].
  ///
  /// [event]をFirebaseAnalyticsに送信します。
  ///
  /// [event]のクラス名がイベント名として渡され、[event.toJson]で出力された値がパラメーターとして渡されます。
  ///
  /// 生データを送信したい場合は[analytics.logEvent]をご利用ください。
  Future<void> send(FirebaseLoggerAnalyticsValue event) async {
    final name = event.runtimeType.toString().trimString(r"_$");
    await analytics.logEvent(name: name, parameters: event.toJson());
    notifyListeners();
  }

  /// Intentionally crashes.
  ///
  /// Please use it to send events to FirebaseCrashlytics.
  ///
  /// 意図的にクラッシュさせます。
  ///
  /// FirebaseCrashlyticsにイベントを送る際にご利用ください。
  void crash() {
    crashlytics.crash();
  }
}

/// Abstract class for objects to send data with [FirebaseLogger.send].
///
/// Use with a package that can encode Json, such as `freezed`.
///
/// [FirebaseLogger.send]でデータを送信するためのオブジェクト用の抽象クラス。
///
/// `freezed`などでJsonエンコードできるパッケージとともにお使いください。
///
/// ```dart
/// @freezed
/// class AnalyticsValue with _$AnalyticsValue implements FirebaseLoggerAnalyticsValue {
///   const factory AnalyticsValue({
///     required String userId,
///   }) = _AnalyticsValue;
///   const AnalyticsValue._();
///
///   factory _AnalyticsValue.fromJson(Map<String, Object?> json) =>
///       _$_AnalyticsValueFromJson(json);
/// }
/// ```
abstract class FirebaseLoggerAnalyticsValue {
  /// Abstract class for objects to send data with [FirebaseLogger.send].
  ///
  /// Use with a package that can encode Json, such as `freezed`.
  ///
  /// [FirebaseLogger.send]でデータを送信するためのオブジェクト用の抽象クラス。
  ///
  /// `freezed`などでJsonエンコードできるパッケージとともにお使いください。
  ///
  /// ```dart
  /// @freezed
  /// class AnalyticsValue with _$AnalyticsValue implements FirebaseLoggerAnalyticsValue {
  ///   const factory AnalyticsValue({
  ///     required String userId,
  ///   }) = _AnalyticsValue;
  ///   const AnalyticsValue._();
  ///
  ///   factory _AnalyticsValue.fromJson(Map<String, Object?> json) =>
  ///       _$_AnalyticsValueFromJson(json);
  /// }
  /// ```
  const FirebaseLoggerAnalyticsValue();

  /// Json encoding.
  ///
  /// Jsonエンコードします。
  Map<String, Object?> toJson();
}
