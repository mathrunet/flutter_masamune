part of masamune;

class _UIStream {
  const _UIStream._();

  static Future<void> show<T>(
    BuildContext context,
    Stream<T> stream, {
    required FutureOr<bool> Function(T value) onWillClose,
    required Widget Function(T value) builder,
    Color? barrierColor = Colors.black54,
    void Function()? actionOnFinish,
  }) async {
    final dialog = showDialog(
      context: context,
      barrierColor: barrierColor,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: StreamBuilder<T>(
              stream: stream,
              builder: (context, snapshot) {
                final val = snapshot.data;
                if (val == null) {
                  return const Empty();
                }
                final futureOr = onWillClose.call(val);
                if (futureOr is Future<bool>) {
                  futureOr.then((v) {
                    if (v) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    }
                  });
                } else {
                  if (futureOr) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context, rootNavigator: true).pop();
                    });
                  }
                }
                return builder.call(val);
              },
            ),
          ),
        );
      },
    );
    await dialog;
    actionOnFinish?.call();
  }
}

class ProgressIndicatorDialog extends StatelessWidget {
  const ProgressIndicatorDialog({
    this.title,
    required this.value,
    this.backgroundColor,
    this.color,
  });
  final Widget? title;
  final Color? color;
  final double value;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: context.mediaQuery.size.width / 1.5,
          color: context.theme.surfaceColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                title!,
                const Space.height(16),
              ],
              LinearProgressIndicator(
                value: value.limit(0.0, 1.0),
                color: color,
                backgroundColor: backgroundColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension methods for UIFuture.
extension UIDoubleStreamExtension on Stream<double?> {
  /// Show indicator and dialog.
  ///
  /// Display an indicator if you are waiting for the task to end.
  ///
  /// [context]: Build context.
  /// [actionOnFinish]: Action after the task is finished.
  Future<void> showProgressIndicator(
    BuildContext context, {
    Widget? title,
    Color? barrierColor = Colors.black54,
    void Function()? actionOnFinish,
  }) async {
    await _UIStream.show<double?>(
      context,
      this,
      builder: (val) => val != null
          ? ProgressIndicatorDialog(
              title: title,
              value: val,
            )
          : const Empty(),
      onWillClose: (val) => val == null || val >= 1.0,
      actionOnFinish: actionOnFinish,
      barrierColor: barrierColor,
    );
    await Future<void>.delayed(Duration.zero);
  }
}
