part of "/katana_test.dart";

/// Verify errors including Async.
///
/// The process that raises an Exception is passed to [process], and [onError] is passed what to do when the Exception is raised.
///
/// Asyncを含むエラーの検証を行います。
///
/// [process]にExceptionを発生させる処理を渡し、[onError]にはExceptionが発生した場合の処理を渡します。
Future<void> runGuardedErrorValidation(
  FutureOr<void> Function() process,
  void Function(Object error, StackTrace stackTrace) onError,
) async {
  Completer<void>? completer = Completer();
  runZonedGuarded(
    () async {
      await process();
      completer?.completeError("Should not be here");
      completer = null;
    },
    (error, stack) {
      completer?.complete();
      completer = null;
      onError(error, stack);
    },
  );
  await completer?.future;
}
