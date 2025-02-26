// Project imports:
import 'package:katana_cli/ai/docs/model_field_value/model_counter.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_date.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_date_range.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_geo_value.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_image_uri.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_locale.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_localized_value.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_ref.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_search.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_time.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_time_range.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_timestamp.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_timestamp_range.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_token.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_uri.dart';
import 'package:katana_cli/ai/docs/model_field_value/model_video_uri.dart';
import 'package:katana_cli/katana_cli.dart';

/// List of ModelFieldValue types.
///
/// ModelFieldValueタイプのリスト。
const kModelFieldValueList = {
  "ModelCounter": ModelFieldValueModelCounterMdcCliAiCode(),
  "ModelGeoValue": ModelFieldValueModelGeoValueMdcCliAiCode(),
  "ModelImageUri": ModelFieldValueModelImageUriMdcCliAiCode(),
  "ModelLocale": ModelFieldValueModelLocaleMdcCliAiCode(),
  "ModelLocalizedValue": ModelFieldValueModelLocalizedValueMdcCliAiCode(),
  "ModelRef": ModelFieldValueModelRefMdcCliAiCode(),
  "ModelSearch": ModelFieldValueModelSearchMdcCliAiCode(),
  "ModelToken": ModelFieldValueModelTokenMdcCliAiCode(),
  "ModelTimestamp": ModelFieldValueModelTimestampMdcCliAiCode(),
  "ModelTimestampRange": ModelFieldValueModelTimestampRangeMdcCliAiCode(),
  "ModelTime": ModelFieldValueModelTimeMdcCliAiCode(),
  "ModelTimeRange": ModelFieldValueModelTimeRangeMdcCliAiCode(),
  "ModelDate": ModelFieldValueModelDateMdcCliAiCode(),
  "ModelDateRange": ModelFieldValueModelDateRangeMdcCliAiCode(),
  "ModelUri": ModelFieldValueModelUriMdcCliAiCode(),
  "ModelVideoUri": ModelFieldValueModelVideoUriMdcCliAiCode(),
};

/// Contents of model_field_value.mdc.
///
/// model_field_value.mdcの中身。
abstract class ModelFieldValueCliAiCode extends CliAiCode {
  /// Contents of model_field_value.mdc.
  ///
  /// model_field_value.mdcの中身。
  const ModelFieldValueCliAiCode();

  /// Excerpt of the model field value.
  ///
  /// モデルフィールド値の概要。
  String get excerpt;
}

/// Contents of model_field_value_usage.mdc.
///
/// model_field_value_usage.mdcの中身。
class ModelFieldValueUsageMdcCliAiCode extends CliAiCode {
  /// Contents of model_field_value_usage.mdc.
  ///
  /// model_field_value_usage.mdcの中身。
  const ModelFieldValueUsageMdcCliAiCode();

  @override
  String get name => "`ModelFieldValue`の利用方法";

  @override
  String get description => "様々な場所で利用可能なタイプである`ModelFieldValue`の利用方法";

  @override
  String get globs => "*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    var header = r"""
様々な場所で利用可能なタイプである`ModelFieldValue`の一覧と利用方法を下記に記載する。

## 利用可能な場所一覧

- `Model`の`DataField`におけるタイプ
- `Page`や`Widget`、`Controller`等のコンストラクタパラメーター
- `Page`や`Widget`、`Controller`等のフィールド
- 各関数やメソッドの引数と戻り値
- 処理内の変数

## `ModelFieldValue`の一覧

| Type | Summary | Usage |
| --- | --- | --- |
""";
    for (final entry in kModelFieldValueList.entries) {
      header +=
          "| `${entry.key}` | ${entry.value.excerpt} | [Usage](mdc:.cursor/rules/model_field_value/${entry.key.toSnakeCase()}.mdc) |\n";
    }
    return header;
  }
}
