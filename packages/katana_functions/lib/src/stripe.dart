part of katana_functions;

/// Stripe actions used in Functions.
///
/// Inherit and use.
///
/// Functionsで用いるStripeのアクション。
///
/// 継承して使ってください。
abstract class StripePurchaseAction<
    TResponse extends StripePurchaseActionResponse> {
  /// Stripe actions used in Functions.
  ///
  /// Inherit and use.
  ///
  /// Functionsで用いるStripeのアクション。
  ///
  /// 継承して使ってください。
  const StripePurchaseAction();

  /// Mode of execution on the server side.
  ///
  /// サーバー側で実行するモード。
  String get mode;

  /// Convert to [DynamicMap] to pass values to the server side.
  ///
  /// サーバー側に値を渡すために[DynamicMap]に変換します。
  DynamicMap? toMap();

  /// Converts the value returned from the server side to [TResponse].
  ///
  /// サーバー側から返却された値を[TResponse]に変換します。
  TResponse? toResponse(DynamicMap map);

  /// The value is actually passed to the server side for execution.
  ///
  /// 実際にサーバー側に値を渡して実行します。
  Future<TResponse?> execute(
    Future<DynamicMap?> Function(DynamicMap? map) callback,
  ) async {
    final input = toMap();
    final res = await callback.call({
      "mode": mode,
      if (input != null) ...input,
    });
    if (res.isEmpty) {
      return null;
    }
    return toResponse(res!);
  }
}

/// Class for defining the value returned when executed by [StripePurchaseAction].
///
/// Inherit and use.
///
/// [StripePurchaseAction]で実行されたときに返却された値を定義するためのクラス。
///
/// 継承して使ってください。
abstract class StripePurchaseActionResponse {
  /// Class for defining the value returned when executed by [StripePurchaseAction].
  ///
  /// Inherit and use.
  ///
  /// [StripePurchaseAction]で実行されたときに返却された値を定義するためのクラス。
  ///
  /// 継承して使ってください。
  const StripePurchaseActionResponse();
}
