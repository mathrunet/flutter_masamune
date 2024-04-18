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
  /// Use as a test stub.
  ///
  /// サーバー側と通信せずに正常系を返すだけの[FunctionsAdapter]。
  ///
  /// テスト用のスタブとして利用してください。
  const RuntimeFunctionsAdapter();

  @override
  final String endpoint = "";

  @override
  Future<TResponse> execute<TResponse>(FunctionsAction<TResponse> action) =>
      action.execute((map) async => {});

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
