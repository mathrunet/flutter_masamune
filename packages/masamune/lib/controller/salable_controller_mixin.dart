part of "/masamune.dart";

/// Provides the ability to sell data from the controller.
///
/// Describe the data sale process in [saleRequest].
///
/// Sale data by calling [sale].
///
/// コントローラーにデータを販売する機能を提供します。
///
/// [saleRequest]にデータの販売処理を記述します。
///
/// [sale]を呼び出すことでデータを販売します。
mixin SalableControllerMixin on ChangeNotifier {
  /// Returns [Future] if saling is being performed.
  ///
  /// 販売を行っている場合に[Future]を返します。
  Future<void>? get saling => _salingCompleter?.future;
  Completer<void>? _salingCompleter;

  /// Describe the process for saling data.
  ///
  /// Return sold results.
  ///
  /// データを販売する場合の処理を記述します。
  ///
  /// 販売した結果を返してください。
  Future<void> saleRequest();

  /// Execute the process of [saleRequest] and sell data.
  ///
  /// Once content is sold, no new selling is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// [saleRequest]の処理を実行しデータを販売します。
  ///
  /// 一度販売したコンテンツに対しては、新しい販売は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  Future<void> sale() async {
    if (_salingCompleter != null) {
      return _salingCompleter!.future;
    }
    _salingCompleter = Completer<void>();
    try {
      await saleRequest();
      _salingCompleter?.complete();
      _salingCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _salingCompleter?.completeError(e, stacktrace);
      _salingCompleter = null;
      rethrow;
    } finally {
      _salingCompleter?.complete();
      _salingCompleter = null;
    }
  }
}
