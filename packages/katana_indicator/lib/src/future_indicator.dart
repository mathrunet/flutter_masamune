part of "/katana_indicator.dart";

/// Extension to display Indicator in [FutureOr].
///
/// [FutureOr]でIndicatorを表示するためのエクステンション。
extension FutureIndicatorExtensions<T> on FutureOr<T> {
  /// Indicators are displayed for [Future] and [FutureOr].
  ///
  /// Blocks user operation until [Future] is finished. Darkens the screen and displays an indicator in the center.
  ///
  /// It is possible to change the color of the entire screen by specifying [barrierColor].
  ///
  /// The indicator can be changed by specifying [indicator].
  ///
  /// By default, [CircularProgressIndicator] is used.
  ///
  /// [Future]や[FutureOr]に対してインジケーターを表示します。
  ///
  /// [Future]が終了するまで、ユーザーの操作をブロック。画面を暗くして中央にインジケーターを表示します。
  ///
  /// [barrierColor]を指定して画面全体の色を変更することが可能です。
  ///
  /// [indicator]を指定するとインジケーターを変更することが可能です。
  ///
  /// デフォルトだと[CircularProgressIndicator]が利用されます。
  ///
  /// ```dart
  /// Future.delayed(const Duration(seconds: 1)).showIndicator(context);
  /// ```
  FutureOr<T?> showIndicator(
    BuildContext context, {
    Color? barrierColor = Colors.black54,
    Widget? indicator,
  }) async {
    final futureOr = this;
    if (futureOr is Future<T>) {
      final navigator = Navigator.of(context, rootNavigator: true);
      final dialog = showDialog(
        context: context,
        barrierColor: barrierColor,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: indicator ??
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(
                      0.5,
                    ),
                  ),
                ),
          );
        },
      );
      futureOr.whenComplete(
        () async {
          navigator.pop();
        },
      );
      await dialog;
      final value = await this;
      await Future<void>.delayed(Duration.zero);
      return value;
    } else {
      return await this;
    }
  }
}
