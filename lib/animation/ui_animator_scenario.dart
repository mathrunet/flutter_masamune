part of masamune;

/// Collection for running a continuous animation.
///
/// The animation stored in [UIAnimatorUnit] is
/// executed according to the collection order.
class UIAnimatorScenario extends Model<UIAnimatorUnit>
    implements TickerProvider {
  UIAnimatorScenario(this.animation);

  final Iterable<UIAnimatorUnit> animation;

  void _rebuild() {
    __animation = null;
    __builder = SequenceAnimationBuilder();
    for (final anim in animation) {
      _builder.addAnimatable(
        animatable: anim.animatable,
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
  Future<UIAnimatorScenario> play() async {
    __animation = _builder.animate(controller);
    await controller.forward().orCancel;
    return this;
  }

  /// Play the animation from the opposite.
  Future<UIAnimatorScenario> playReverse() async {
    __animation = _builder.animate(controller);
    await controller.reverse().orCancel;
    return this;
  }

  /// Repeat the animation and play.
  Future<UIAnimatorScenario> playRepeat() async {
    __animation = _builder.animate(controller);
    await controller.repeat().orCancel;
    return this;
  }

  /// Stop the animation you are playing.
  UIAnimatorScenario stop() {
    __animation = _builder.animate(controller);
    controller.stop();
    return this;
  }

  /// Gets the current value according to the tags in the animation list.
  ///
  /// [tag]: Animation tag.
  /// [defaultValue]: The initial value if there is no value.
  T? attr<T>(String tag, {T? defaultValue}) {
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
