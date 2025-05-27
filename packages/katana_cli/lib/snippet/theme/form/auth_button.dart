// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Auth button template.
///
/// 認証ボタンのテンプレート。
class ThemeFormAuthButtonCliCodeSnippet extends CliCodeSnippet {
  /// Auth button template.
  ///
  /// 認証ボタンのテンプレート。
  const ThemeFormAuthButtonCliCodeSnippet();

  @override
  String get name => "ThemeFormAuthButton";

  @override
  String get prefix => "@theme/form/auth_button";

  @override
  String get description => "Create a AuthButton for login. ログイン用の認証ボタンを作成。";

  @override
  String body(String path, String baseName, String className) {
    return r"""final authFormButtonStyle = OutlinedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
  side: const BorderSide(color: kWhiteColor, width: 2),
  backgroundColor: Colors.transparent,
  foregroundColor: kWhiteColor,
  textStyle: theme.text.styles.bold,
);
""";
  }
}
