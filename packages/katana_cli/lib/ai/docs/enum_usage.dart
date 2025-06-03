// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of enum_usage.md.
///
/// enum_usage.mdの中身。
class EnumUsageMdCliAiCode extends CliAiCode {
  /// Contents of enum_usage.md.
  ///
  /// enum_usage.mdの中身。
  const EnumUsageMdCliAiCode();

  @override
  String get name => "`Enum`の実装方法";

  @override
  String get description => "列挙型の実装方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
列挙型`Enum`の実装は下記の方法で行う。

1. 下記のコマンドを実行して`lib/enums`フォルダに列挙型を作成する。

    ```bash
    katana code enum [EnumName(SnakeCase)]
    ```

2. `lib/enums/[EnumName(SnakeCase)].dart`に列挙型が作成される。
    - 例：
        ```dart
        // lib/enums/priority.dart

        /// Enum for Priority.
        enum PriorityEnum {
        }
        ```
3. 項目を追加する。
    - 項目はカンマで区切る。
    - 実装しやすいように項目の最後にセミコロンを付ける。
    - 例：
        ```dart
        // lib/enums/priority.dart

        /// Enum for Priority.
        enum PriorityEnum {
            low,
            medium,
            high;
        }
        ```

4. 様々なプロパティを付与。
    - 各項目ごとのラベルやデザイン、プロパティなどを付与したい場合は、各種メソッドを作成して値を取得できるようにする。
    - 不要であれば実施しなくてもよい。
    - 例：
        ```dart
        // lib/enums/priority.dart

        /// Enum for Priority.
        enum PriorityEnum {
            low,
            medium,
            high;

            /// ラベルを取得する。
            String get label => switch (this) {
                low => "低",
                medium => "中",
                high => "高",
            };

            /// 色を取得する。
            String get color => switch (this) {
                low => Colors.blue,
                medium => Colors.green,
                high => Colors.red,
            };
        }
        ```
""";
  }
}
