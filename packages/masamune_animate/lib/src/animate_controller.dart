part of "/masamune_animate.dart";

/// Controller that controls the animation.
///
/// Set the animation scenario to [scenario] and call [play] to play the animation.
///
/// If [autoPlay] is true, the animation will play automatically when the widget is built.
///
/// If [repeat] is true, the animation will be played again when it ends.
///
/// Set the number of times to play the animation in [repeatCount].
///
/// Set the key that triggers the widget to be rebuilt in [keys].
///
/// You can play the animation by passing the controller to [AnimateScope] or [AnimateScopeBuilder].
///
/// アニメーションを制御するコントローラー。
///
/// [scenario]にアニメーションのシナリオを設定し、[play]を呼び出すことでアニメーションを再生します。
///
/// [autoPlay]がtrueの場合、ウィジェットがビルドされた際に自動的にアニメーションが再生されます。
///
/// [repeat]がtrueの場合、アニメーションが終了した際に再度アニメーションを再生します。
///
/// [repeatCount]に再生回数を設定することで、指定回数アニメーションを再生します。
///
/// [keys]にウィジェットの再ビルドをトリガーとするキーを設定します。
///
/// [AnimateScope]または[AnimateScopeBuilder]にコントローラーを渡すことで、アニメーションを再生することができます。
class AnimateController
    extends MasamuneControllerBase<void, AnimateMasamuneAdapter>
    implements AnimateRunner {
  /// Controller that controls the animation.
  ///
  /// Set the animation scenario to [scenario] and call [play] to play the animation.
  ///
  /// If [autoPlay] is true, the animation will play automatically when the widget is built.
  ///
  /// If [repeat] is true, the animation will be played again when it ends.
  ///
  /// Set the number of times to play the animation in [repeatCount].
  ///
  /// Set the key that triggers the widget to be rebuilt in [keys].
  ///
  /// You can play the animation by passing the controller to [AnimateScope] or [AnimateScopeBuilder].
  ///
  /// アニメーションを制御するコントローラー。
  ///
  /// [scenario]にアニメーションのシナリオを設定し、[play]を呼び出すことでアニメーションを再生します。
  ///
  /// [autoPlay]がtrueの場合、ウィジェットがビルドされた際に自動的にアニメーションが再生されます。
  ///
  /// [repeat]がtrueの場合、アニメーションが終了した際に再度アニメーションを再生します。
  ///
  /// [repeatCount]に再生回数を設定することで、指定回数アニメーションを再生します。
  ///
  /// [keys]にウィジェットの再ビルドをトリガーとするキーを設定します。
  ///
  /// [AnimateScope]または[AnimateScopeBuilder]にコントローラーを渡すことで、アニメーションを再生することができます。
  AnimateController({
    required this.scenario,
    this.autoPlay = false,
    bool repeat = false,
    this.repeatCount,
    this.keys = const [],
  }) : _repeat = repeat;

  AnimateController._withVsync({
    required TickerProvider vsync,
    required this.scenario,
    this.autoPlay = false,
    bool repeat = false,
    this.repeatCount,
    this.keys = const [],
  }) : _repeat = repeat {
    _initialize(vsync);
  }

  @override
  AnimateMasamuneAdapter get primaryAdapter => AnimateMasamuneAdapter.primary;

  @override
  bool get isTest => primaryAdapter.isTest;

  /// Whether to play the animation automatically when the widget is built.
  ///
  /// ウィジェットがビルドされた際にアニメーションを自動的に再生するかどうか。
  final bool autoPlay;

  /// Whether to play the animation again when it ends.
  ///
  /// アニメーションが終了した際に再度アニメーションを再生するかどうか。
  bool get repeat {
    if (primaryAdapter.isTest) {
      return false;
    }
    return _repeat;
  }

  final bool _repeat;

  /// Key that triggers the widget to be rebuilt.
  ///
  /// ウィジェットの再ビルドをトリガーとするキー。
  final List<Object> keys;

  /// Number of times to play the animation when repeating. If [Null], the animation will play indefinitely.
  ///
  /// アニメーションをリピートする際の再生する回数。[Null]の場合は無限に再生します。
  final int? repeatCount;

  /// Animation Scenario. Specify the animation to be played by hitting the method for [runner].
  ///
  /// アニメーションのシナリオ。[runner]に対してメソッドを叩き再生するアニメーションの指定を行います。
  final FutureOr<void> Function(AnimateRunner runner) scenario;

  /// Whether the animation is playing.
  ///
  /// アニメーションが再生中かどうか。
  bool get playing => _ticker?.isActive ?? false;

  /// Whether the animation is complete.
  ///
  /// アニメーションが完了したかどうか。
  bool get completed => _completed;
  bool _completed = false;

  /// Elapsed time of the animation.
  ///
  /// アニメーションの経過時間。
  Duration get elapsedDuration => _elapsedDuration ?? Duration.zero;
  Duration? _elapsedDuration;

  TickerProvider? _vsync;
  Ticker? _ticker;
  bool _disposed = false;
  final List<_AnimateQueryContainer> _queryStack = [];
  final _AnimateControllerNotifier _internalNotifier =
      _AnimateControllerNotifier();
  Widget? _latestChild;

  void _initialize(TickerProvider vsync) {
    if (_vsync == vsync && _ticker != null) {
      return;
    }
    _vsync = vsync;
    _ticker?.dispose();
    _ticker = _vsync?.createTicker(_handledOnTick);
  }

  /// Playback the animation. Playback takes place from the beginning of the scenario.
  ///
  /// アニメーションを再生します。再生はシナリオの最初から行われます。
  Future<void> play() async {
    assert(
      _vsync != null,
      "Vsync is null. Pass the controller to [AnimateScope] or [AnimateScopeBuilder].",
    );
    try {
      var count = 0;
      _completed = false;
      _elapsedDuration = null;
      if (playing) {
        _ticker?.stop(canceled: true);
      }
      unawaited(_ticker?.start());
      do {
        _queryStack.clear();
        if (adapter.isTest) {
          try {
            final future = scenario.call(this);
            if (future is Future) {
              await future.timeout(adapter.timeoutDurationOnTest);
            }
          } catch (e) {
            // Ignore errors
          }
        } else {
          await scenario.call(this);
        }
        count++;
        if (repeat) {
          _completed = false;
        }
      } while (repeat && (repeatCount == null || count < repeatCount!));
      _completed = true;
      _ticker?.stop();
      notifyListeners();
    } on AnimateControllerCancelException {
      _ticker?.stop(canceled: true);
      notifyListeners();
    } catch (e) {
      _ticker?.stop(canceled: true);
      notifyListeners();
      rethrow;
    }
  }

  /// Stop the animation.
  ///
  /// アニメーションを停止します。
  void stop() {
    _ticker?.stop();
    notifyListeners();
  }

  @override
  Future<void> runAnimateQuery(AnimateQuery query) async {
    final container = _AnimateQueryContainer(
      query: query,
      startDuration: elapsedDuration,
    );
    _queryStack.add(container);
    await container._future;
  }

  Widget _build(BuildContext context, Widget child) {
    var isChanged = false;
    for (final query in _queryStack) {
      final duration = elapsedDuration - query.startDuration;
      if (duration < Duration.zero) {
        continue;
      }
      isChanged = true;
      child = query.query._build(context, duration, child);
    }
    if (!isChanged && _latestChild != null) {
      return _latestChild!;
    }
    _latestChild = child;
    if (!isTest) {
      return child;
    }
    return TickerMode(
      enabled: !isTest,
      child: child,
    );
  }

  static bool _equalsKeys(List<Object> keys1, List<Object> keys2) {
    if (keys1 == keys2) {
      return true;
    }
    if (keys1.length != keys2.length) {
      return false;
    }

    final i1 = keys1.iterator;
    final i2 = keys2.iterator;
    while (true) {
      if (!i1.moveNext() || !i2.moveNext()) {
        return true;
      }
      if (i1.current != i2.current) {
        return false;
      }
    }
  }

  void _handledOnTick(Duration elapsedDuration) {
    if (_disposed) {
      return;
    }
    _elapsedDuration = elapsedDuration;
    _queryStack.removeWhere(
      (query) => !query._setDuration(elapsedDuration),
    );
    _internalNotifier.notify();
  }

  @override
  void notifyListeners() {
    if (_disposed) {
      return;
    }
    _internalNotifier.notify();
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.dispose();
    _queryStack.clear();
    super.dispose();
  }
}

/// Passed when an animation is canceled [Exception].
///
/// アニメーションがキャンセルされたときに渡される[Exception]。
@immutable
class AnimateControllerCancelException implements Exception {
  /// Passed when an animation is canceled [Exception].
  ///
  /// アニメーションがキャンセルされたときに渡される[Exception]。
  const AnimateControllerCancelException();
}

@immutable
class _AnimateQueryContainer {
  _AnimateQueryContainer({
    required this.query,
    required this.startDuration,
  }) : _completer = Completer<void>();

  final AnimateQuery query;
  final Duration startDuration;

  Future<void> get _future => _completer.future;
  final Completer<void> _completer;

  bool _setDuration(Duration duration) {
    if (_completer.isCompleted) {
      return false;
    }
    if (duration >= startDuration + query.duration) {
      _completer.complete();
      return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => query.hashCode ^ startDuration.hashCode;

  @override
  String toString() {
    return "$runtimeType(query: $query, startDuration: $startDuration)";
  }
}

class _AnimateControllerNotifier extends ChangeNotifier {
  _AnimateControllerNotifier();

  void notify() {
    notifyListeners();
  }
}
