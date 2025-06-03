part of "/masamune_purchase_stripe.dart";

/// Stripe actions used in Functions.
///
/// Inherit and use.
///
/// Functionsで用いるStripeのアクション。
///
/// 継承して使ってください。
abstract class StripeFunctionsAction<
        TResponse extends StripeFunctionsActionResponse>
    extends FunctionsAction<TResponse> {
  /// Stripe actions used in Functions.
  ///
  /// Inherit and use.
  ///
  /// Functionsで用いるStripeのアクション。
  ///
  /// 継承して使ってください。
  const StripeFunctionsAction();

  /// Mode of execution on the server side.
  ///
  /// サーバー側で実行するモード。
  String get mode;

  @override
  String get action => "stripe";

  @override
  Future<TResponse> execute(
    Future<DynamicMap?> Function(DynamicMap? map) callback,
  ) async {
    final input = toMap();
    final res = await callback.call({
      "mode": mode,
      if (input != null) ...input,
    });
    if (res == null) {
      return throw Exception("Response is empty.");
    }
    return toResponse(res);
  }
}

/// Class for defining the value returned when executed by [StripeFunctionsAction].
///
/// Inherit and use.
///
/// [StripeFunctionsAction]で実行されたときに返却された値を定義するためのクラス。
///
/// 継承して使ってください。
abstract class StripeFunctionsActionResponse extends FunctionsActionResponse {
  /// Class for defining the value returned when executed by [StripeFunctionsAction].
  ///
  /// Inherit and use.
  ///
  /// [StripeFunctionsAction]で実行されたときに返却された値を定義するためのクラス。
  ///
  /// 継承して使ってください。
  const StripeFunctionsActionResponse();
}
