part of '/katana_functions.dart';

/// An interface for executing server-side processing.
///
/// If the adapter is properly configured in [FunctionsAdapterScope], server-side communication can be performed inside the method to obtain the appropriate response.
///
/// You can also specify individual adapters by passing them to [adapter].
///
/// サーバー側の処理を実行するためのインターフェース。
///
/// [FunctionsAdapterScope]でアダプターを適切に設定しておくとメソッドの内部でサーバー側の通信を行い適切なレスポンスを得ることができます。
///
/// また[adapter]に渡すことで個別にアダプターを指定することができます。
class Functions extends ChangeNotifier {
  /// An interface for executing server-side processing.
  ///
  /// If the adapter is properly configured in [FunctionsAdapterScope], server-side communication can be performed inside the method to obtain the appropriate response.
  ///
  /// You can also specify individual adapters by passing them to [adapter].
  ///
  /// サーバー側の処理を実行するためのインターフェース。
  ///
  /// [FunctionsAdapterScope]でアダプターを適切に設定しておくとメソッドの内部でサーバー側の通信を行い適切なレスポンスを得ることができます。
  ///
  /// また[adapter]に渡すことで個別にアダプターを指定することができます。
  Functions({FunctionsAdapter? adapter}) : _adapter = adapter;

  /// An adapter that defines the platform of the server.
  ///
  /// サーバーのプラットフォームを定義するアダプター。
  FunctionsAdapter get adapter {
    return FunctionsAdapter._test ?? _adapter ?? FunctionsAdapter.primary;
  }

  final FunctionsAdapter? _adapter;

  /// Functions defined in the action can be executed by passing [FunctionsAction].
  ///
  /// The corresponding Function must be running in [adapter], such as on the server side.
  ///
  /// [FunctionsAction]を渡すことでアクションに定義されたFunctionを実行することができます。
  ///
  /// サーバー側など[adapter]にそれに対応したFunctionが動作している必要があります。
  Future<TResponse?> execute<TResponse>(
      FunctionsAction<TResponse> action) async {
    try {
      final res = await adapter.execute(action);
      notifyListeners();
      return res;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
