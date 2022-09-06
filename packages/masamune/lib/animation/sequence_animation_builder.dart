part of masamune;

class _AnimationInformation {
  _AnimationInformation({
    required this.animatable,
    required this.from,
    required this.to,
    required this.curve,
    required this.tag,
  });

  final Animatable animatable;
  final Duration from;
  final Duration to;
  final Curve curve;
  final Object tag;
}

class _SequenceAnimationBuilder {
  final List<_AnimationInformation> _animations = [];

  Duration getCurrentDuration() {
    return Duration(microseconds: _currentLengthInMicroSeconds());
  }

  _SequenceAnimationBuilder addAnimatableAfterLastOneWithTag({
    required Object lastTag,
    required Animatable animatable,
    Duration delay = Duration.zero,
    required Duration duration,
    Curve curve = Curves.linear,
    required Object tag,
  }) {
    assert(
      _animations.isNotEmpty,
      "Can not add animatable after last one if there is no animatable yet",
    );
    final start = _animations
        .cast<_AnimationInformation?>()
        .lastWhere((it) => it?.tag == lastTag, orElse: () => null)
        ?.to;
    assert(
      start != null,
      "Animation with tag $lastTag can not be found before $tag",
    );
    start!;
    return addAnimatable(
      animatable: animatable,
      from: start + delay,
      to: start + delay + duration,
      tag: tag,
      curve: curve,
    );
  }

  _SequenceAnimationBuilder addAnimatableAfterLastOne({
    required Animatable animatable,
    Duration delay = Duration.zero,
    required Duration duration,
    Curve curve = Curves.linear,
    required Object tag,
  }) {
    assert(
      _animations.isNotEmpty,
      "Can not add animatable after last one if there is no animatable yet",
    );
    final start = _animations.last.to;
    return addAnimatable(
      animatable: animatable,
      from: start + delay,
      to: start + delay + duration,
      tag: tag,
      curve: curve,
    );
  }

  _SequenceAnimationBuilder addAnimatableUsingDuration({
    required Animatable animatable,
    required Duration start,
    required Duration duration,
    Curve curve = Curves.linear,
    required Object tag,
  }) {
    return addAnimatable(
      animatable: animatable,
      from: start,
      to: start + duration,
      tag: tag,
      curve: curve,
    );
  }

  _SequenceAnimationBuilder addAnimatable({
    required Animatable animatable,
    required Duration from,
    required Duration to,
    Curve curve = Curves.linear,
    required Object tag,
  }) {
    assert(to >= from);
    _animations.add(
      _AnimationInformation(
        animatable: animatable,
        from: from,
        to: to,
        curve: curve,
        tag: tag,
      ),
    );
    return this;
  }

  int _currentLengthInMicroSeconds() {
    int longestTimeMicro = 0;
    _animations.forEach((info) {
      final int micro = info.to.inMicroseconds;
      if (micro > longestTimeMicro) {
        longestTimeMicro = micro;
      }
    });
    return longestTimeMicro;
  }

  _SequenceAnimation animate(AnimationController controller) {
    final int longestTimeMicro = _currentLengthInMicroSeconds();
    // Sets the duration of the controller
    controller.duration = Duration(microseconds: longestTimeMicro);

    final Map<Object, Animatable> animatables = {};
    final Map<Object, double> begins = {};
    final Map<Object, double> ends = {};

    _animations.forEach((info) {
      assert(info.to.inMicroseconds <= longestTimeMicro);

      final double begin = info.from.inMicroseconds / longestTimeMicro;
      final double end = info.to.inMicroseconds / longestTimeMicro;
      final Interval intervalCurve = Interval(begin, end, curve: info.curve);
      if (animatables[info.tag] == null) {
        animatables[info.tag] =
            _IntervalAnimatable.chainCurve(info.animatable, intervalCurve);
        begins[info.tag] = begin;
        ends[info.tag] = end;
      } else {
        assert(
            ends[info.tag]! <= begin,
            "When animating the same property you need to: \n"
            "a) Have them not overlap \n"
            "b) Add them in an ordered fashion\n"
            "Animation with tag ${info.tag} ends at ${ends[info.tag]} but also begins at $begin");
        animatables[info.tag] = _IntervalAnimatable(
          animatable: animatables[info.tag]!,
          defaultAnimatable:
              _IntervalAnimatable.chainCurve(info.animatable, intervalCurve),
          begin: begins[info.tag]!,
          end: ends[info.tag]!,
        );
        ends[info.tag] = end;
      }
    });

    final Map<Object, Animation> result = {};

    animatables.forEach((tag, animInfo) {
      result[tag] = animInfo.animate(controller);
    });

    return _SequenceAnimation._internal(result);
  }
}

class _SequenceAnimation {
  _SequenceAnimation._internal(this._animations);
  final Map<Object, Animation> _animations;

  Animation operator [](Object key) {
    assert(
      _animations.containsKey(key),
      "There was no animatable with the key: $key",
    );
    return _animations[key]!;
  }
}

class _IntervalAnimatable<T> extends Animatable<T> {
  _IntervalAnimatable({
    required this.animatable,
    required this.defaultAnimatable,
    required this.begin,
    required this.end,
  });

  final Animatable animatable;
  final Animatable defaultAnimatable;

  final double begin;

  final double end;

  static Animatable chainCurve(Animatable parent, Interval interval) {
    return parent.chain(CurveTween(curve: interval));
  }

  @override
  T transform(double t) {
    if (t >= begin && t <= end) {
      return animatable.transform(t);
    } else {
      return defaultAnimatable.transform(t);
    }
  }
}
