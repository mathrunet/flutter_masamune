// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of transition_usage.mdc.
///
/// transition_usage.mdcの中身。
class TransitionUsageMdcCliAiCode extends CliAiCode {
  /// Contents of transition_usage.mdc.
  ///
  /// transition_usage.mdcの中身。
  const TransitionUsageMdcCliAiCode();

  @override
  String get name => "Router`による`Page`遷移時のトランジション利用方法";

  @override
  String get description => "`Router`による`Page`遷移時のトランジション利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
[`Router`の利用](mdc:.cursor/rules/docs/router_usage.mdc)時に`Page`遷移時のトランジションを下記のように設定することが可能。

- `TransitionQuery.fullscreen`
    - フルスクリーン時のアニメーションで次のページを表示。
    - 戻るボタンが強制的に閉じるボタンに変更される。

- `TransitionQuery.none`
    - アニメーションを行なわない。

- `TransitionQuery.fade`
    - フェードのアニメーションで次のページを表示。

- `TransitionQuery.centerModal`
    - 真ん中から出現するモーダルのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。

- `TransitionQuery.bottomModal`
    - 下から出現するモーダルのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。

- `TransitionQuery.leftModal`
    - 左から出現するモーダルのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。

- `TransitionQuery.rightModal`
    - 右から出現するモーダルのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。

- `TransitionQuery.leftSheet`
    - 左から出現するシートのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。

- `TransitionQuery.rightSheet`
    - 右から出現するシートのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。

- `TransitionQuery.bottomSheet`
    - 下から出現するシートのアニメーションで次のページを表示。
    - 裏のページが見えるようになる。
""";
  }
}
