part of masamune;

/// Class that inherits from [HookWidget].
/// You can treat it like a regular [HookWidget].
///
/// Please use StatelessWidget below this.
abstract class UIWidget extends HookWidget {
  /// Class that inherits from [HookWidget].
  /// You can treat it like a regular [HookWidget].
  ///
  /// Please use StatelessWidget below this.
  ///
  /// [key]: Key.
  const UIWidget({Key key}) : super(key: key);

  /// Build context.
  ///
  /// Only available in Hook timings.
  BuildContext get context => useContext();

  /// Callback for building.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @protected
  Widget build(BuildContext context);
}
