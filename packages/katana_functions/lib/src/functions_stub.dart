part of "/katana_functions.dart";

/// Class for stubbing specific functions used in [RuntimeFunctionsAdapter].
///
/// Specify the function name in [functionName] and describe the processing of the function in [process].
///
/// [RuntimeFunctionsAdapter]で用いる特定の関数をスタブ化するためのクラス。
///
/// [functionName]に関数名を指定し、[process]に関数の処理を記述します。
class FunctionStub {
  /// Class for stubbing specific functions used in [RuntimeFunctionsAdapter].
  ///
  /// Specify the function name in [functionName] and describe the processing of the function in [process].
  ///
  /// [RuntimeFunctionsAdapter]で用いる特定の関数をスタブ化するためのクラス。
  ///
  /// [functionName]に関数名を指定し、[process]に関数の処理を記述します。
  const FunctionStub(this.functionName, this.process);

  /// Function name.
  ///
  /// 関数名。
  final String functionName;

  /// Function processing.
  ///
  /// The value passed in [FunctionsAction] is entered in [input].
  ///
  /// The return value is the value returned by [FunctionsAction].
  ///
  /// 関数の処理。
  ///
  /// [input]には[FunctionsAction]で渡された値が入ります。
  ///
  /// 戻り値には[FunctionsAction]で返却する値を返します。
  final FutureOr<DynamicMap> Function(DynamicMap input) process;
}
