part of '/katana_model.dart';

class _LoadTransactionMixin {
  final List<FutureOr<void> Function()> _transactionQueue = [];
  Completer<void>? _loadTransactionCompleter;

  Future<void> _runLoadTransactionInternal() async {
    if (_loadTransactionCompleter != null) {
      return _loadTransactionCompleter?.future;
    }
    try {
      _loadTransactionCompleter = Completer<void>();
      while (_transactionQueue.isNotEmpty) {
        final value = _transactionQueue.removeAt(0);
        await value.call();
      }
      _loadTransactionCompleter?.complete();
      _loadTransactionCompleter = null;
    } catch (e) {
      _loadTransactionCompleter?.completeError(e);
      _loadTransactionCompleter = null;
    } finally {
      _loadTransactionCompleter?.complete();
      _loadTransactionCompleter = null;
    }
  }

  Future<void> _enqueueToLoadTransaction(
    FutureOr<void> Function() process,
  ) async {
    _transactionQueue.add(process);
    await _runLoadTransactionInternal();
  }
}
