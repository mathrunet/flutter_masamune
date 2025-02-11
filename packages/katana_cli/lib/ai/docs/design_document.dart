// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of design_document.mdc.
///
/// design_document.mdcの中身。
class DesignDocumentDocsMdcCliAiCode extends CliAiCode {
  /// Contents of design_document.mdc.
  ///
  /// design_document.mdcの中身。
  const DesignDocumentDocsMdcCliAiCode();

  @override
  String get name => "設計書一覧";

  @override
  String get description => "アプリケーション開発で利用する設計書一覧";

  @override
  String get globs => "*";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
## 設計書一覧

アプリケーション開発で利用する設計書一覧を下記に記載。

- **要件定義書**
    - アプリケーションの要件を定義。
- **Model設計書**
    - `Model`の設計を定義。
- **Theme設計書**
    - `Theme`の設計を定義。
- **Plugin設計書**
    - `Plugin`の設計を定義。
- **Controller設計書**
    - `Controller`の設計を定義。
- **Page設計書**
    - `Page`の設計を定義。
- **MetaData設計書**
    - `MetaData`の設計を定義。
""";
  }
}
