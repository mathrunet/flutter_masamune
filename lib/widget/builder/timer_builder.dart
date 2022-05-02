part of masamune;

class TimerBuilder extends StatefulWidget {
  const TimerBuilder({
    required this.interval,
    required this.builder,
  });

  final Duration interval;
  final Widget Function(DateTime time) builder;

  @override
  State<StatefulWidget> createState() => _TimerBuilderState();
}

class _TimerBuilderState extends State<TimerBuilder> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer ??= Timer.periodic(
      widget.interval,
      _onTimer,
    );
  }

  void _onTimer(Timer timer) {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(DateTime.now());
  }
}
