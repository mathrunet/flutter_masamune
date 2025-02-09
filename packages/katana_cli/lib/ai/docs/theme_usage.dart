// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of theme_usage.mdc.
///
/// theme_usage.mdcの中身。
class ThemeUsageMdcCliAiCode extends CliAiCode {
  /// Contents of theme_usage.mdc.
  ///
  /// theme_usage.mdcの中身。
  const ThemeUsageMdcCliAiCode();

  @override
  String get name => "`Theme`の一覧とその利用方法";

  @override
  String get description => "アプリ内のデザインを管理するための`Theme`の一覧とその利用方法";

  @override
  String get globs => "lib/**/*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
`Theme`は[main.dart](mdc:lib/main.dart)内で定義されている`theme`を利用することにより利用可能。
テーマは`Material Design 3`のガイドラインに準拠している。

## `ColorScheme`を取得

- `ColorScheme`を取得するには下記のようにする。

    ```dart
    final Color backgroundColor = theme.color.background;
    final Color primaryColor = theme.color.primary;
    ```

- 取得可能な`ColorScheme`は下記の通り。

| ColorScheme | Summary |
| --- | --- |
| `background` | 背景色。`DarkMode`の場合は、`0xFF212121`。`LightMode`の場合は、`0xFFF7F7F7`。 |
| `onBackground` | 背景色の上に表示する文字やアイコン色。`DarkMode`の場合は、`0xFFF7F7F7`。 |
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
| `surface` | モーダルの背景色。`DarkMode`の場合は、`0xFF474747`。`LightMode`の場合は、`0xFFE7E7E7`。 |
| `onSurface` | モーダルの背景色の上に表示する文字やアイコン色。`DarkMode`の場合は、`0xFFF7F7F7`。`LightMode`の場合は、`0xFF212121`。 |

## `TextTheme`を取得

- `TextTheme`を取得するには下記のようにする。

    ```dart
    final TextStyle textTheme = theme.text.bodyMedium;
    ```

- 取得可能な`TextTheme`は下記の通り。

| TextTheme | Summary |
| --- | --- |
| `bodyMedium` | メインのテキスト。 |
| `bodySmall` | 小さいテキスト。 |
| `bodyLarge` | 大きいテキスト。 |
| `labelLarge` | ラベルのテキスト。 |
| `labelMedium` | ラベルのテキスト。 |
| `labelSmall` | ラベルのテキスト。 |
| `titleLarge` | タイトルのテキスト。 |
| `titleMedium` | タイトルのテキスト。 |
| `titleSmall` | タイトルのテキスト。 |
| `headlineLarge` | ヘッダーのテキスト。 |
| `headlineMedium` | ヘッダーのテキスト。 |
| `headlineSmall` | ヘッダーのテキスト。 |
| `displayLarge` | ディスプレイのテキスト。 |
| `displayMedium` | ディスプレイのテキスト。 |
| `displaySmall` | ディスプレイのテキスト。 |

# アセットの取得

- アセットを取得するには下記のようにする。

    ```dart
    final assetImage = theme.asset.logo;
    final ImageProvider assetImageProvider = theme.asset.logoProvider;
    final String assetPath = theme.asset.logo.path;
    ```

- 取得可能なアセットは`assets/`フォルダー以下に配置された画像ファイルが対象。自動生成時にフォルダ構成に応じてコードが生成される。

# フォントの取得

- フォントを取得するには下記のようにする。

    ```dart
    final String fontFamily = theme.font.mPlus1;
    ```

- 取得可能なフォントは`fonts/`フォルダー以下に配置されたフォントファイルが対象。自動生成時にフォルダ構成に応じてコードが生成される。
""";
  }
}
