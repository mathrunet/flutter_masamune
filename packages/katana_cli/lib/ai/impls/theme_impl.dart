// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of theme_impl.md.
///
/// theme_impl.mdの中身。
class ThemeImplMdCliAiCode extends CliAiCode {
  /// Contents of theme_impl.md.
  ///
  /// theme_impl.mdの中身。
  const ThemeImplMdCliAiCode();

  @override
  String get name => "`Theme`の実装";

  @override
  String get globs => "lib/theme.dart";

  @override
  String get directory => "impls";

  @override
  String get description => "`Theme設計書`を用いた`Theme`の実装方法";

  @override
  String body(String baseName, String className) {
    return r"""
`documents/designs/theme_design.md`に記載されている`Theme設計書`から`lib/theme.dart`を編集
`documents/designs/theme_design.md`が存在しない場合は絶対に実施しない

1. `Theme設計書`で定義されている内容を元に`lib/theme.dart`を書き換える
    - `lib/theme.dart`の`AppThemeData`を変更
        - `ColorMode`に応じて下記の設定を追加
            - `DarkMode`
                - `themeMode`: ThemeMode.dark
                - `brightness`: Brightness.dark
                - `statusBarBrightnessOnAndroid`: Brightness.dark
                - `statusBarBrightnessOnIOS`: Brightness.dark
            - `LightMode`
                - `themeMode`: ThemeMode.light
                - `brightness`: Brightness.light
                - `statusBarBrightnessOnAndroid`: Brightness.light
                - `statusBarBrightnessOnIOS`: Brightness.light
            - `SystemSettingDependent`
                - `themeMode`: 設定しない
                - `brightness`: 設定しない
                - `statusBarBrightnessOnAndroid`: 設定しない
                - `statusBarBrightnessOnIOS`: 設定しない
    - 例：
      ```dart
      // Flutter imports:
      import 'package:flutter/material.dart';

      // Package imports:
      import 'package:masamune/masamune.dart';

      part 'theme.theme.dart';

      /// App Theme.
      ///
      /// ```dart
      /// theme.color.primary   // Primary color.
      /// theme.text.bodyMedium // Medium body text style.
      /// theme.asset.xxx       // xxx image.
      /// theme.font.xxx        // xxx font.
      /// ```
      @appTheme
      final theme = AppThemeData(
        // TODO: Set the design.
        background: Color(0xFF212121), // `ColorMode`が`SystemSettingDependent`の場合は記載しない
        onBackground: Color(0xFFF7F7F7), // `ColorMode`が`SystemSettingDependent`の場合は記載しない
        surface: Color(0xFF474747), // `ColorMode`が`SystemSettingDependent`の場合は記載しない
        onSurface: Color(0xFFF7F7F7), // `ColorMode`が`SystemSettingDependent`の場合は記載しない
        themeMode: ThemeMode.dark, // `ColorMode`が`SystemSettingDependent`の場合は記載しない
        brightness: Brightness.dark, // `ColorMode`が`SystemSettingDependent`の場合は記載しない
        statusBarBrightnessOnAndroid: Brightness.dark, // `ColorMode`が`SystemSettingDependent`の場合は記載しない
        statusBarBrightnessOnIOS: Brightness.dark, // `ColorMode`が`SystemSettingDependent`の場合は記載しない
        primary: Color(0xFF2196F3),
        onPrimary: Color(0xFFF7F7F7),
        secondary: Color(0xFF00BCD4),
        onSecondary: Color(0xFFF7F7F7),
        tertiary: Color(0xFF4CAF50),
        onTertiary: Color(0xFFF7F7F7),
        disabled: Color(0xFF9E9E9E),
        onDisabled: Color(0xFFF7F7F7),
        weak: Color(0xFF9E9E9E),
        onWeak: Color(0xFFF7F7F7),
        outline: Color(0xFF9E9E9E),
        error: Color(0xFFF44336),
        onError: Color(0xFFF7F7F7),
        warning: Color(0xFFFFC107),
        onWarning: Color(0xFFF7F7F7),
        info: Color(0xFF2196F3),
        onInfo: Color(0xFFF7F7F7),
        success: Color(0xFF4CAF50),
        onSuccess: Color(0xFFF7F7F7),
      );
      ```
2. 下記コマンドを実行して残りのファイルを自動生成

  ```bash
  katana code generate
  ```
""";
  }
}
