// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of metadata_design.mdc.
///
/// metadata_design.mdcの中身。
class MetadataDesignMdcCliAiCode extends CliAiCode {
  /// Contents of metadata_design.mdc.
  ///
  /// metadata_design.mdcの中身。
  const MetadataDesignMdcCliAiCode();

  @override
  String get name => "`MetaData設計書`の作成";

  @override
  String get globs => "documents/designs/**/*.md";

  @override
  String get directory => "designs";

  @override
  String get description => "`MetaData設計`の方法と`MetaData設計書`の作成";

  @override
  String body(String baseName, String className) {
    return r"""
[requirements.md](mdc:requirements.md)に記載されている`要件定義`からアプリケーションに相応しい`MetaData設計書`を作成

1. `要件定義`からアプリケーションに相応しい下記の`MetaData設計書`を作成
    - `MetaData`は下記を定義
        - `ApplicationTitle`
            - タイトルの長さは半角で最大30文字、全角で最大15文字。文字数内で収まるのであればサブタイトルを併記してもよい。
            - タイトルが要件定義で与えられている場合はそのまま利用。
        - `ShortApplicationTitle`
            - `ApplicationTitle`から短いタイトルを決定。長さは半角で最大12文字、全角で最大6文字。
            - `ApplicationTitle`が文字数内で収まるのであればそのまま利用。
        - `ApplicationOverview`
            - アプリケーションの概要を記載。半角で最大200文字以内。全角で最大100文字以内。
    - 例：
        ```markdown
        <!-- documents/designs/metadata_design.md -->

        ## ApplicationTitle

        `アプリケーション`

        ## ShortApplicationTitle

        `アプリ`

        ## ApplicationOverview

        モバイル向けのアプリケーションです。AndroidとiOSの両方に対応しています。
        ```
2. 作成した`MetaData設計書`を`documents/designs/metadata_design.md`に保存
""";
  }
}
