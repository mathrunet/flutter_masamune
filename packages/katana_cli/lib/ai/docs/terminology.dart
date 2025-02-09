// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of terminology.mdc.
///
/// terminology.mdcの中身。
class TerminologyDocsMdcCliAiCode extends CliAiCode {
  /// Contents of terminology.mdc.
  ///
  /// terminology.mdcの中身。
  const TerminologyDocsMdcCliAiCode();

  @override
  String get name => "用語一覧";

  @override
  String get description => "アプリケーション開発で利用する用語一覧";

  @override
  String get globs =>
      "lib/**/*.dart, test/**/*.dart, katana.yaml, documents/designs/**/*.md, firebase/functions/src/**/*.ts, firebase/functions/test/**/*.ts";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
## 用語集

アプリケーション開発で利用する用語一覧を下記に記載。

- `App`
    - アプリケーションそのものを指す。
- `Model`
    - データモデル。複数の`DataField`の集合体。Firestoreでは`Document`に値する。複数の`Model`の集合体を`Collection`と呼ぶ。
- `Page`
    - 画面。複数の`Widget`から構成される。
- `Widget`
    - 画面の最小単位。FlutterのWidgetと同義。
- `Modal`
    - モーダル。画面の上に表示されるダイアログやモーダルウィンドウのことを指す。
- `Controller`
    - コントローラー。異なる`Page`間でデータを保持したり、アプリ内の操作を管理する。
- `State`
    - アプリケーションの中で保持されている状態。`Page`や`Widget`、`Modal`、`Controller`や`RedirectQuery`内で利用される。状態は`Controller`や`Model`、`Plugin`が管理するもののみではなく、`ValueNotifier`を通して変数等を利用することも可能。
- `Theme`
    - テーマ。アプリケーションのデザインを定義。
- `Plugin`
    - プラグイン。アプリケーション内で利用するための様々な機能をパッケージとして提供。
- `MetaData`
    - メタデータ。`App`に関する情報を管理。
- `Enum`
    - 列挙型。有限の値の集合を定義。
- `Adapter`
    - アダプター。異なるデータベースやAPIとの接続を管理。
- `RedirectQuery`
    - リダイレクト管理。`Page`を表示する前に条件分岐を行い別の`Page`にリダイレクトが可能。
- `Localization`
    - 多言語対応。アプリケーション内で利用するテキストを各国の言語に対応させる。
- `Router`
    - ルーティング。`Page`間の遷移を管理。
""";
  }
}
