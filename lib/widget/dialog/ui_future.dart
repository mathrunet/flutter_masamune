part of masamune;

class _UIFuture {
  static Future<T?> show<T>(
    BuildContext context,
    Future<T> future, {
    void Function(T? value)? actionOnFinish,
  }) async {
    T? val;
    final dialog = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: context.widgetTheme.loadingIndicator
                    ?.call(context, Colors.white.withOpacity(0.5)) ??
                LoadingBouncingGrid.square(
                  backgroundColor: Colors.white.withOpacity(0.5),
                ),
          ),
        );
      },
    );
    future.then((v) => val = v).whenComplete(
      () async {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    await dialog;
    actionOnFinish?.call(val);
    return val;
  }
}

/// Extension methods for UIFuture.
extension UIFutureExtension<T> on Future<T> {
  /// Show indicator and dialog.
  ///
  /// Display an indicator if you are waiting for the task to end.
  ///
  /// [context]: Build context.
  /// [actionOnFinish]: Action after the task is finished.
  Future<T?> showIndicator(
    BuildContext context, {
    void Function(T? value)? actionOnFinish,
  }) async {
    await Future<void>.delayed(Duration.zero);
    _UIFuture.show<T>(context, this, actionOnFinish: actionOnFinish);
    final value = await this;
    await Future<void>.delayed(Duration.zero);
    return value;
  }
}
