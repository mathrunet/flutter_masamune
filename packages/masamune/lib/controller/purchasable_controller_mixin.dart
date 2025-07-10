part of "/masamune.dart";

/// Provides the ability to purchase data from the controller.
///
/// Describe the data purchase process in [purchaseRequest].
///
/// Purchase data by calling [purchase].
///
/// コントローラーにデータを購入する機能を提供します。
///
/// [purchaseRequest]にデータの購入処理を記述します。
///
/// [purchase]を呼び出すことでデータを購入します。
mixin PurchasableControllerMixin on ChangeNotifier {
  /// Returns [Future] if purchasing is being performed.
  ///
  /// 購入を行っている場合に[Future]を返します。
  Future<void>? get purchasing => _purchasingCompleter?.future;
  Completer<void>? _purchasingCompleter;

  /// Describe the process for purchasing data.
  ///
  /// Return purchased results.
  ///
  /// データを購入する場合の処理を記述します。
  ///
  /// 購入した結果を返してください。
  Future<void> purchaseRequest();

  /// Execute the process of [purchaseRequest] and purchase data.
  ///
  /// Once content is purchased, no new purchasing is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// [purchaseRequest]の処理を実行しデータを購入します。
  ///
  /// 一度購入したコンテンツに対しては、新しい購入は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  Future<void> purchase() async {
    if (_purchasingCompleter != null) {
      return _purchasingCompleter!.future;
    }
    _purchasingCompleter = Completer<void>();
    try {
      await purchaseRequest();
      _purchasingCompleter?.complete();
      _purchasingCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _purchasingCompleter?.completeError(e, stacktrace);
      _purchasingCompleter = null;
      rethrow;
    } finally {
      _purchasingCompleter?.complete();
      _purchasingCompleter = null;
    }
  }
}
