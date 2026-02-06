# `Model`の実装方法とその利用方法

## `Model`の実装方法

新しく`Model`を作成する場合は下記の流れに沿って実装を行う。

1. `Model`に対し下記を実行
    1. `ModelType`に応じて下記コマンドを実行 
        - `Collection`
        
            ```bash
            katana code collection [ModelName(SnakeCase)]
            ```
        
        - `Document`
        
            ```bash
            katana code document [ModelName(SnakeCase)]
            ```
        
        - `Value`
        
            ```bash
            katana code value [ModelName(SnakeCase)]
            ```
    2. コマンド実行後、`lib/models`以下に[ModelName(SnakeCase)].dartファイルが作成される
    3. 生成されたdartファイルを書き換える
        1. `@CollectionModelPath`（`ModelType`が`Document`の場合は`@DocumentModelPath`）のAnnotationに対応する`ModelPath`を記載。
        2. `// TODO: Set the data fields.`以下に定義した`DataField`を追記。
            - 各フィールドには`DataFieldType`と`DataFieldName`（CamelCase）を記載。
                - `DataFieldType`は*必ず*下記のタイプから選択する。
                    - ModelFieldValue(`documents/rules/docs/model_field_value_usage.md`)
                    - プリミティブタイプ(`documents/rules/docs/primitive_types.md`)                    
                - `DataField`が`Required`の場合は`DataFieldType`の前に`required`を付与。
                - `Optional`でかつ`DefaultValue`が存在する場合は`@Default([DefaultValue])`のAnnotationを付与。
                - `Optional`でかつ`DefaultValue`が存在しない場合は`DataFieldType`の末尾に`?`を付与しNullableにする
            - 例：
                - `MemoModel`（`ModelType`: `Collection`）
                  ```dart
                  // lib/models/memo.dart

                  // ignore: unused_import, unnecessary_import
                  import "package:flutter/material.dart";
                  // ignore: unused_import, unnecessary_import
                  import "package:masamune/masamune.dart";

                  // ignore: unused_import, unnecessary_import
                  import "package:flutter_masamune/main.dart";

                  import "package:freezed_annotation/freezed_annotation.dart";

                  part "memo.m.dart";
                  part "memo.g.dart";
                  part "memo.freezed.dart";

                  /// Value for model.
                  @freezed
                  @formValue
                  @immutable
                  // TODO: Set the path for the collection.
                  @CollectionModelPath("memo")
                  abstract class MemoModel with _$MemoModel {
                    /// Value for model.
                    const factory MemoModel({
                      // TODO: Set the data fields.
                      required String title,
                      required String content,
                      @Default([]) List<ModelImageUri> images,
                      required ModelRef<UserModel> createdBy,
                      @Default(ModelTimestamp.now()) ModelTimestamp createdAt,
                      @Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
                      @Default([]) List<ModelRef<TagModel>> tags,
                    }) = _MemoModel;
                    const MemoModel._();

                    /// Convert from JSON.
                    ///
                    /// ```dart
                    /// MemoModel.fromJson(json);
                    /// ```
                    factory MemoModel.fromJson(Map<String, Object?> json) => _$MemoModelFromJson(json);

                    /// Query for document.
                    ///
                    /// ```dart
                    /// appRef.model(MemoModel.document(id));       // Get the document.
                    /// ref.app.model(MemoModel.document(id))..load();  // Load the document.
                    /// ```
                    static const document = _$MemoModelDocumentQuery();

                    /// Query for collection.
                    ///
                    /// ```dart
                    /// appRef.model(MemoModel.collection());       // Get the collection.
                    /// ref.app.model(MemoModel.collection())..load();  // Load the collection.
                    /// ref.app.model(
                    ///   MemoModel.collection().data.equal(
                    ///     "data",
                    ///   )
                    /// )..load(); // Load the collection with filter.
                    /// ```
                    static const collection = _$MemoModelCollectionQuery();

                    /// Query for form value.
                    ///
                    /// ```dart
                    /// ref.app.form(MemoModel.form(MemoModel()));    // Get the form controller in app scope.
                    /// ref.page.form(MemoModel.form(MemoModel()));    // Get the form controller in page scope.
                    /// ```
                    static const form = _$MemoModelFormQuery();
                  }

                  /// [Enum] of the name of the value defined in MemoModel.
                  typedef MemoModelKeys = _$MemoModelKeys;

                  /// Alias for ModelRef&lt;MemoModel&gt;.
                  ///
                  /// When defining parameters for other Models, you can define them as follows
                  ///
                  /// ```dart
                  /// @RefParam(MemoModelDocument) MemoModelRef memo
                  /// ```
                  typedef MemoModelRef = ModelRef<MemoModel>?;

                  /// It can be defined as an empty ModelRef&lt;MemoModel&gt;.
                  ///
                  /// ```dart
                  /// MemoModelRefPath("xxx") // Define as a path.
                  /// ```
                  typedef MemoModelRefPath = _$MemoModelRefPath;

                  /// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
                  ///
                  /// ```dart
                  /// RuntimeModelAdapter(
                  ///   initialValue: [
                  ///     MemoModelInitialCollection(
                  ///       "xxx": MemoModel(...),
                  ///     ),
                  ///   ],
                  /// );
                  /// ```
                  typedef MemoModelInitialCollection = _$MemoModelInitialCollection;

                  /// Document class for storing MemoModel.
                  typedef MemoModelDocument = _$MemoModelDocument;

                  /// Collection class for storing MemoModel.
                  typedef MemoModelCollection = _$MemoModelCollection;

                  /// It can be defined as an empty ModelRef&lt;MemoModel&gt;.
                  ///
                  /// ```dart
                  /// MemoModelMirrorRefPath("xxx") // Define as a path.
                  /// ```
                  typedef MemoModelMirrorRefPath = _$MemoModelMirrorRefPath;

                  /// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
                  ///
                  /// ```dart
                  /// RuntimeModelAdapter(
                  ///   initialValue: [
                  ///     MemoModelMirrorInitialCollection(
                  ///       "xxx": MemoModel(...),
                  ///     ),
                  ///   ],
                  /// );
                  /// ```
                  typedef MemoModelMirrorInitialCollection = _$MemoModelMirrorInitialCollection;

                  /// Document class for storing MemoModel.
                  typedef MemoModelMirrorDocument = _$MemoModelMirrorDocument;

                  /// Collection class for storing MemoModel.
                  typedef MemoModelMirrorCollection = _$MemoModelMirrorCollection;
                  ```
                - `AppSettingModel`（`ModelType`: `Document`）
                  ```dart
                  // lib/models/app_setting.dart

                  // ignore: unused_import, unnecessary_import
                  import "package:flutter/material.dart";
                  // ignore: unused_import, unnecessary_import
                  import "package:masamune/masamune.dart";

                  // ignore: unused_import, unnecessary_import
                  import "package:flutter_masamune/main.dart";

                  import "package:freezed_annotation/freezed_annotation.dart";

                  part "setting.m.dart";
                  part "setting.g.dart";
                  part "setting.freezed.dart";

                  /// Value for model.
                  @freezed
                  @formValue
                  @immutable
                  // TODO: Set the path for the document.
                  @DocumentModelPath("app/setting")
                  abstract class AppSettingModel with _$AppSettingModel {
                    const factory AppSettingModel({
                      // TODO: Set the data schema.
                      @Default("1.0.0") String version,
                    }) = _AppSettingModel;
                    const AppSettingModel._();

                    factory AppSettingModel.fromJson(Map<String, Object?> json) => _$AppSettingModelFromJson(json);

                    /// Query for document.
                    ///
                    /// ```dart
                    /// appRef.model(AppSettingModel.document());      // Get the document.
                    /// 
                    /// ref.page.form(CounterModel.form(CounterModel()));    // Get the form controller.(AppSettingModel.document())..load(); // Load the document.
                    /// ```
                    static const document = _$AppSettingModelDocumentQuery();

                    /// Query for form value.
                    ///
                    /// ```dart
                    /// ref.app.form(AppSettingModel.form(AppSettingModel()));    // Get the form controller in app scope.
                    /// ref.page.form(AppSettingModel.form(AppSettingModel()));    // Get the form controller in page scope.
                    /// ```
                    static const form = _$AppSettingModelFormQuery();
                  }

                  /// [Enum] of the name of the value defined in AppSettingModel.
                  typedef AppSettingModelKeys = _$AppSettingModelKeys;

                  /// Alias for ModelRef&lt;AppSettingModel&gt;.
                  ///
                  /// When defining parameters for other Models, you can define them as follows
                  ///
                  /// ```dart
                  /// @RefParam(AppSettingModelDocument) AppSettingModelRef setting
                  /// ```
                  typedef AppSettingModelRef = ModelRef<AppSettingModel>?;

                  /// It can be defined as an empty ModelRef&lt;AppSettingModel&gt;.
                  ///
                  /// ```dart
                  /// AppSettingModelRefPath() // Define as a path.
                  /// ```
                  typedef AppSettingModelRefPath = _$AppSettingModelRefPath;

                  /// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
                  ///
                  /// ```dart
                  /// RuntimeModelAdapter(
                  ///   initialValue: [
                  ///     AppSettingModelInitialDocument(
                  ///       AppSettingModel(...),
                  ///     ),
                  ///   ],
                  /// );
                  /// ```
                  typedef AppSettingModelInitialDocument = _$AppSettingModelInitialDocument;

                  /// Document class for storing AppSettingModel.
                  typedef AppSettingModelDocument = _$AppSettingModelDocument;

                  /// It can be defined as an empty ModelRef&lt;AppSettingModel&gt;.
                  ///
                  /// ```dart
                  /// AppSettingModelMirrorRefPath() // Define as a path.
                  /// ```
                  typedef AppSettingModelMirrorRefPath = _$AppSettingModelMirrorRefPath;

                  /// Class for defining initial values to be passed to `initialValue` of [RuntimeModelAdapter].
                  ///
                  /// ```dart
                  /// RuntimeModelAdapter(
                  ///   initialValue: [
                  ///     AppSettingModelMirrorInitialDocument(
                  ///       AppSettingModel(...),
                  ///     ),
                  ///   ],
                  /// );
                  /// ```
                  typedef AppSettingModelMirrorInitialDocument = _$AppSettingModelMirrorInitialDocument;

                  /// Document class for storing AppSettingModel.
                  typedef AppSettingModelMirrorDocument = _$AppSettingModelMirrorDocument;
                  ```
  2. 下記コマンドを実行して`*.g.dart`、`*.freezed.dart`、`*.m.dart`ファイルを自動生成
        
      ```bash
      katana code generate
      ```

## `Model`の利用方法

実装した`Model`を利用する場合は下記のように実施。

事前に`State`を通して`Model`を取得する。（`State`の利用方法(`documents/rules/docs/state_management_usage.md`) ）

```dart
final collection = appRef.model(AnyModel.collection())..load();
final document = appRef.model(AnyModel.document())..load();
final value = appRef.model(AnyModel.value())..load();
```

### 読み込み（Read）

- `load`メソッドを実行すると`Model`のデータを取得できる。

  ```dart
  await collection.load();
  await document.load();
  ```

- `reload`メソッドを実行すると`Model`のデータを再取得できる。

  ```dart
  await collection.reload();
  await document.reload();
  ```

- `Collection`の場合は`next`メソッドを実行すると次のデータを取得できる。

  ```dart
  await collection.next();
  ```

- `Document`の`value`フィールドに`Model`のデータが格納されている。

  ```dart
  final document = appRef.model(AnyModel.document())..load();
  final model = document.value;
  ```

- `Collection`は`Document`のリストと同義であるためリスト操作が可能。

  ```dart
  final collection = appRef.model(AnyModel.collection())..load();
  final documents = collection.where((document) => document.value?.title.contains("test") ?? false).toList();
  ```

- `Collection`をmodelメソッドに渡す際に`[Documentの対象DataFieldName].[フィルター条件]`という形でメソッドチェーンするとフィルターをかけたデータを取得できる。
  - フィルター条件の種類は`フィルター条件`(`documents/rules/docs/model_filter_conditions.md`)を参照。

  ```dart
  final filteredCollection = appRef.model(
    AnyModel.collection().title.equal("test").createdAt.greaterThan(ModelTimestamp.now()).limitoTo(100)
  )..load();
  ```

### 作成（Create）

- `Document`単位でのみ作成が可能。
    - 対応する`Collection`の`create`メソッドを実行すると`Document`を作成できる。

      ```dart
      final document = appRef.model(AnyModel.collection()).create([documentId]);
      ```
    
    - 作成した`Document`の`save`メソッドにModelデータを渡しながら実行するとデータが保存される。

      ```dart
      await document.save(AnyModel());
      ```

- `Collection`に新しい要素を追加したい場合も同様に`create`メソッドから`Document`を作成し`save`メソッドを実行する。
    - `Document`の`save`メソッドでデータを保存すると自動で`Collection`に追加される。

  ```dart
  final document = appRef.model(AnyModel.collection()).create([documentId]);
  await document.save(AnyModel());
  ```

### 更新（Update）

- `Document`単位でのみ更新が可能。
    - 対応する`Document`の`save`メソッドにModelデータを渡しながら実行するとデータが更新される。
    - `copyWith`メソッドを利用することで更新したいフィールドのみを更新できる。

      ```dart
      await document.save(document.value.copyWith(title: "updated title"));
      ```

### 削除（Delete）

- `Document`単位でのみ削除が可能。
    - 対応する`Document`の`delete`メソッドを実行するとデータが削除される。

      ```dart
      await document.delete();
      ```

- `Collection`から要素を削除したい場合も同様に削除したい`Document`を探し出し`Document`の`delete`メソッドを実行する。

  ```dart
  final collection = appRef.model(AnyModel.collection());
  final deleteDocument = collection.firstWhereOrNull((document) => document.value?.title.contains("test") ?? false);
  await deleteDocument?.delete();
  ```

### 集計（Aggregate）

- `Collection`のデータを集計する場合は`aggregate`メソッドを実行する。
- 集計にはいくつか種類があり`ModelAggregateQuery`を利用して集計方法を指定する。

#### カウント（Count）

- コレクションで取得できるすべてのドキュメント数を取得する。

  ```dart
  final countAggregation = appRef.model(AnyModel.collection()).aggregate(ModelAggregateQuery.count())..load();
  // 読み込み中は`countAggregation.loading`が非nullとなるのでそれを待つ。
  if(countAggregation.loading != null) {
    await countAggregation.loading;
  }
  final count = countAggregation.value; // int?型
  ```

#### 合計（Sum）

- コレクションで取得できるすべてのドキュメントの指定したフィールドの合計値を取得する。
- `sum`メソッドの引数には集計を行う対象のフィールド名を指定する。
  - `AnyModelKeys`に定義されたモデルのフィールド名がEnumで定義されているのでそれを利用してフィールド名をタイプセーフに取得可能。

  ```dart
  final sumAggregation = appRef.model(AnyModel.collection()).aggregate(ModelAggregateQuery.sum(AnyModelKeys.content.name))..load();
  // 読み込み中は`sumAggregation.loading`が非nullとなるのでそれを待つ。
  if(sumAggregation.loading != null) {
    await sumAggregation.loading;
  }
  final sum = sumAggregation.value; // double?型
  ```

#### 平均（Average）

- コレクションで取得できるすべてのドキュメントの指定したフィールドの平均値を取得する。
- `average`メソッドの引数には集計を行う対象のフィールド名を指定する。
  - `AnyModelKeys`に定義されたモデルのフィールド名がEnumで定義されているのでそれを利用してフィールド名をタイプセーフに取得可能。

  ```dart
  final averageAggregation = appRef.model(AnyModel.collection()).aggregate(ModelAggregateQuery.average(AnyModelKeys.content.name))..load();
  // 読み込み中は`averageAggregation.loading`が非nullとなるのでそれを待つ。
  if(averageAggregation.loading != null) {
    await averageAggregation.loading;
  }
  final average = averageAggregation.value; // double?型
  ```
