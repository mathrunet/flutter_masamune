part of "/masamune_experiment.dart";

/// A branch of [Experiment.run].
///
/// [label] is the name of the branch. Use a name that makes the condition easy to understand, such as `control` or `treatment`.
///
/// [when] receives the value obtained by the first callback of [Experiment.run] and returns `true` if this branch should be executed.
///
/// [run] is executed only when [when] returns `true` first. The return value becomes the return value of [Experiment.run].
///
/// [Experiment.run]の分岐。
///
/// [label]は分岐の名前です。`control`や`treatment`など、条件が分かりやすい名前を付けてください。
///
/// [when]は[Experiment.run]の最初のコールバックで取得した値を受け取り、この分岐を実行すべき場合に`true`を返します。
///
/// [run]は[when]が最初に`true`を返した場合のみ実行されます。戻り値は[Experiment.run]の戻り値になります。
@immutable
class ExperimentCase<TValue, TResult> {
  /// A branch of [Experiment.run].
  ///
  /// [label] is the name of the branch. Use a name that makes the condition easy to understand, such as `control` or `treatment`.
  ///
  /// [when] receives the value obtained by the first callback of [Experiment.run] and returns `true` if this branch should be executed.
  ///
  /// [run] is executed only when [when] returns `true` first. The return value becomes the return value of [Experiment.run].
  ///
  /// [Experiment.run]の分岐。
  ///
  /// [label]は分岐の名前です。`control`や`treatment`など、条件が分かりやすい名前を付けてください。
  ///
  /// [when]は[Experiment.run]の最初のコールバックで取得した値を受け取り、この分岐を実行すべき場合に`true`を返します。
  ///
  /// [run]は[when]が最初に`true`を返した場合のみ実行されます。戻り値は[Experiment.run]の戻り値になります。
  const ExperimentCase({
    required this.label,
    required this.when,
    required this.run,
  });

  /// A branch that is executed when the value equals [expected].
  ///
  /// 値が[expected]と等しい場合に実行される分岐。
  factory ExperimentCase.equals(
    TValue expected, {
    required String label,
    required TResult Function() run,
  }) {
    return ExperimentCase(
      label: label,
      when: (value) => value == expected,
      run: run,
    );
  }

  /// A branch that is always executed if the previous branches did not match.
  ///
  /// Place it at the end of the list and use it for the control group (current behavior).
  ///
  /// 前の分岐に一致しなかった場合に必ず実行される分岐。
  ///
  /// リストの最後に置き、コントロール群（現行の挙動）に利用してください。
  factory ExperimentCase.otherwise({
    required String label,
    required TResult Function() run,
  }) {
    return ExperimentCase(
      label: label,
      when: (value) => true,
      run: run,
    );
  }

  /// Name of the branch.
  ///
  /// 分岐の名前。
  final String label;

  /// Returns `true` if this branch should be executed.
  ///
  /// この分岐を実行すべき場合に`true`を返します。
  final bool Function(TValue value) when;

  /// Process executed when this branch is selected.
  ///
  /// この分岐が選ばれた場合に実行される処理。
  final TResult Function() run;

  // Called through a method so that the actual type of [TValue] is used even if the list is widened.
  bool _matches(TValue value) => when(value);

  TResult _run() => run();

  @override
  String toString() => "ExperimentCase($label)";
}
