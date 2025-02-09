// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of theme_design.mdc.
///
/// theme_design.mdcの中身。
class ThemeDesignMdcCliAiCode extends CliAiCode {
  /// Contents of theme_design.mdc.
  ///
  /// theme_design.mdcの中身。
  const ThemeDesignMdcCliAiCode();

  @override
  String get name => "`Theme設計書`の作成";

  @override
  String get globs => "documents/designs/theme_design.md";

  @override
  String get directory => "designs";

  @override
  String get description => "`Theme設計`の方法と`Theme設計書`の作成";

  @override
  String body(String baseName, String className) {
    return r"""
[requirements.md](mdc:requirements.md)に記載されている`要件定義`から`Theme設計書`を作成

1. `要件定義`から`ColorMode`と`ColorScheme`を設定し`Theme設計書`を作成
    - `ColorMode`は下記から選択
        - `DarkMode`
            - 黒背景ベースに白文字
        - `LightMode`
            - 白背景ベースに黒文字 
        - `SystemSettingDependent`
            - 端末のシステム設定によって`DarkMode`か`LightMode`どちらかに自動設定。要望がない場合はこちらを選択
    - `ColorScheme`は下記の種類を定義
        | ColorScheme | Summary |
        | --- | --- |
        | `background` | 背景色。`DarkMode`の場合は、`0xFF212121`。`LightMode`の場合は、`0xFFF7F7F7`。`SystemSettingDependent`の場合は設定しない。 |
        | `onBackground` | 背景色の上に表示する文字やアイコン色。`DarkMode`の場合は、`0xFFF7F7F7`。`LightMode`の場合は、`0xFF212121`。`SystemSettingDependent`の場合は設定しない。 |
        | `primary` | メインカラー。 |
        | `onPrimary` | メインカラーを背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
        | `secondary` | ２番目のメインカラー。 |
        | `onSecondary` | ２番目のメインカラーを背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
        | `tertiary` | ３番目のメインカラー。 |
        | `onTertiary` | ３番目のメインカラーを背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
        | `disabled` | 非アクティブな要素の文字やアイコン色、背景色。通常は`0xFF9E9E9E`。 |
        | `onDisabled` | 非アクティブな要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
        | `weak` | 通常の文字よりも主張が弱い要素の文字やアイコン色、背景色。通常は`0xFF9E9E9E`。 |
        | `onWeak` | 通常の文字よりも主張が弱い要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
        | `outline` | ボックスの外枠や区切り線で利用する色。通常は`0xFF9E9E9E`。 |
        | `error` | エラーや警告の要素の文字やアイコン色、背景色。通常は`0xFFF44336`。 |
        | `onError` | エラーや警告の要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
        | `warning` | `error`よりも重要度が薄い注意の要素の文字やアイコン色、背景色。通常は`0xFFFFC107`。 |
        | `onWarning` | `error`よりも重要度が薄い注意の要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
        | `info` | `warning`よりもさらに重要度が薄い通知の要素の文字やアイコン色、背景色。通常は`0xFF2196F3`。 |
        | `onInfo` | `warning`よりもさらに重要度が薄い通知の要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
        | `success` | 成功や完了を通知する要素の文字やアイコン色、背景色。通常は`0xFF4CAF50`。 |
        | `onSuccess` | 成功や完了を通知する要素の背景色にしたときに上に表示する文字やアイコン色。通常は`0xFFF7F7F7`。 |
        | `surface` | モーダルの背景色。`DarkMode`の場合は、`0xFF474747`。`LightMode`の場合は、`0xFFE7E7E7`。`SystemSettingDependent`の場合は設定しない。 |
        | `onSurface` | モーダルの背景色の上に表示する文字やアイコン色。`DarkMode`の場合は、`0xFFF7F7F7`。`LightMode`の場合は、`0xFF212121`。`SystemSettingDependent`の場合は設定しない。 |
    - 例：
        ```markdown
        <!-- documents/designs/theme_design.md -->
        
        ## ColorMode
        
        `DarkMode`
        
        ## ColorScheme
        
        | ColorScheme | Summary |
        | --- | --- |
        | `background` | 0xFF212121 |
        | `onBackground` | 0xFFF7F7F7 |
        | `primary` | 0xFF2196F3 |
        | `onPrimary` | 0xFFF7F7F7 |
        | `secondary` | 0xFF00BCD4 |
        | `onSecondary` | 0xFFF7F7F7 |
        | `tertiary` | 0xFF4CAF50 |
        | `onTertiary` | 0xFFF7F7F7 |
        | `disabled` | 0xFF9E9E9E |
        | `onDisabled` | 0xFFF7F7F7 |
        | `weak` | 0xFF9E9E9E |
        | `onWeak` | 0xFFF7F7F7 |
        | `outline` | 0xFF9E9E9E |
        | `error` | 0xFFF44336 |
        | `onError` | 0xFFF7F7F7 |
        | `warning` | 0xFFFFC107 |
        | `onWarning` | 0xFFF7F7F7 |
        | `info` | 0xFF2196F3 |
        | `onInfo` | 0xFFF7F7F7 |
        | `success` | 0xFF4CAF50 |
        | `onSuccess` | 0xFFF7F7F7 |
        | `surface` | 0xFF474747 |
        | `onSurface` | 0xFFF7F7F7 |
        ```
2. 作成した`Theme設計書`を`documents/designs/theme_design.md`に保存
""";
  }
}
