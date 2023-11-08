part of '/masamune_purchase_mobile.dart';

/// InAppPurchase actions used in Functions.
///
/// Inherit and use.
///
/// Functionsで用いるInAppPurchaseのアクション。
///
/// 継承して使ってください。
abstract class PurchaseFunctionsAction
    extends FunctionsAction<PurchaseFunctionsActionResponse> {
  /// InAppPurchase actions used in Functions.
  ///
  /// Inherit and use.
  ///
  /// Functionsで用いるInAppPurchaseのアクション。
  ///
  /// 継承して使ってください。
  const PurchaseFunctionsAction();

  /// Validate [response]. If `true`, the validation succeeds; if `false`, the validation fails.
  ///
  /// [response]を検証します。`true`の場合は検証成功、`false`の場合は検証失敗となります。
  Future<bool> verify(DynamicMap? response);

  @override
  PurchaseFunctionsActionResponse toResponse(DynamicMap map) {
    throw UnimplementedError();
  }

  @override
  Future<PurchaseFunctionsActionResponse> execute(
    Future<DynamicMap?> Function(DynamicMap? map) callback,
  ) async {
    final input = toMap();
    final res = await callback.call({
      if (input != null) ...input,
    });
    if (res == null) {
      throw Exception("Response is empty.");
    }
    final result = await verify(res);
    return PurchaseFunctionsActionResponse(result: result);
  }
}

class PurchaseFunctionsActionResponse extends FunctionsActionResponse {
  const PurchaseFunctionsActionResponse({required this.result});

  final bool result;
}
