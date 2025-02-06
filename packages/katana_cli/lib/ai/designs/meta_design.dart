import 'package:katana_cli/katana_cli.dart';

/// Contents of meta_design.mdc.
///
/// meta_design.mdcの中身。
class MetaDesignMdcCliAiCode extends CliAiCode {
  /// Contents of meta_design.mdc.
  ///
  /// meta_design.mdcの中身。
  const MetaDesignMdcCliAiCode();

  @override
  String get name => "メタデータ設計書の作成";

  @override
  String get globs => "*.md";

  @override
  String get directory => "designs";

  @override
  String get description => "Masamuneフレームワークによるメタデータの設計書の作成";

  @override
  String body(String baseName, String className) {
    return r"""
[requirements.md](mdc:requirements.md)に記載されている`要件定義`からアプリケーションに相応しい`メタデータ設計書`を作成

1. `要件定義`からアプリケーションに相応しい下記の`メタデータ設計書`を作成
    - メタデータは下記を定義
        - `アプリケーションタイトル`
            - タイトルの長さは半角で最大30文字、全角で最大15文字。文字数内で収まるのであればサブタイトルを併記してもよい。
            - タイトルが要件定義で与えられている場合はそのまま利用。
        - `短いアプリケーションタイトル`
            - `アプリケーションタイトル`から短いタイトルを決定。長さは半角で最大12文字、全角で最大6文字。
            - `アプリケーションタイトル`が文字数内で収まるのであればそのまま利用。
        - `アプリケーションの概要`
            - アプリケーションの概要を記載。半角で最大200文字以内。全角で最大100文字以内。
    - 例：
        ```markdown
        <!-- documents/designs/meta_design.md -->

        ## アプリケーションタイトル

        `アプリケーション`

        ## 短いアプリケーションタイトル

        `アプリ`

        ## アプリケーションの概要

        モバイル向けのアプリケーションです。AndroidとiOSの両方に対応しています。
        ```
2. 作成した`メタデータ設計書`を`documents/designs/meta_design.md`に保存
""";
  }
}
