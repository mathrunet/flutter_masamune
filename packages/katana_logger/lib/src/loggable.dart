part of '/katana_logger.dart';

/// Interface for objects that can be passed directly to [Logger.send].
///
/// If [toJson] is implemented, it can be passed directly.
///
/// The type becomes the name of the log as it is, and [Map] converted by [toJson] becomes a parameter.
///
/// [Logger.send]に直接渡すことのできるオブジェクト用のインターフェース。
///
/// [toJson]を実装していれば直接渡すことができます。
///
/// 型がそのままログの名前となり[toJson]で変換された[Map]がパラメーターとなります。
abstract class Loggable {
  /// Interface for objects that can be passed directly to [Logger.send].
  ///
  /// If [toJson] is implemented, it can be passed directly.
  ///
  /// The type becomes the name of the log as it is, and [Map] converted by [toJson] becomes a parameter.
  ///
  /// [Logger.send]に直接渡すことのできるオブジェクト用のインターフェース。
  ///
  /// [toJson]を実装していれば直接渡すことができます。
  ///
  /// 型がそのままログの名前となり[toJson]で変換された[Map]がパラメーターとなります。
  const Loggable();

  /// You can convert from Json to pass parameters.
  ///
  /// パラメーターを渡すためにJsonから変換することができます。
  Map<String, dynamic> toJson();
}
