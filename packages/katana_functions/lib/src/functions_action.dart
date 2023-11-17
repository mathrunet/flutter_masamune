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

  /// Convert to [DynamicMap] to pass values to the server side.
  ///
  /// サーバー側に値を渡すために[DynamicMap]に変換します。
  DynamicMap? toMap();

  /// Converts the value returned from the server side to [TResponse].
  ///
  /// サーバー側から返却された値を[TResponse]に変換します。
  TResponse toResponse(DynamicMap map);

  /// The value is actually passed to the server side for execution.
  ///
  /// 実際にサーバー側に値を渡して実行します。
  Future<TResponse> execute(
    Future<DynamicMap?> Function(DynamicMap? map) callback,
  ) async {
    final input = toMap();
    final res = await callback.call(input);
    if (res == null) {
      return throw Exception("Response is empty.");
    }
    return toResponse(res);
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

/// [FunctionsAction] for testing.
///
/// テスト用の[FunctionsAction]。
class TestFunctionsAction extends FunctionsAction<void> {
  /// [FunctionsAction] for testing.
  ///
  /// テスト用の[FunctionsAction]。
  const TestFunctionsAction();

  @override
  String get action => "test";

  @override
  DynamicMap? toMap() {
    return null;
  }

  @override
  void toResponse(DynamicMap map) {}
}
