part of katana_functions;

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
  Future<void> sendMailByGmail({
    required String from,
    required String to,
    required String title,
    required String content,
  }) =>
      Future.value();

  @override
  Future<void> sendMailBySendGrid({
    required String from,
    required String to,
    required String title,
    required String content,
  }) =>
      Future.value();
}
