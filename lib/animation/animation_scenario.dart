part of masamune;

/// Collection for running a continuous animation.
///
/// The animation stored in [AnimatorUnit] is
/// executed according to the collection order.
class AnimationScenario extends ValueModel<List<AnimationUnit>>
    with ListModelMixin<AnimationUnit>
    implements List<AnimationUnit>, TickerProvider {
  AnimationScenario([List<AnimationUnit>? units]) : super(units ?? []);

  /// Call all the registered listeners.
  ///
  /// Call this method whenever the object changes, to notify any clients the
  /// object may have changed. Listeners that are added during this iteration
  /// will not be visited. Listeners that are removed during this iteration will
  /// not be visited after they are removed.
  ///
  /// Exceptions thrown by listeners will be caught and reported using
  /// [FlutterError.reportError].
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// Surprising behavior can result when reentrantly removing a listener (e.g.
  /// in response to a notification) that has been registered multiple times.
  /// See the discussion at [removeListener].
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
    try {
      await controller.forward().orCancel;
    } catch (e) {
      print("Canceled animation.");
    }
    return this;
  }

  /// Play the animation from the opposite.
  Future<AnimationScenario> playReverse() async {
    __animation = _builder.animate(controller);
    try {
      await controller.reverse().orCancel;
    } catch (e) {
      print("Canceled animation.");
    }
    return this;
  }

  /// Repeat the animation and play.
  Future<AnimationScenario> playRepeat() async {
    __animation = _builder.animate(controller);
    try {
      await controller.repeat().orCancel;
    } catch (e) {
      print("Canceled animation.");
    }
    return this;
  }

  /// Stop the animation you are playing.
  AnimationScenario stop() {
    __animation = _builder.animate(controller);
    controller.stop();
    return this;
  }

  /// Gets the current value according to the [tag] in the animation list.
  ///
  /// If [defaultValue] is specified and there is no value, that value will be used.
  T get<T>(String tag, T defaultValue) {
    assert(tag.isNotEmpty, "The tag is empty.");
    final value = _animation[tag].value as T?;
    return value ?? defaultValue;
  }

  /// Discards any resources used by the object. After this is called, the
  /// object is not in a usable state and should be discarded (calls to
  /// [addListener] and [removeListener] will throw after the object is
  /// disposed).
  ///
  /// This method should only be called by the object's owner.
  @override
  void dispose() {
    controller.dispose();
    _ticker.dispose();
    super.dispose();
  }
}

extension WidgetRefAnimationScenarioExtensions on WidgetRef {
  /// Create a new [AnimationScenario].
  ///
  /// It is possible to create a separate scenario for each [key].
  ///
  /// Specify [AnimationUnit] for [units] to create an animation.
  ///
  /// If the page given the calling [WedgetRef] is deleted, [AnimationScenario] will be disposed.
  AnimationScenario useAnimationScenario(String key,
      [List<AnimationUnit>? units]) {
    return valueBuilder<AnimationScenario, _AnimationScenarioValue>(
      key: "animationScenario:$key",
      builder: () {
        return _AnimationScenarioValue(
          units: units,
        );
      },
    );
  }

  /// Create a new [AnimationScenario].
  ///
  /// Playback will start automatically.
  ///
  /// It is possible to create a separate scenario for each [key].
  ///
  /// Specify [AnimationUnit] for [units] to create an animation.
  ///
  /// If the page given the calling [WedgetRef] is deleted, [AnimationScenario] will be disposed.
  AnimationScenario useAutoPlayAnimationScenario(String key,
      [List<AnimationUnit>? units]) {
    return valueBuilder<AnimationScenario, _AnimationScenarioValue>(
      key: "animationScenario:$key",
      builder: () {
        return _AnimationScenarioValue(
          units: units,
          onInit: (scenario) => scenario.play(),
        );
      },
    );
  }

  /// Create a new [AnimationScenario].
  ///
  /// Automatically repeat playback.
  ///
  /// It is possible to create a separate scenario for each [key].
  ///
  /// Specify [AnimationUnit] for [units] to create an animation.
  ///
  /// If the page given the calling [WedgetRef] is deleted, [AnimationScenario] will be disposed.
  AnimationScenario useAutoRepeatAnimationScenario(String key,
      [List<AnimationUnit>? units]) {
    return valueBuilder<AnimationScenario, _AnimationScenarioValue>(
      key: "animationScenario:$key",
      builder: () {
        return _AnimationScenarioValue(
          units: units,
          onInit: (scenario) => scenario.playRepeat(),
        );
      },
    );
  }
}

@immutable
class _AnimationScenarioValue extends ScopedValue<AnimationScenario> {
  const _AnimationScenarioValue({
    required this.units,
    this.onInit,
  });

  final List<AnimationUnit>? units;
  final void Function(AnimationScenario scenario)? onInit;

  @override
  ScopedValueState<AnimationScenario, ScopedValue<AnimationScenario>>
      createState() => _AnimationScenarioValueState();
}

class _AnimationScenarioValueState
    extends ScopedValueState<AnimationScenario, _AnimationScenarioValue> {
  late AnimationScenario scenario;

  @override
  void initValue() {
    super.initValue();
    scenario = AnimationScenario(value.units);
    value.onInit?.call(scenario);
  }

  @override
  void didUpdateValue(_AnimationScenarioValue oldValue) {
    super.didUpdateValue(oldValue);
    if (value.units != oldValue.units) {
      scenario.dispose();
      scenario = AnimationScenario(value.units);
      value.onInit?.call(scenario);
    }
  }

  @override
  void dispose() {
    super.dispose();
    scenario.dispose();
  }

  @override
  AnimationScenario build() => scenario;
}
