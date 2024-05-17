part of '/katana_functions.dart';

/// FunctionsAdapter] that only returns a normal system without communicating with the server side.
///
/// Use as a test stub.
///
/// サーバー側と通信せずに正常系を返すだけの[FunctionsAdapter]。
///
/// テスト用のスタブとして利用してください。
class RuntimeFunctionsAdapter extends FunctionsAdapter {
  /// FunctionsAdapter] that only returns a normal system without communicating with the server side.
  ///
  /// You can test the processing of the intended function by specifying a stubbed function in [functions].
  ///
  /// サーバー側と通信せずに正常系を返すだけの[FunctionsAdapter]。
  ///
  /// [functions]にスタブ化した関数を指定することで意図した関数の処理をテストすることができます。
  const RuntimeFunctionsAdapter({this.functions = const []});

  /// Stubbed functions.
  ///
  /// スタブ化した関数。
  final List<FunctionStub> functions;

  @override
  final String endpoint = "";

  @override
  Future<TResponse> execute<TResponse>(FunctionsAction<TResponse> action) {
    final stub = functions.firstWhereOrNull(
      (stub) => stub.functionName == action.action,
    );
    if (stub == null) {
      return action.execute((input) async => {});
    }
    return action.execute((input) async => stub.process(input ?? {}));
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
