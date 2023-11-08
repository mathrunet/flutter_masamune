part of '/katana_logger.dart';

/// Class for defining log values for viewing.
///
/// [dateTime] is the date and time of logging, [name] is the name of the log, and [parameters] is the log parameters.
///
/// 閲覧するためのログの値を定義するためのクラス。
///
/// [dateTime]にログの記録日時、[name]にログの名前、[parameters]にログのパラメーターが入ります。
class LogValue {
  /// Class for defining log values for viewing.
  ///
  /// [dateTime] is the date and time of logging, [name] is the name of the log, and [parameters] is the log parameters.
  ///
  /// 閲覧するためのログの値を定義するためのクラス。
  ///
  /// [dateTime]にログの記録日時、[name]にログの名前、[parameters]にログのパラメーターが入ります。
  const LogValue({
    required this.dateTime,
    required this.name,
    this.parameters = const {},
  });

  /// Date and time of logging.
  ///
  /// ログの記録日時。
  final DateTime dateTime;

  /// Log Name.
  ///
  /// ログの名前。
  final String name;

  /// Log parameters.
  ///
  /// ログのパラメーター。
  final DynamicMap parameters;
}
