part of "/katana_model.dart";

mixin _InternalTransactionMixin {
  final List<Future<void> Function()> _transactionQueue = [];
  Completer<void>? _transactionCompleter;

  Future<void> _runInternalTransaction() async {
    if (_transactionCompleter != null) {
      return _transactionCompleter!.future;
    }
    _transactionCompleter = Completer<void>();
    try {
      while (_transactionQueue.isNotEmpty) {
        await _transactionQueue.removeAt(0).call();
      }
    } finally {
      _transactionCompleter!.complete();
      _transactionCompleter = null;
    }
  }

  Future<void> _enqueueInternalTransaction(
    FutureOr<void> Function() process,
  ) async {
    final owner = Zone.current;
    final completion = Completer<void>();
    // The operation may finish before the queue barrier. Keep its error
    // observed until this caller receives the original result below.
    completion.future.ignore();
    _transactionQueue.add(() {
      // Queue draining is shared, but each operation keeps its own result and
      // zone. A later save must not fail an earlier background reload.
      final drained = Completer<void>();
      owner.run(() {
        Future<void>.sync(process).then<void>(
          (_) {
            completion.complete();
            drained.complete();
          },
          onError: (Object error, StackTrace stackTrace) {
            completion.completeError(error, stackTrace);
            drained.complete();
          },
        );
      });
      return drained.future;
    });
    // Preserve the existing queue-drain barrier for successful callers, while
    // propagating only this operation's failure after draining has settled.
    await _runInternalTransaction();
    await completion.future;
  }
}
