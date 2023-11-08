part of "/katana_indicator.dart";

/// Progress indicator to show progress via [ChangeNotifier].
///
/// Pass [ChangeNotifier] to [listenable] and a callback to return the rate of progress to [progress].
///
/// The value returned by [progress] should be between `0.0` and `1.0`.
///
/// Pass the actual widget to [builder].
///
/// By default, [defaultCircularProgressIndicator] is specified. Another option is [defaultLinearProgressIndicator].
///
/// [ChangeNotifier]を介して進行状況を表すプログレスインジケーターを表示します。
///
/// [listenable]に[ChangeNotifier]を渡し、[progress]に進行率を返すためのコールバックを渡します。
///
/// [progress]で返す値は`0.0`〜`1.0`の間で返してください。
///
/// [builder]に実際のウィジェットを渡します。
///
/// デフォルトだと[defaultCircularProgressIndicator]が指定されます。他に[defaultLinearProgressIndicator]も利用可能です。
class ProgressIndicatorBuilder<T extends Listenable> extends StatefulWidget {
  /// Progress indicator to show progress via [ChangeNotifier].
  ///
  /// Pass [ChangeNotifier] to [listenable] and a callback to return the rate of progress to [progress].
  ///
  /// The value returned by [progress] should be between `0.0` and `1.0`.
  ///
  /// Pass the actual indicator widget to [builder].
  ///
  /// By default, [defaultCircularProgressIndicator] is specified. Another option is [defaultLinearProgressIndicator].
  ///
  /// [ChangeNotifier]を介して進行状況を表すプログレスインジケーターを表示します。
  ///
  /// [listenable]に[ChangeNotifier]を渡し、[progress]に進行率を返すためのコールバックを渡します。
  ///
  /// [progress]で返す値は`0.0`〜`1.0`の間で返してください。
  ///
  /// [builder]に実際のインジケーターのウィジェットを渡します。
  ///
  /// デフォルトだと[defaultCircularProgressIndicator]が指定されます。他に[defaultLinearProgressIndicator]も利用可能です。
  const ProgressIndicatorBuilder({
    super.key,
    required this.listenable,
    required this.progress,
    this.builder = defaultCircularProgressIndicator,
  });

  /// ChangeNotifier] to be monitored.
  ///
  /// 監視する[ChangeNotifier]。
  final T listenable;

  /// Callback to return the rate of progress.
  ///
  /// Return between `0.0` and `1.0`.
  ///
  /// 進行率を返すためのコールバック。
  ///
  /// `0.0`〜`1.0`の間で返してください。
  final double Function(T listenable) progress;

  /// Pass the actual indicator widget to [builder].
  ///
  /// [builder]に実際のインジケーターのウィジェットを渡します。
  final Widget Function(double value) builder;

  /// Builder for displaying [CircularProgressIndicator].
  ///
  /// [CircularProgressIndicator]を表示するためのビルダー。
  static Widget defaultCircularProgressIndicator(double value) {
    return Center(
      child: CircularProgressIndicator(
        value: value,
        backgroundColor: Colors.white.withOpacity(
          0.5,
        ),
      ),
    );
  }

  /// Builder for displaying [LinearProgressIndicator].
  ///
  /// [LinearProgressIndicator]を表示するためのビルダー。
  static Widget defaultLinearProgressIndicator(double value) {
    return Center(
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: Colors.white.withOpacity(
          0.5,
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ProgressIndicatorBuilderState<T>();
}

class _ProgressIndicatorBuilderState<T extends Listenable>
    extends State<ProgressIndicatorBuilder<T>> {
  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_handledOnUpdate);
  }

  @override
  void didUpdateWidget(ProgressIndicatorBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenable != oldWidget.listenable) {
      oldWidget.listenable.removeListener(_handledOnUpdate);
      widget.listenable.addListener(_handledOnUpdate);
    }
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.listenable.addListener(_handledOnUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.progress(widget.listenable).limit(0, 1.0);
    return widget.builder(value);
  }
}
