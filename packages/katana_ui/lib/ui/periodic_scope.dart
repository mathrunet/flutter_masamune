part of "/katana_ui.dart";

/// This widget repeatedly redraws at regular intervals.
///
/// Draw [builder] at every interval of [duration].
///
/// 一定時間ごとに繰り返して再描画するウィジェットです。
///
/// [duration]の間隔ごとに[builder]を描画します。
class PeriodicScope extends StatefulWidget {
  /// This widget repeatedly redraws at regular intervals.
  ///
  /// Draw [builder] at every interval of [duration].
  ///
  /// 一定時間ごとに繰り返して再描画するウィジェットです。
  ///
  /// [duration]の間隔ごとに[builder]を描画します。
  const PeriodicScope({
    required this.duration,
    required this.builder,
    super.key,
  });

  /// Interval between drawings.
  ///
  /// 描画を行う間隔。
  final Duration duration;

  /// Builder for drawing.
  ///
  /// 描画を行うためのビルダー。
  final Widget Function(BuildContext context, DateTime now) builder;

  @override
  State<StatefulWidget> createState() => _PeriodicScopeState();
}

class _PeriodicScopeState extends State<PeriodicScope> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    final now = Clock.now();
    return widget.builder.call(context, now);
  }
}
