// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Contents of model_design.md.
///
/// model_design.mdの中身。
class ModelDesignMdCliAiCode extends CliAiCode {
  /// Contents of model_design.md.
  ///
  /// model_design.mdの中身。
  const ModelDesignMdCliAiCode();

  @override
  String get name => "`Model設計書`の作成";

  @override
  String get globs => "documents/designs/**/*.md";

  @override
  String get directory => "designs";

  @override
  String get description => "`Model設計`の方法と`Model設計書`の作成";

  @override
  String body(String baseName, String className) {
    return r"""
`documents/designs/page_design.md`に記載されている`Page設計書`から`Model設計書`を作成

1. `Page設計書`から`Model設計書`を作成
    - 各`Page`に対して必要な`Model`を類推
    - 類推した各`Model`に対して下記を定義
        - `Model名`
            - 末尾にModelはつけない形でPascalCaseで定義
        - `ModelType`
            - 下記から選択 
                - `Document`
                    - キーと値のペアのデータの塊
                    - 同一の構成で複数のデータは保存不可
                - `Collection`
                    - `Document`を複数集めた塊
                    - 同一の構成で複数のデータが保存可能。特定の条件を指定し一致する`Document`のみを抽出することが可能。
        - `ModelPath`
            - Firestoreの`CollectionPath`、`DocumentPath`と同じように定義（e.g. `user/:user_id/friends`）
            - `/`で階層を記述。
            - 空の名前の階層は作らない（`//`といった記述はない）
            - 先頭および末尾に`/`は記述しない。
            - `ModelType`が`Collection`の場合奇数階層。（e.g. `user/:user_id/friends`）
            - `ModelType`が`Document`の場合偶数階層。（e.g. `apps/setting`）
            - 各階層で`:`が先頭に付与されている場合、`:`を除いた名前の変数となる。（e.g. `user/:user_id/friends`の場合は`user_id`が変数）
            - データ構造として**とある要素が持つ要素**がある場合、その要素は親要素の下階層に入れる。さらにその時親要素の`DocumentID`が間に入る。
                - ユーザーのデータとユーザーが持つフレンドという構成要素がある場合、`user`という`Collection`と各`user`の`DocumentID`（`user_id`）を親に持つ`user/:user_id/friends`という`Collection`を作成
        - `Summary`
            - `Model`に対する概要を定義 
        - `DataField`
            - 各`Model`が持つデータのフィールド
            - 各`DataField`に対して下記を定義
                - `DataFieldName`
                    - `DataField`の名前をCamelCaseで定義
                - `DataFieldType`
                    - `DataField`のタイプを定義。**必ず**下記から選択。
                        - ModelFieldValue(`documents/rules/docs/model_field_value_usage.md`)
                        - プリミティブタイプ(`documents/rules/docs/primitive_types.md`)
                - `RequiredOrOptional`
                    - `Required`もしくは`Optional`
                - `DefaultValue`
                    - `Optional`の場合入力されなかった場合のデフォルトの値 
                - `Summary`
                    - `DataField`の概要 
    - 例：
        ```markdown
        <!-- documents/designs/model_design.md -->
        
        ## メモ
        
        ### ModelName
        
        `Memo`

        ### ModelType

        `Collection`
        
        ### ModelPath
        
        `memo`
        
        ### Summary
        
        実際のメモの内容を保存するデータ一覧
        
        ### DataField
        
        | DataField | DataFieldName | DataFieldType | RequiredOrOptional | DefaultValue | Summary |
        | --- | --- | --- | --- | --- | --- |
        | タイトル | `title` | String | Required |  | メモのタイトル |
        | コンテンツ | `content` | String | Required |  | メモの内容 |
        | 添付画像 | `images` | List<ModelImageUri> | Optional | [] | メモの添付画像（複数可） |
        | 作成者 | `createdBy` | ModelRef<UserModel> | Required |  | メモの作成者。UserModelに紐づけ。 |
        | 作成日時 | `createdAt` | ModelTimestamp | Optional | ModelTimestamp.now() | メモが作成された日時。 |
        | 更新日時 | `updatedAt` | ModelTimestamp | Optional | ModelTimestamp.now() | メモが更新された日時。 |
        | タグ | `tags` | List<ModelRef<UserModel>> | Optional | [] | メモに付与されたタグ。TagModelを複数紐づけ。 |
        
        ## ユーザー
        
        ### ModelName
        
        `User`

        ### ModelType

        `Collection`
        
        ### ModelPath
        
        `user`
        
        ### Summary
        
        メモの作成者を保存するデータ一覧。アプリ内に埋め込む予定。
        
        ### DataField
        
        | DataField | DataFieldName | DataFieldType | RequiredOrOptional | DefaultValue | Summary |
        | --- | --- | --- | --- | --- | --- |
        | 名前 | `name` | String | Required |  | ユーザー名。 |
        | 自己紹介 | `introduction` | String | Optional |  | ユーザーの自己紹介文。 |
        | アイコン | `icon` | ModelImageUri | Optional |  | ユーザーアイコンの画像URL。 |
        | 作成日時 | `createdAt` | ModelTimestamp | Optional | ModelTimestamp.now() | ユーザーが作成された日時。 |
        | 更新日時 | `updatedAt` | ModelTimestamp | Optional | ModelTimestamp.now() | ユーザーが更新された日時。 |
        
        ## タグ
        
        ### ModelName
        
        `Tag`

        ### ModelType

        `Collection`
        
        ### ModelPath
        
        `tag`
        
        ### Summary
        
        メモに付与されるタグの一覧を保存するデータ一覧
        
        ### DataField
        
        | DataField | DataFieldName | DataFieldType | RequiredOrOptional | DefaultValue | Summary |
        | --- | --- | --- | --- | --- | --- |
        | タグ名 | `name` | String | Required |  | タグ名。 |
        | 作成日時 | `createdAt` | ModelTimestamp | Optional | ModelTimestamp.now() | タグが作成された日時。 |
        | 更新日時 | `updatedAt` | ModelTimestamp | Optional | ModelTimestamp.now() | タグが更新された日時。 |
        ``` 
2. 作成した`Model設計書`を`documents/designs/model_design.md`に保存
""";
  }
}
