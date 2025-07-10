part of "/masamune.dart";

/// Provides the ability to load data into the controller.
///
/// Describe the data saving process in [saveRequest].
///
/// Save data by calling [save].
///
/// コントローラーにデータをセーブする機能を提供します。
///
/// [saveRequest]にデータのセーブ処理を記述します。
///
/// [save]を呼び出すことでデータをセーブします。
mixin SavableControllerMixin on ChangeNotifier {
  /// Returns [Future] if saving is being performed.
  ///
  /// セーブを行っている場合に[Future]を返します。
  Future<void>? get saving => _savingCompleter?.future;
  Completer<void>? _savingCompleter;

  /// Describe the process for saving data.
  ///
  /// Return saved results.
  ///
  /// データをセーブする場合の処理を記述します。
  ///
  /// セーブした結果を返してください。
  Future<void> saveRequest();

  /// Execute the process of [saveRequest] and save data.
  ///
  /// Once content is saved, no new saving is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// [saveRequest]の処理を実行しデータをセーブします。
  ///
  /// 一度セーブしたコンテンツに対しては、新しいセーブは行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  Future<void> save() async {
    if (_savingCompleter != null) {
      return _savingCompleter!.future;
    }
    _savingCompleter = Completer<void>();
    try {
      await saveRequest();
      _savingCompleter?.complete();
      _savingCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _savingCompleter?.completeError(e, stacktrace);
      _savingCompleter = null;
      rethrow;
    } finally {
      _savingCompleter?.complete();
      _savingCompleter = null;
    }
  }
}
