part of "/masamune.dart";

/// Provides the ability to delete data from the controller.
///
/// Describe the data deletion process in [deleteRequest].
///
/// Delete data by calling [delete].
///
/// コントローラーにデータを削除する機能を提供します。
///
/// [deleteRequest]にデータの削除処理を記述します。
///
/// [delete]を呼び出すことでデータを削除します。
mixin DeletableControllerMixin on ChangeNotifier {
  /// Returns [Future] if deleting is being performed.
  ///
  /// 削除を行っている場合に[Future]を返します。
  Future<void>? get deleting => _deletingCompleter?.future;
  Completer<void>? _deletingCompleter;

  /// Describe the process for deleting data.
  ///
  /// Return deleted results.
  ///
  /// データを削除する場合の処理を記述します。
  ///
  /// 削除した結果を返してください。
  Future<void> deleteRequest();

  /// Execute the process of [deleteRequest] and delete data.
  ///
  /// Once content is deleted, no new deleting is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// [deleteRequest]の処理を実行しデータを削除します。
  ///
  /// 一度削除したコンテンツに対しては、新しい削除は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  Future<void> delete() async {
    if (_deletingCompleter != null) {
      return _deletingCompleter!.future;
    }
    _deletingCompleter = Completer<void>();
    try {
      await deleteRequest();
      _deletingCompleter?.complete();
      _deletingCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _deletingCompleter?.completeError(e, stacktrace);
      _deletingCompleter = null;
      rethrow;
    } finally {
      _deletingCompleter?.complete();
      _deletingCompleter = null;
    }
  }
}
