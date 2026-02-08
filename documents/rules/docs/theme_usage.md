# `Theme`の一覧とその利用方法

`Theme`は`lib/main.dart`内で定義されている`theme`を利用することにより利用可能。
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

# テーマモードの固定設定

- ダークモード/ライトモードを固定、またはシステム設定に従うかを指定できます。

## ダークモード固定

- アプリを常にダークモードで表示する場合は以下のように設定します。

    ```dart
    @appTheme
    final theme = AppThemeData(
      // ダークモード固定
      themeMode: ThemeMode.dark,
      brightness: Brightness.dark,
      statusBarBrightnessOnAndroid: Brightness.dark,
      statusBarBrightnessOnIOS: Brightness.dark,

      // ダークモード用のカラー設定
      background: Color(0xFF212121),
      onBackground: Color(0xFFF7F7F7),
      surface: Color(0xFF474747),
      onSurface: Color(0xFFF7F7F7),
      primary: Color(0xFF2196F3),
      onPrimary: Color(0xFFF7F7F7),
      // ... その他のカラー設定
    );
    ```

## ライトモード固定

- アプリを常にライトモードで表示する場合は以下のように設定します。

    ```dart
    @appTheme
    final theme = AppThemeData(
      // ライトモード固定
      themeMode: ThemeMode.light,
      brightness: Brightness.light,
      statusBarBrightnessOnAndroid: Brightness.light,
      statusBarBrightnessOnIOS: Brightness.light,

      // ライトモード用のカラー設定
      background: Color(0xFFF7F7F7),
      onBackground: Color(0xFF212121),
      surface: Color(0xFFE7E7E7),
      onSurface: Color(0xFF212121),
      primary: Color(0xFF2196F3),
      onPrimary: Color(0xFFF7F7F7),
      // ... その他のカラー設定
    );
    ```

## システム設定に従う（デフォルト）

- システムの設定（ダークモード/ライトモード）に従う場合は、`themeMode`、`brightness`、`statusBarBrightnessOnAndroid`、`statusBarBrightnessOnIOS`を設定しません。

    ```dart
    @appTheme
    final theme = AppThemeData(
      // themeMode、brightness、statusBarBrightnessは設定しない
      // システムの設定に応じて自動的に切り替わる

      primary: Color(0xFF2196F3),
      onPrimary: Color(0xFFF7F7F7),
      // ... その他のカラー設定
    );
    ```

## ステータスバーの設定について

- **statusBarBrightnessOnAndroid**: Androidのステータスバーアイコンの明度
  - `Brightness.dark`: 暗いアイコン（明るい背景用）
  - `Brightness.light`: 明るいアイコン（暗い背景用）

- **statusBarBrightnessOnIOS**: iOSのステータスバーの明度
  - `Brightness.dark`: 暗いステータスバー（白いアイコン）
  - `Brightness.light`: 明るいステータスバー（黒いアイコン）
  - **注意**: iOSでは内部で逆のbrightnessに変換されるため、期待する表示と同じ値を指定してください。

## テーマ設定パラメータ

| パラメータ | 説明 | 値 |
| --- | --- | --- |
| `themeMode` | テーマモードを指定 | `ThemeMode.dark`, `ThemeMode.light`, `ThemeMode.system` |
| `brightness` | アプリ全体の明度 | `Brightness.dark`, `Brightness.light` |
| `statusBarBrightnessOnAndroid` | Androidステータスバーの明度 | `Brightness.dark`, `Brightness.light` |
| `statusBarBrightnessOnIOS` | iOSステータスバーの明度（逆変換される） | `Brightness.dark`, `Brightness.light` |
