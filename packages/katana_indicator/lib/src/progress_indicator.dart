part of "/katana_indicator.dart";

/// A circular progress indicator whose visible lifetime is logged as an
/// indicator performance trace.
///
/// 表示されている時間をインジケーターのパフォーマンストレースとして記録する
/// 円形プログレスインジケーター。
class MeasuredCircularProgressIndicator extends StatefulWidget {
  /// Creates a measured circular progress indicator.
  ///
  /// 計測可能な円形プログレスインジケーターを作成します。
  const MeasuredCircularProgressIndicator({
    required this.traceName,
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.strokeWidth,
    this.strokeAlign,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeCap,
    this.constraints,
    this.trackGap,
    this.padding,
    this.controller,
  }) : _adaptive = false;

  /// Creates a measured adaptive circular progress indicator.
  ///
  /// 計測可能なアダプティブ円形プログレスインジケーターを作成します。
  const MeasuredCircularProgressIndicator.adaptive({
    required this.traceName,
    super.key,
    this.value,
    this.backgroundColor,
    this.valueColor,
    this.strokeWidth,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeCap,
    this.strokeAlign,
    this.constraints,
    this.trackGap,
    this.padding,
    this.controller,
  })  : color = null,
        _adaptive = true;

  /// Stable, non-sensitive name used to identify this waiting state.
  ///
  /// この待機状態を識別する、固定かつ機密情報を含まない名前。
  final String traceName;

  /// Current progress, or null for indeterminate progress.
  final double? value;

  /// Background color of the progress track.
  final Color? backgroundColor;

  /// Color of the progress indicator.
  final Color? color;

  /// Animated color of the progress indicator.
  final Animation<Color?>? valueColor;

  /// Width of the circular stroke.
  final double? strokeWidth;

  /// Alignment of the circular stroke.
  final double? strokeAlign;

  /// Semantic label for accessibility.
  final String? semanticsLabel;

  /// Semantic value for accessibility.
  final String? semanticsValue;

  /// Shape of the stroke ends.
  final StrokeCap? strokeCap;

  /// Size constraints of the indicator.
  final BoxConstraints? constraints;

  /// Gap between the active indicator and its track.
  final double? trackGap;

  /// Padding around the indicator track.
  final EdgeInsetsGeometry? padding;

  /// Optional controller for indeterminate animation.
  final AnimationController? controller;

  final bool _adaptive;

  @override
  State<MeasuredCircularProgressIndicator> createState() =>
      _MeasuredCircularProgressIndicatorState();
}

class _MeasuredCircularProgressIndicatorState
    extends State<MeasuredCircularProgressIndicator> {
  final _traceLifecycle = _IndicatorTraceLifecycle();

  @override
  void initState() {
    super.initState();
    _traceLifecycle.start(widget.traceName);
  }

  @override
  void didUpdateWidget(MeasuredCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.traceName != oldWidget.traceName) {
      _traceLifecycle.start(widget.traceName);
    }
  }

  @override
  void dispose() {
    _traceLifecycle.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._adaptive) {
      return CircularProgressIndicator.adaptive(
        value: widget.value,
        backgroundColor: widget.backgroundColor,
        valueColor: widget.valueColor,
        strokeWidth: widget.strokeWidth,
        semanticsLabel: widget.semanticsLabel,
        semanticsValue: widget.semanticsValue,
        strokeCap: widget.strokeCap,
        strokeAlign: widget.strokeAlign,
        constraints: widget.constraints,
        trackGap: widget.trackGap,
        padding: widget.padding,
        controller: widget.controller,
      );
    }
    return CircularProgressIndicator(
      value: widget.value,
      backgroundColor: widget.backgroundColor,
      color: widget.color,
      valueColor: widget.valueColor,
      strokeWidth: widget.strokeWidth,
      strokeAlign: widget.strokeAlign,
      semanticsLabel: widget.semanticsLabel,
      semanticsValue: widget.semanticsValue,
      strokeCap: widget.strokeCap,
      constraints: widget.constraints,
      trackGap: widget.trackGap,
      padding: widget.padding,
      controller: widget.controller,
    );
  }
}

/// A linear progress indicator whose visible lifetime is logged as an
/// indicator performance trace.
///
/// 表示されている時間をインジケーターのパフォーマンストレースとして記録する
/// 線形プログレスインジケーター。
class MeasuredLinearProgressIndicator extends StatefulWidget {
  /// Creates a measured linear progress indicator.
  ///
  /// 計測可能な線形プログレスインジケーターを作成します。
  const MeasuredLinearProgressIndicator({
    required this.traceName,
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.minHeight,
    this.semanticsLabel,
    this.semanticsValue,
    this.borderRadius,
    this.stopIndicatorColor,
    this.stopIndicatorRadius,
    this.trackGap,
    this.controller,
  });

  /// Stable, non-sensitive name used to identify this waiting state.
  final String traceName;

  /// Current progress, or null for indeterminate progress.
  final double? value;

  /// Background color of the progress track.
  final Color? backgroundColor;

  /// Color of the progress indicator.
  final Color? color;

  /// Animated color of the progress indicator.
  final Animation<Color?>? valueColor;

  /// Minimum height of the progress line.
  final double? minHeight;

  /// Semantic label for accessibility.
  final String? semanticsLabel;

  /// Semantic value for accessibility.
  final String? semanticsValue;

  /// Border radius of the indicator and track.
  final BorderRadiusGeometry? borderRadius;

  /// Color of the stop indicator.
  final Color? stopIndicatorColor;

  /// Radius of the stop indicator.
  final double? stopIndicatorRadius;

  /// Gap between the active indicator and its track.
  final double? trackGap;

  /// Optional controller for indeterminate animation.
  final AnimationController? controller;

  @override
  State<MeasuredLinearProgressIndicator> createState() =>
      _MeasuredLinearProgressIndicatorState();
}

class _MeasuredLinearProgressIndicatorState
    extends State<MeasuredLinearProgressIndicator> {
  final _traceLifecycle = _IndicatorTraceLifecycle();

  @override
  void initState() {
    super.initState();
    _traceLifecycle.start(widget.traceName);
  }

  @override
  void didUpdateWidget(MeasuredLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.traceName != oldWidget.traceName) {
      _traceLifecycle.start(widget.traceName);
    }
  }

  @override
  void dispose() {
    _traceLifecycle.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: widget.value,
      backgroundColor: widget.backgroundColor,
      color: widget.color,
      valueColor: widget.valueColor,
      minHeight: widget.minHeight,
      semanticsLabel: widget.semanticsLabel,
      semanticsValue: widget.semanticsValue,
      borderRadius: widget.borderRadius,
      stopIndicatorColor: widget.stopIndicatorColor,
      stopIndicatorRadius: widget.stopIndicatorRadius,
      trackGap: widget.trackGap,
      controller: widget.controller,
    );
  }
}

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
    required this.listenable,
    required this.progress,
    super.key,
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
      child: MeasuredCircularProgressIndicator(
        traceName: "ProgressIndicatorBuilder.circular",
        value: value,
        backgroundColor: Colors.white.withValues(
          alpha: 0.5,
        ),
      ),
    );
  }

  /// Builder for displaying [LinearProgressIndicator].
  ///
  /// [LinearProgressIndicator]を表示するためのビルダー。
  static Widget defaultLinearProgressIndicator(double value) {
    return Center(
      child: MeasuredLinearProgressIndicator(
        traceName: "ProgressIndicatorBuilder.linear",
        value: value,
        backgroundColor: Colors.white.withValues(
          alpha: 0.5,
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
