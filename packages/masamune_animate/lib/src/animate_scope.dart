part of "/masamune_animate.dart";

/// Widget for playing animations.
///
/// The widget passed to [child] will be the target of the animation.
///
/// Pass [controller] or [scenario] to set up the animation scenario.
///
/// If [autoPlay] is true, the animation will automatically play when the widget is built.
///
/// If [repeat] is true, the animation is replayed when the animation ends.
///
/// Set the number of times the animation is played to [repeatCount] to play the animation a specified number of times.
///
/// Set the key that triggers the widget rebuild in [keys].
///
/// アニメーションをプレイするためのウィジェット。
///
/// [child]に渡されたウィジェットがアニメーションの対象になります。
///
/// [controller]もしくは[scenario]を渡してアニメーションのシナリオを設定します。
///
/// [autoPlay]がtrueの場合、ウィジェットがビルドされた際に自動的にアニメーションが再生されます。
///
/// [repeat]がtrueの場合、アニメーションが終了した際に再度アニメーションを再生します。
///
/// [repeatCount]に再生回数を設定することで、指定回数アニメーションを再生します。
///
/// [keys]にウィジェットの再ビルドをトリガーとするキーを設定します。
@immutable
class AnimateScope extends StatefulWidget {
  /// Widget for playing animations.
  ///
  /// The widget passed to [child] will be the target of the animation.
  ///
  /// Pass [controller] or [scenario] to set up the animation scenario.
  ///
  /// If [autoPlay] is true, the animation will automatically play when the widget is built.
  ///
  /// If [repeat] is true, the animation is replayed when the animation ends.
  ///
  /// Set the number of times the animation is played to [repeatCount] to play the animation a specified number of times.
  ///
  /// Set the key that triggers the widget rebuild in [keys].
  ///
  /// アニメーションをプレイするためのウィジェット。
  ///
  /// [child]に渡されたウィジェットがアニメーションの対象になります。
  ///
  /// [controller]もしくは[scenario]を渡してアニメーションのシナリオを設定します。
  ///
  /// [autoPlay]がtrueの場合、ウィジェットがビルドされた際に自動的にアニメーションが再生されます。
  ///
  /// [repeat]がtrueの場合、アニメーションが終了した際に再度アニメーションを再生します。
  ///
  /// [repeatCount]に再生回数を設定することで、指定回数アニメーションを再生します。
  ///
  /// [keys]にウィジェットの再ビルドをトリガーとするキーを設定します。
  const AnimateScope({
    super.key,
    this.child,
    this.scenario,
    this.controller,
    this.autoPlay = false,
    this.repeat = false,
    this.repeatCount,
    this.keys = const [],
  })  : assert(
          controller != null || scenario != null,
          "[controller] or [scenario] is required.",
        ),
        assert(
          (controller != null && scenario == null) ||
              (scenario != null && controller == null),
          "Only one of [controller] or [scenario] can be set.",
        );

  /// Widget to be animated.
  ///
  /// アニメーション対象となるウィジェット。
  final Widget? child;

  /// Whether to play the animation automatically when the widget is built.
  ///
  /// ウィジェットがビルドされた際にアニメーションを自動的に再生するかどうか。
  final bool autoPlay;

  /// Whether to play the animation again when it ends.
  ///
  /// アニメーションが終了した際に再度アニメーションを再生するかどうか。
  final bool repeat;

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
  /// Used only when [controller] is not set.
  ///
  /// アニメーションのシナリオ。[runner]に対してメソッドを叩き再生するアニメーションの指定を行います。
  ///
  /// [controller]が設定されていないときにのみ使用されます。
  final FutureOr<void> Function(AnimateRunner runner)? scenario;

  /// Controller that controls the animation.
  ///
  /// Only used when [scenario] is not set.
  ///
  /// アニメーションを制御するコントローラー。
  ///
  /// [scenario]が設定されていないときにのみ使用されます。
  final AnimateController? controller;

  List<Object> get _effectiveKeys =>
      controller != null ? controller!.keys : keys;

  @override
  State<AnimateScope> createState() => _AnimateScopeState();
}

class _AnimateScopeState extends State<AnimateScope>
    with TickerProviderStateMixin {
  AnimateController get _effectiveController {
    if (widget.controller != null) {
      return widget.controller!.._initialize(this);
    }
    return _controller ??= AnimateController._withVsync(
      vsync: this,
      scenario: widget.scenario!,
      autoPlay: widget.autoPlay,
      repeat: widget.repeat,
      repeatCount: widget.repeatCount,
      keys: widget.keys,
    );
  }

  AnimateController? _controller;

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  void didUpdateWidget(covariant AnimateScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._internalNotifier.removeListener(_handeldOnUpdate);
      _onInit();
    } else if (!AnimateController._equalsKeys(
        widget._effectiveKeys, oldWidget._effectiveKeys)) {
      _controller?.dispose();
      _controller = null;
      _onInit();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onInit() {
    _controller?._internalNotifier.removeListener(_handeldOnUpdate);
    _effectiveController._internalNotifier.addListener(_handeldOnUpdate);
    if (_effectiveController.autoPlay) {
      _effectiveController.play();
    }
  }

  void _handeldOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _effectiveController._build(
      context,
      widget.child ?? const SizedBox.shrink(),
    );
  }
}
