// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of naming_convention.md.
///
/// naming_convention.mdの中身。
class NamingConventionDocsMdCliAiCode extends CliAiCode {
  /// Contents of naming_convention.md.
  ///
  /// naming_convention.mdの中身。
  const NamingConventionDocsMdCliAiCode();

  @override
  String get name => "命名規則";

  @override
  String get description => "アプリケーション開発で利用する命名規則";

  @override
  String get globs => "*";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
## 命名規則

アプリケーション開発で利用する命名規則を下記に記載。

- 変数名
    - CamelCaseで記載。
    - 例：`userId`
- クラス名
    - PascalCaseで記載。
    - 例：`UserModel`
- メソッド名
    - CamelCaseで記載。
    - 例：`getUser`
- 定数名
    - 先頭にに`k`を付与しCamelCaseで記載。
    - 例：`kUserId`
- `Model`のクラス名
    - 末尾に`Model`を付与しPascalCaseで記載。
    - 例：`UserModel`
- `Model`のファイル名
    - `Model`のクラス名（末尾に`Model`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user_.dart`
- `Model`のデータフィールド名
    - CamelCaseで記載。
    - 例：`userId`
- `Page`のクラス名
    - 末尾に`Page`を付与しPascalCaseで記載。
    - 例：`UserPage`
- `Page`のファイル名
    - `Page`のクラス名（末尾に`Page`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user.dart`
- `Widget`のクラス名
    - 末尾に`Widget`を付与しPascalCaseで記載。
    - 例：`UserTileWidget`
- `Widget`のファイル名
    - `Widget`のクラス名（末尾に`Widget`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user_tile.dart`
- `Modal`のクラス名
    - 末尾に`Modal`を付与しPascalCaseで記載。
    - 例：`UserModal`
- `Modal`のファイル名
    - `Modal`のクラス名（末尾に`Modal`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user.dart`
- `Controller`のクラス名
    - 末尾に`Controller`を付与しPascalCaseで記載。
    - 例：`UserController`
- `Controller`のファイル名
    - `Controller`のクラス名（末尾に`Controller`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user.dart`
- `Enum`のクラス名
    - 末尾に`Enum`を付与しPascalCaseで記載。
    - 例：`UserStatusEnum`
- `Enum`のファイル名
    - `Enum`のクラス名（末尾に`Enum`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user_status.dart`
- `Adapter`のクラス名
    - 末尾に`Adapter`を付与しPascalCaseで記載。
    - 例：`UserAdapter`
- `Adapter`のファイル名
    - `Adapter`のクラス名（末尾に`Adapter`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`user.dart`
- `RedirectQuery`のクラス名
    - 末尾に`RedirectQuery`を付与しPascalCaseで記載。
    - 例：`LoginRequiredRedirectQuery`
- `RedirectQuery`のファイル名
    - `RedirectQuery`のクラス名（末尾に`RedirectQuery`を付与しない）をSnakeCaseに変換し`.dart`を付与。
    - 例：`login_required.dart`
""";
  }
}
