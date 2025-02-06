import 'package:katana_cli/katana_cli.dart';

/// Contents of model_design.mdc.
///
/// model_design.mdcの中身。
class ModelDesignMdcCliAiCode extends CliAiCode {
  /// Contents of model_design.mdc.
  ///
  /// model_design.mdcの中身。
  const ModelDesignMdcCliAiCode();

  @override
  String get name => "モデル設計書の作成";

  @override
  String get globs => "*.md";

  @override
  String get directory => "designs";

  @override
  String get description => "Masamuneフレームワークによるモデル設計書の作成";

  @override
  String body(String baseName, String className) {
    return r"""
[screen_design.md](mdc:documents/designs/screen_design.md)に記載されている`画面設計書`から`モデル設計書`を作成

1. `画面設計書`から`モデル設計書`を作成
    - 各画面に対して必要なモデルを類推
    - 類推した各モデルに対して下記を定義
        - `モデル名`
            - 末尾にModelはつけない形でPascalCaseで定義
        - `モデルタイプ`
            - 下記から選択 
            - `Document`
                - キーと値のペアのデータの塊
                - 同一の構成で複数のデータは保存不可
            - `Collection`
                - `Document`を複数集めた塊
                - 同一の構成で複数のデータが保存可能。特定の条件を指定し一致するドキュメントのみを抽出することが可能。
        - `モデルパス`
            - Firestoreの`Collection Path`、`Document Path`と同じように定義（e.g. `user/:user_id/friends`）
            - `/`で階層を記述。
            - 空の名前の階層は作らない（`//`といった記述はない）
            - 先頭および末尾に`/`は記述しない。
            - `モデルタイプ`が`Collection`の場合奇数階層。（e.g. `user/:user_id/friends`）
            - `モデルタイプ`が`Document`の場合偶数階層。（e.g. `apps/setting`）
            - 各階層で`:`が先頭に付与されている場合、`:`を除いた名前の変数となる。（e.g. `user/:user_id/friends`の場合は`user_id`が変数）
            - データ構造として**とある要素が持つ要素**がある場合、その要素は親要素の下階層に入れる。さらにその時親要素のドキュメントIDが間に入る。
                - ユーザーのデータとユーザーが持つフレンドという構成要素がある場合、`user`というコレクションと各`user`ドキュメントのID（`user_id`）を親に持つ`user/:user_id/friends`というコレクションを作成
        - `概要`
            - モデルに対する概要を定義 
        - `データフィールド`
            - 各モデルが持つデータのフィールド
            - 各`データフィールド`に対して下記を定義
                - `フィールド名`
                    - データフィールドの名前をCamelCaseで定義
                - `タイプ`
                    - データフィールドの型を定義。下記から選択。
                    | タイプ | 概要 |
                    | --- | --- |
                    | `String` | 文字列。 |
                    | `int` | 整数。 |
                    | `double` | 小数。 |
                    | `bool` | 真偽値。 |
                    | `enum` | 列挙体。`katana code enum xxxx`でコードを出力した後`enum XxxEnum {}`にて定義された列挙体名が入る。選択肢が限られている場合はこちらを優先して利用。 |
                    | `List<[タイプ]>` | タイプを配列として複数持ちたい場合に利用。[タイプ]にはListも含めたその他タイプが入る。 |
                    | `Map<String, [タイプ]>` | タイプを連想配列として複数持ちたい場合に利用。キーには必ず`String`が入り[タイプ]にはMapも含めたその他タイプが入る。 |
                    | `Set<[タイプ]>` | タイプを重複禁止の配列として複数持ちたい場合に利用。[タイプ]にはSetも含めたその他タイプが入る。 |
                    | `ModelRef<[モデル名]>` | 他モデルへの参照を行いたい場合はそのモデル名を指定して定義。 |
                    | `ModelCounter` | カウントアップ、カウントダウンを正確に行いたい場合の整数を定義する際に優先して利用。 |
                    | `ModelTimestamp` | 日時を定義する際に優先して利用。Dartの`DateTime`を利用する場合こちらに必ず変換 |
                    | `ModelDate` | 日付のみを定義する際に優先して利用。 |
                    | `ModelUri` | 画像や映像以外のURLやURIを保存する際に優先して利用。 |
                    | `ModelImageUri` | 画像のURLやURIを保存する際に優先して利用。 |
                    | `ModelVideoUri` | 映像のURLやURIを保存する際に優先して利用。 |
                    | `ModelGeoValue` | 位置情報（緯度、経度）を保存する際に優先して利用。 |
                    | `ModelLocale` | ロケール（`ja_JP`、`en_US`等）を保存する際に優先して利用。 |
                    | `ModelLocalizedValue` | 各ロケールに対応した文字列を保存する際に利用。 |
                    | `ModelSearch` | 検索対象となる文字列のリストを保存する際に利用。 |
                    | `ModelToken` | Push通知のトークンなど複数トークンを保存する際に優先して利用。 |
                - `必須かどうか`
                    - `必須`もしくは`任意`
                - `デフォルト値`
                    - `任意`の場合入力されなかった場合のデフォルトの値 
                - `概要`
                    - データフィールドの概要 
    - 例：
        ```markdown
        <!-- documents/designs/model_design.md -->
        
        ## メモ
        
        ### モデル名
        
        `Memo`

        ### モデルタイプ

        `Collection`
        
        ### モデルパス
        
        `memo`
        
        ### 概要
        
        実際のメモの内容を保存するデータ一覧
        
        ### フィールド
        
        | データフィールド | フィールド名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
        | --- | --- | --- | --- | --- | --- |
        | タイトル | `title` | String | 必須 |  | メモのタイトル |
        | コンテンツ | `content` | String | 必須 |  | メモの内容 |
        | 添付画像 | `images` | List<ModelImageUri> | 任意 | [] | メモの添付画像（複数可） |
        | 作成者 | `createdBy` | ModelRef<UserModel> | 必須 |  | メモの作成者。UserModelに紐づけ。 |
        | 作成日時 | `createdAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | メモが作成された日時。 |
        | 更新日時 | `updatedAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | メモが更新された日時。 |
        | タグ | `tags` | List<ModelRef<UserModel>> | 任意 | [] | メモに付与されたタグ。TagModelを複数紐づけ。 |
        
        ## ユーザー
        
        ### モデル名
        
        `User`

        ### モデルタイプ

        `Collection`
        
        ### モデルパス
        
        `user`
        
        ### 概要
        
        メモの作成者を保存するデータ一覧。アプリ内に埋め込む予定。
        
        ### フィールド
        
        | データフィールド | フィールド名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
        | --- | --- | --- | --- | --- | --- |
        | 名前 | `name` | String | 必須 |  | ユーザー名。 |
        | 自己紹介 | `introduction` | String | 任意 |  | ユーザーの自己紹介文。 |
        | アイコン | `icon` | ModelImageUri | 任意 |  | ユーザーアイコンの画像URL。 |
        | 作成日時 | `createdAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | ユーザーが作成された日時。 |
        | 更新日時 | `updatedAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | ユーザーが更新された日時。 |
        
        ## タグ
        
        ### モデル名
        
        `Tag`

        ### モデルタイプ

        `Collection`
        
        ### モデルパス
        
        `tag`
        
        ### 概要
        
        メモに付与されるタグの一覧を保存するデータ一覧
        
        ### フィールド
        
        | データフィールド | フィールド名 | タイプ | 必須かどうか | デフォルト値 | 概要 |
        | --- | --- | --- | --- | --- | --- |
        | タグ名 | `name` | String | 必須 |  | タグ名。 |
        | 作成日時 | `createdAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | タグが作成された日時。 |
        | 更新日時 | `updatedAt` | ModelTimestamp | 任意 | ModelTimestamp.now() | タグが更新された日時。 |
        ``` 
2. 作成した`モデル設計書`を`documents/designs/model_design.md`に保存
""";
  }
}
