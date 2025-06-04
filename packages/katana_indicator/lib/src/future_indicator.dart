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
    DialogRoute<T>? route;
    Completer<void>? completer;
    if (futureOr is Future<T>) {
      completer = Completer<void>();
      var navigator = Navigator.of(context, rootNavigator: true);
      final rootContext = navigator.context;
      unawaited(
        futureOr.whenComplete(
          () async {
            completer?.complete();
            completer = null;
            if (route != null) {
              navigator.removeRoute(route!);
              route = null;
            }
          },
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (completer == null) {
          return;
        }
        try {
          final themes = InheritedTheme.capture(
            from: context,
            to: rootContext,
          );
          route = DialogRoute<T>(
            context: rootContext,
            builder: (_) {
              return PopScope(
                canPop: false,
                child: indicator ??
                    Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
              );
            },
            barrierColor: barrierColor,
            barrierDismissible: false,
            useSafeArea: true,
            themes: themes,
            traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
          );
          if (route != null) {
            navigator.push<T>(route!);
          }
        } catch (e) {
          completer?.completeError(e);
          completer = null;
        } finally {
          completer?.complete();
          completer = null;
        }
      });
      await completer?.future;
      final value = await this;
      return value;
    } else {
      return await this;
    }
  }
}

/// [process] and display the indicator during the process.
///
/// It is possible to change the color of the entire screen by specifying [barrierColor].
///
/// The indicator can be changed by specifying [indicator].
///
/// By default, [CircularProgressIndicator] is used.
///
/// [process]を実行しその間インジケーターを表示します。
///
/// [barrierColor]を指定して画面全体の色を変更することが可能です。
///
/// [indicator]を指定するとインジケーターを変更することが可能です。
///
/// デフォルトだと[CircularProgressIndicator]が利用されます。
Future<void> showIndicator(
  BuildContext context,
  FutureOr<void> Function() process, {
  Color? barrierColor = Colors.black54,
  Widget? indicator,
}) async {
  await process.call().showIndicator(
        context,
        barrierColor: barrierColor,
        indicator: indicator,
      );
}

/// [process] and display the indicator during the process.
///
/// If an error occurs, [onError] is called.
///
/// [barrierColor] can be specified to change the color of the entire screen.
///
/// [indicator] can be specified to change the indicator.
///
/// By default, [CircularProgressIndicator] is used.
///
/// [process]を実行しその間インジケーターを表示します。
///
/// エラーが発生した場合は[onError]を呼び出します。
///
/// [barrierColor]を指定して画面全体の色を変更することが可能です。
///
/// [indicator]を指定するとインジケーターを変更することが可能です。
///
/// デフォルトだと[CircularProgressIndicator]が利用されます。
Future<void> executeGuarded(
  BuildContext context,
  FutureOr<void> Function() process, {
  Color? barrierColor = Colors.black54,
  Widget? indicator,
  void Function(Object error, StackTrace stackTrace)? onError,
}) async {
  try {
    await showIndicator(
      context,
      process,
      barrierColor: barrierColor,
      indicator: indicator,
    );
  } catch (error, stackTrace) {
    debugPrint("$error\n$stackTrace");
    onError?.call(error, stackTrace);
  }
}
