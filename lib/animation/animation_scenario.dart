part of masamune;

/// Collection for running a continuous animation.
///
/// The animation stored in [UIAnimatorUnit] is
/// executed according to the collection order.
class AnimationScenario extends ValueModel<List<AnimationUnit>>
    with ListModelMixin<AnimationUnit>
    implements List<AnimationUnit>, TickerProvider {
  AnimationScenario([List<AnimationUnit>? units]) : super(units ?? []);

  @override
  @protected
  void notifyListeners() {
    super.notifyListeners();
    __builder = null;
    __animation = null;
  }

  void _rebuild() {
    __animation = null;
    __builder = SequenceAnimationBuilder();
    for (final anim in value) {
      _builder.addAnimatable(
        animatable: anim.tween,
        from: anim.from,
        to: anim.to,
        tag: anim.tag ?? "",
        curve: anim.curve,
      );
    }
  }

  late Ticker _ticker;
  SequenceAnimationBuilder get _builder {
    if (__builder == null) {
      _rebuild();
    }
    return __builder!;
  }

  SequenceAnimationBuilder? __builder;

  /// Creates a ticker with the given callback.
  ///
  /// The kind of ticker provided depends on the kind of ticker provider.
  @override
  Ticker createTicker(onTick) {
    _ticker = Ticker(onTick);
    return _ticker;
  }

  /// Animation controller.
  ///
  /// Please specify in Animated Builder etc.
  AnimationController get controller {
    return _controller ??= AnimationController(vsync: this);
  }

  AnimationController? _controller;

  SequenceAnimation get _animation {
    __animation ??= _builder.animate(controller);
    return __animation!;
  }

  SequenceAnimation? __animation;

  /// Play the animation.
  Future<AnimationScenario> play() async {
    __animation = _builder.animate(controller);
    await controller.forward().orCancel;
    return this;
  }

  /// Play the animation from the opposite.
  Future<AnimationScenario> playReverse() async {
    __animation = _builder.animate(controller);
    await controller.reverse().orCancel;
    return this;
  }

  /// Repeat the animation and play.
  Future<AnimationScenario> playRepeat() async {
    __animation = _builder.animate(controller);
    await controller.repeat().orCancel;
    return this;
  }

  /// Stop the animation you are playing.
  AnimationScenario stop() {
    __animation = _builder.animate(controller);
    controller.stop();
    return this;
  }

  /// Gets the current value according to the tags in the animation list.
  ///
  /// [tag]: Animation tag.
  /// [defaultValue]: The initial value if there is no value.
  T get<T>(String tag, T defaultValue) {
    assert(tag.isNotEmpty, "The tag is empty.");
    final value = _animation[tag].value as T?;
    return value ?? defaultValue;
  }

  /// Destroys the object.
  ///
  /// Destroyed objects are not allowed.
  @override
  void dispose() {
    controller.dispose();
    _ticker.dispose();
    super.dispose();
  }
}

AnimationScenario useAutoAnimationScenario([List<AnimationUnit>? units]) {
  final animationScenario = useAnimationScenario(units);
  useEffect(
    () {
      animationScenario.play();
      return () {};
    },
    [animationScenario],
  );
  return animationScenario;
}

AnimationScenario useAutoRepeatAnimationScenario([List<AnimationUnit>? units]) {
  final animationScenario = useAnimationScenario(units);
  useEffect(
    () {
      animationScenario.playRepeat();
      return () {};
    },
    [animationScenario],
  );
  return animationScenario;
}

class _AnimationScenarioHookCreator {
  const _AnimationScenarioHookCreator();

  /// Create a new animation scenario.
  AnimationScenario call([List<AnimationUnit>? units]) {
    return use(_AnimationScenarioHook(units));
  }
}

/// Create a new animation scenario.
const useAnimationScenario = _AnimationScenarioHookCreator();

class _AnimationScenarioHook extends Hook<AnimationScenario> {
  const _AnimationScenarioHook([
    this.units,
    List<Object?>? keys,
  ]) : super(keys: keys);

  final List<AnimationUnit>? units;

  @override
  _AnimationScenarioHookState createState() {
    return _AnimationScenarioHookState();
  }
}

class _AnimationScenarioHookState
    extends HookState<AnimationScenario, _AnimationScenarioHook> {
  late final AnimationScenario _animationScenario;
  @override
  void initHook() {
    _animationScenario = AnimationScenario(hook.units);
  }

  @override
  AnimationScenario build(BuildContext context) => _animationScenario;

  @override
  String get debugLabel => 'useAnimationScenario';
}
