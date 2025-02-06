import 'package:katana_cli/katana_cli.dart';

/// Contents of model_usage.mdc.
///
/// model_usage.mdcの中身。
class ModelUsageMdcCliAiCode extends CliAiCode {
  /// Contents of model_usage.mdc.
  ///
  /// model_usage.mdcの中身。
  const ModelUsageMdcCliAiCode();

  @override
  String get name => "`Model`の実装方法";

  @override
  String get description => "Masamuneフレームワークによる`Model`の実装方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    return r"""
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
                - `DataField`が必須の場合は`DataFieldType`の前に`required`を付与。
                - 任意でかつデフォルト値が存在する場合は`@Default([DefaultValue])`のAnnotationを付与。
                - 任意でかつデフォルト値が存在しない場合は`DataFieldType`の末尾に`?`を付与しNullableにする
            - 例：
                - `MemoModel`（`ModelType`: `Collection`）
                  ```dart
                  // lib/models/memo.dart

                  // ignore: unused_import, unnecessary_import
                  import 'package:flutter/material.dart';
                  // ignore: unused_import, unnecessary_import
                  import 'package:masamune/masamune.dart';

                  // ignore: unused_import, unnecessary_import
                  import '/main.dart';

                  import 'package:freezed_annotation/freezed_annotation.dart';

                  part 'memo.m.dart';
                  part 'memo.g.dart';
                  part 'memo.freezed.dart';

                  /// Value for model.
                  @freezed
                  @formValue
                  @immutable
                  // TODO: Set the path for the collection.
                  @CollectionModelPath("memo")
                  class MemoModel with _$MemoModel {
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

                  /// Alias for ModelRef<MemoModel>.
                  ///
                  /// When defining parameters for other Models, you can define them as follows
                  ///
                  /// ```dart
                  /// @RefParam(MemoModelDocument) MemoModelRef memo
                  /// ```
                  typedef MemoModelRef = ModelRef<MemoModel>?;

                  /// It can be defined as an empty ModelRef<MemoModel>.
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

                  /// It can be defined as an empty ModelRef<MemoModel>.
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
                  import 'package:flutter/material.dart';
                  // ignore: unused_import, unnecessary_import
                  import 'package:masamune/masamune.dart';

                  // ignore: unused_import, unnecessary_import
                  import '/main.dart';

                  import 'package:freezed_annotation/freezed_annotation.dart';

                  part 'setting.m.dart';
                  part 'setting.g.dart';
                  part 'setting.freezed.dart';

                  /// Value for model.
                  @freezed
                  @formValue
                  @immutable
                  // TODO: Set the path for the document.
                  @DocumentModelPath("app/setting")
                  class AppSettingModel with _$AppSettingModel {
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

                  /// Alias for ModelRef<AppSettingModel>.
                  ///
                  /// When defining parameters for other Models, you can define them as follows
                  ///
                  /// ```dart
                  /// @RefParam(AppSettingModelDocument) AppSettingModelRef setting
                  /// ```
                  typedef AppSettingModelRef = ModelRef<AppSettingModel>?;

                  /// It can be defined as an empty ModelRef<AppSettingModel>.
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

                  /// It can be defined as an empty ModelRef<AppSettingModel>.
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
""";
  }
}
