part of masamune;

// /// Scope for UniversalUI configuration.
// ///
// /// If [breakpoint] is specified, it will overwrite [breakpoint] in [UniversalScaffold].
// ///
// /// UniversalUIの設定を行うためのスコープ。
// ///
// /// [breakpoint]を指定すると、[UniversalScaffold]の[breakpoint]が上書きされます。
// class UniversalScope extends InheritedWidget {
//   /// Scope for UniversalUI configuration.
//   ///
//   /// If [breakpoint] is specified, it will overwrite [breakpoint] in [UniversalScaffold].
//   ///
//   /// UniversalUIの設定を行うためのスコープ。
//   ///
//   /// [breakpoint]を指定すると、[UniversalScaffold]の[breakpoint]が上書きされます。
//   const UniversalScope({
//     super.key,
//     required super.child,
//     this.breakpoint,
//   });

//   /// You can specify the breakpoint at which the UI will change to a mobile-oriented UI.
//   ///
//   /// UIがモバイル向けのUIに変化するブレークポイントを指定できます。
//   final ResponsiveBreakpoint? breakpoint;

//   /// Get [UniversalScope] by passing [context].
//   ///
//   /// [context]を渡すことで、[UniversalScope]を取得します。
//   static UniversalScope? of(BuildContext context) {
//     final scope =
//         context.getElementForInheritedWidgetOfExactType<UniversalScope>();
//     return scope?.widget as UniversalScope?;
//   }

//   @override
//   bool updateShouldNotify(UniversalScope oldWidget) => false;
// }
