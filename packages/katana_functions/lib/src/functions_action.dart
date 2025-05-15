part of '/katana_functions.dart';

/// Actions used in Functions.
///
/// Inherit and use.
///
/// When executing a Function, pass the object to [Functions.execute] to execute the Function.
///
/// Functionsで用いるアクション。
///
/// 継承して使ってください。
///
/// {@template functions_action}
/// 実行する際はオブジェクトを[Functions.execute]に渡してFunction実行します。
///
/// ```dart
/// final functions = Functions();
/// final response = functions.execute(AnyFunctionsAction());
/// ```
/// {@endtemplate}
abstract class FunctionsAction<TResponse> {
  /// Actions used in Functions.
  ///
  /// Inherit and use.
  ///
  /// When executing a Function, pass the object to [Functions.execute] to execute the Function.
  ///
  /// Functionsで用いるアクション。
  ///
  /// 継承して使ってください。
  ///
  /// {@template functions_action}
  /// 実行する際はオブジェクトを[Functions.execute]に渡してFunction実行します。
  ///
  /// ```dart
  /// final functions = Functions();
  /// final response = functions.execute(AnyFunctionsAction());
  /// ```
  /// {@endtemplate}
  const FunctionsAction();

  /// Action Name.
  ///
  /// アクション名。
  String get action;

  /// Path.
  ///
  /// パス。
  String? get path => null;

  /// Timeout.
  ///
  /// タイムアウト。
  Duration? get timeout => null;

  /// HTTP Method.
  ///
  /// HTTPメソッド。
  ApiMethod? get method => null;

  /// Headers.
  ///
  /// ヘッダー。
  FutureOr<Map<String, String>>? get headers => null;

  /// Convert to [DynamicMap] to pass values to the server side.
  ///
  /// サーバー側に値を渡すために[DynamicMap]に変換します。
  DynamicMap? toMap();

  /// Converts the value returned from the server side to [TResponse].
  ///
  /// サーバー側から返却された値を[TResponse]に変換します。
  TResponse toResponse(DynamicMap map);

  /// Called when an error occurs.
  ///
  /// エラーが発生したときに呼び出されます。
  TResponse onError(Object error, StackTrace stackTrace) {
    throw Exception(
      "${error.runtimeType}: $error\n$stackTrace",
    );
  }

  /// The value is actually passed to the server side for execution.
  ///
  /// 実際にサーバー側に値を渡して実行します。
  Future<TResponse> execute(
    Future<DynamicMap?> Function(DynamicMap? map) callback,
  ) async {
    try {
      final input = toMap();
      final res = await callback.call(input);
      if (res == null) {
        return throw Exception("Response is empty.");
      }
      return toResponse(res);
    } catch (e, stackTrace) {
      return onError(e, stackTrace);
    }
  }
}

/// Class for defining the value returned when executed by [FunctionsAction].
///
/// Inherit and use.
///
/// [FunctionsAction]で実行されたときに返却された値を定義するためのクラス。
///
/// 継承して使ってください。
abstract class FunctionsActionResponse {
  /// Class for defining the value returned when executed by [FunctionsAction].
  ///
  /// Inherit and use.
  ///
  /// [FunctionsAction]で実行されたときに返却された値を定義するためのクラス。
  ///
  /// 継承して使ってください。
  const FunctionsActionResponse();
}
