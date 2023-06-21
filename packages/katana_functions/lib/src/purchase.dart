part of katana_functions;

/// InAppPurchase actions used in Functions.
///
/// Inherit and use.
///
/// Functionsで用いるInAppPurchaseのアクション。
///
/// 継承して使ってください。
abstract class PurchaseSettings {
  /// InAppPurchase actions used in Functions.
  ///
  /// Inherit and use.
  ///
  /// Functionsで用いるInAppPurchaseのアクション。
  ///
  /// 継承して使ってください。
  const PurchaseSettings();

  /// Action Name.
  ///
  /// アクション名。
  String get action;

  /// Convert to [DynamicMap] to pass values to the server side.
  ///
  /// サーバー側に値を渡すために[DynamicMap]に変換します。
  DynamicMap? toMap();

  /// Validate [response]. If `true`, the validation succeeds; if `false`, the validation fails.
  ///
  /// [response]を検証します。`true`の場合は検証成功、`false`の場合は検証失敗となります。
  Future<bool> verify(DynamicMap? response);

  /// The value is actually passed to the server side for execution. If `true`, the validation succeeds; if `false`, the validation fails.
  ///
  /// 実際にサーバー側に値を渡して実行します。`true`の場合は検証成功、`false`の場合は検証失敗となります。
  Future<bool> execute(
    Future<DynamicMap?> Function(DynamicMap? map) callback,
  ) async {
    final input = toMap();
    final res = await callback.call({
      if (input != null) ...input,
    });
    if (res.isEmpty) {
      return false;
    }
    return await verify(res);
  }
}
