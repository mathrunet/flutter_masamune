part of masamune;

// /// You can play the animation builder
// /// in the form corresponding to [UIAnimatorScenario].
// ///
// /// Create the [UIAnimatorScenario] path first.
// ///
// /// The basic specifications are the same as [AnimatedBuilder].
// class UIAnimatedBuilder extends StatelessWidget {
//   /// You can play the animation builder
//   /// in the form corresponding to [UIAnimatorScenario].
//   ///
//   /// Create the [UIAnimatorScenario] path first.
//   ///
//   /// The basic specifications are the same as [AnimatedBuilder].
//   ///
//   /// [key]: Widget key.
//   /// [animator]: Animator object.
//   /// [path]: The path where the animator objects are stored.
//   /// [builder]: Callback for building the animation.
//   /// [child]: Widget that does not update when animated.
//   const UIAnimatedBuilder({
//     Key? key,
//     required this.animator,
//     required this.builder,
//     this.child,
//   }) : super(key: key);

//   /// Animator object.
//   final UIAnimatorScenario animator;

//   /// Callback for building the animation.
//   final Widget Function(BuildContext, Widget, UIAnimatorScenario) builder;

//   /// Widget that does not update when animated.
//   final Widget? child;

//   /// Callback for building.
//   ///
//   /// Override and use.
//   ///
//   /// [context]: Build context.
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       key: key,
//       animation: animator.controller,
//       child: child,
//       builder: (context, child) {
//         return builder.call(
//           context,
//           child ?? const Empty(),
//           animator,
//         );
//       },
//     );
//   }
// }
