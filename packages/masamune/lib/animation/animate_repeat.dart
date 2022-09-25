part of masamune;

/// The Flutter Animate library makes adding beautiful animated effects to your widgets simple. It supports both a declarative and chained API. The latter is exposed  via the `Widget.animate` extension, which simply wraps the widget in `Animate`.
/// Flutter Animate ライブラリを使用すると、美しいアニメーション効果をウィジェットに簡単に追加できます。宣言型 API とチェーン API の両方をサポートしています。後者は、ウィジェットを Animate でラップするだけの `Widget.animate` 拡張機能を介して公開されます。
///
/// ```
/// // declarative:
/// Animate(child: foo, effects: [FadeEffect(), ScaleEffect()])
/// // equivalent chained API:
/// foo.animate().fade().scale() // equivalent to above
/// ```
///
/// Effects are always run in parallel (ie. the fade and scale effects in the example above would be run simultaneously), but you can apply delays to offset them or run them in sequence.
/// エフェクトは常に並行して実行されます (つまり、上記の例のフェード エフェクトとスケール エフェクトは同時に実行されます) が、遅延を適用してそれらをオフセットしたり、順番に実行したりできます。
///
/// All effects classes are immutable, and can be shared between `Animate` instances, which lets you create libraries of effects to reuse throughout your app.
/// すべてのエフェクト クラスは不変であり、「Animate」インスタンス間で共有できます。これにより、アプリ全体で再利用するエフェクトのライブラリを作成できます。
///
/// ```
/// List<Effect> transitionIn = [
///   FadeEffect(duration: 100.ms, curve: Curves.easeOut),
///   ScaleEffect(begin: 0.8, curve: Curves.easeIn)
/// ];
/// // then:
/// Animate(child: foo, effects: transitionIn)
/// // or:
/// foo.animate(effects: transitionIn)
/// ```
///
/// Effects inherit some of their properties (delay, duration, curve) from the previous effect if unspecified. So in the examples above, the scale will use the same duration as the fade that precedes it. All effects have reasonable defaults, so they can be used simply: `foo.animate().fade()`
/// エフェクトは、指定されていない場合、前のエフェクトからプロパティ (遅延、持続時間、カーブ) の一部を継承します。したがって、上記の例では、スケールはその前のフェードと同じデュレーションを使用します。すべてのエフェクトには適切なデフォルトがあるため、単純に使用できます: `foo.animate().fade()`
///
/// Note that all effects are composed together, not run sequentially. For example, the following would not fade in myWidget, because the fadeOut effect would still be applying an opacity of 0:
/// すべての効果は一緒に構成されており、順番に実行されるわけではないことに注意してください。たとえば、fadeOut 効果が引き続き不透明度 0 を適用するため、次の例は myWidget でフェードインしません。
///
/// ```
/// myWidget.animate().fadeOut(duration: 200.ms).fadeIn(delay: 200.ms)
/// ```
///
/// See [SwapEffect] for one approach to work around this.
/// これを回避する 1 つの方法については、[SwapEffect] を参照してください。

// ignore: must_be_immutable
class AnimateRepeat extends Animate {
  AnimateRepeat({
    Key? key,
    Widget child = const SizedBox.shrink(),
    List<Effect>? effects,
    void Function(AnimationController)? onComplete,
    void Function(AnimationController)? onPlay,
    Duration delay = Duration.zero,
    AnimationController? controller,
    Adapter? adapter,
  }) : super(
          key: key,
          child: child,
          effects: effects,
          onComplete: onComplete,
          onPlay: (controller) {
            controller.repeat();
            onPlay?.call(controller);
          },
          delay: delay,
          controller: controller,
          adapter: adapter,
        );

  /// Default duration for effects.
  /// 効果のデフォルトの持続時間。
  static Duration defaultDuration = const Duration(milliseconds: 300);

  /// Default curve for effects.
  /// エフェクトのデフォルト カーブ。
  static Curve defaultCurve = Curves.linear;

  /// Widget types to reparent, mapped to a method that handles that type. This is used to make it easy to work with widgets that require specific parents. For example, the [Positioned] widget, which needs its immediate parent to be a [Stack].
  /// そのタイプを処理するメソッドにマップされた、親を変更するウィジェットのタイプ。これは、特定の親を必要とするウィジェットを簡単に操作できるようにするために使用されます。たとえば、直接の親が [Stack] である必要がある [Positioned] ウィジェット。
  ///
  /// Handles [Flexible], [Positioned], and [Expanded] by default, but you can add additional handlers as appropriate. Example, this would add support for a hypothetical "AlignPositioned" widget, that has an `alignment` property.
  /// [Flexible]、[Positioned]、および [Expanded] をデフォルトで処理しますが、必要に応じて追加のハンドラーを追加できます。たとえば、これは「alignment」プロパティを持つ架空の「AlignPositioned」ウィジェットのサポートを追加します。
  ///
  /// ```
  /// Animate.reparentTypes[AlignPositioned] = (parent, child) {
  ///   AlignPositioned o = parent as AlignPositioned;
  ///   return AlignPositioned(alignment: o.alignment, child: child);
  /// }
  /// ```
  static Map reparentTypes = <Type, ReparentChildBuilder>{
    Flexible: (parent, child) {
      final o = parent as Flexible;
      return Flexible(key: o.key, flex: o.flex, fit: o.fit, child: child);
    },
    Positioned: (parent, child) {
      final o = parent as Positioned;
      return Positioned(
        key: o.key,
        left: o.left,
        top: o.top,
        right: o.right,
        bottom: o.bottom,
        width: o.width,
        height: o.height,
        child: child,
      );
    },
    Expanded: (parent, child) {
      final o = parent as Expanded;
      return Expanded(key: o.key, flex: o.flex, child: child);
    }
  };
}

/// Provides extended methods for animating [Widget].
/// [Widget]のアニメーション用の拡張メソッドを提供します。
extension AnimationWidgetExtensions on Widget {
  /// Returns an [Animate] object in a repeatable state.
  /// [Animate]オブジェクトをリピート可能な状態にして返します。
  Animate animateRepeat({
    Key? key,
    List<Effect>? effects,
    AnimateCallback? onComplete,
    AnimateCallback? onPlay,
    Duration delay = Duration.zero,
    AnimationController? controller,
    Adapter? adapter,
  }) =>
      Animate(
        key: key,
        effects: effects,
        onComplete: onComplete,
        onPlay: (controller) {
          controller.repeat();
          onPlay?.call(controller);
        },
        delay: delay,
        controller: controller,
        adapter: adapter,
        child: this,
      );
}
