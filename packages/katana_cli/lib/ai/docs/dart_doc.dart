// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of dart_doc.md.
///
/// dart_doc.mdの中身。
class DartDocDocsMdCliAiCode extends CliAiCode {
  /// Contents of dart_doc.md.
  ///
  /// dart_doc.mdの中身。
  const DartDocDocsMdCliAiCode();

  @override
  String get name => "DartDocの書き方";

  @override
  String get description => "DartDocの書き方。";

  @override
  String get globs => "*";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
## DartDocの書き方

- 基本的にはDartのドキュメントと同じ書き方。
    - `///`を用いてドキュメントを記載
- 公開されているクラスやメソッド、プロパティや変数に対してすべて記載
    - Overrideされたメソッドやプロパティは記載しなくてもOK。
- 英語のドキュメントの下に必ず日本語のドキュメントも合わせて記載
    - 利用例のコードを書く場合は日本語の下に記載。
    - 例：
    ```dart
    /// Test page for DartDoc.
    /// 
    /// DartDoc用のテストページ。
    /// 
    /// ```dart
    /// TestPage();
    /// ```
    class TestPage extends StatelessWidget {
        /// Test page for DartDoc.
        /// 
        /// DartDoc用のテストページ。
        const TestPage({super.key});
        
        @override
        Widget build(BuildContext context) {
            return const Placeholder();
        }
    }
    ```
""";
  }
}
