part of "/katana_model.dart";

mixin _InternalTransactionMixin {
  final List<FutureOr<void> Function()> _transactionQueue = [];
  Completer<void>? _transactionCompleter;

  Future<void> _runInternalTransaction() async {
    if (_transactionCompleter != null) {
      return _transactionCompleter?.future;
    }
    try {
      _transactionCompleter = Completer<void>();
      while (_transactionQueue.isNotEmpty) {
        final value = _transactionQueue.removeAt(0);
        await value.call();
      }
      _transactionCompleter?.complete();
      _transactionCompleter = null;
    } catch (e, stacktrace) {
      _transactionCompleter?.completeError(e, stacktrace);
      _transactionCompleter = null;
      rethrow;
    } finally {
      _transactionCompleter?.complete();
      _transactionCompleter = null;
    }
  }

  Future<void> _enqueueInternalTransaction(
    FutureOr<void> Function() process,
  ) async {
    _transactionQueue.add(process);
    await _runInternalTransaction();
  }
}
