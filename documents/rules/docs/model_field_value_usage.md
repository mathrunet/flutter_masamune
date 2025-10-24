# `ModelFieldValue`の利用方法

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
| `ModelCounter` | 内部にintを保持し数字を扱えるようにしながら数字のインクリメントやデクリメントをサーバー側で行えるようにしたオブジェクト。 | Usage(`documents/rules/model_field_value/model_counter.md`) |
| `ModelGeoValue` | 地理座標（緯度・経度）を扱うためのクラス。位置情報の保存や位置情報に基づく検索に利用可能。 | Usage(`documents/rules/model_field_value/model_geo_value.md`) |
| `ModelImageUri` | 画像のURIを扱うためのクラス。画像ファイルのパスやURLを保存・管理するために利用可能。`ModelUri`の特殊化バージョンで、画像ファイル専用の機能を提供。 | Usage(`documents/rules/model_field_value/model_image_uri.md`) |
| `ModelLocale` | 内部に`Locale`を保持し言語設定を扱えるようにしながらJsonにパースしやすくしたオブジェクト。 | Usage(`documents/rules/model_field_value/model_locale.md`) |
| `ModelLocalizedValue` | 多言語対応のテキストを扱うためのクラス。言語コードごとに異なる値を保持し、現在の言語設定に応じて適切な値を返す。 | Usage(`documents/rules/model_field_value/model_localized_value.md`) |
| `ModelRef` | 別`Model`への参照を扱うためのクラス。データベースの外部キーのような役割を果たし、モデル間の関連を管理する。`Document`の実装を含んでおり、データがある場合は`Document`のように利用可能。 | Usage(`documents/rules/model_field_value/model_ref.md`) |
| `ModelSearch` | 検索可能なフィールドを定義します。値を検索可能な値として保存し、[ModelQueryFilter.equal]で定義されたものがすべて含まれる要素を検索することが可能。カテゴリー検索等に利用可能。 | Usage(`documents/rules/model_field_value/model_search.md`) |
| `ModelToken` | 複数トークンを保存するためのクラス。PUSH通知のトークン管理等に利用可能。 | Usage(`documents/rules/model_field_value/model_token.md`) |
| `ModelTimestamp` | 内部に`DateTime`を保持し日時を扱えるようにしながらJsonにパースしやすくしたオブジェクト。 | Usage(`documents/rules/model_field_value/model_timestamp.md`) |
| `ModelTimestampRange` | 内部に`DateTimeRange`を保持し日時の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクト。 | Usage(`documents/rules/model_field_value/model_timestamp_range.md`) |
| `ModelTime` | 内部に`DateTime`を保持し時刻を扱えるようにしながらJsonにパースしやすくしたオブジェクト。 | Usage(`documents/rules/model_field_value/model_time.md`) |
| `ModelTimeRange` | 内部に`DateTimeRange`を保持し時刻の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクト。 | Usage(`documents/rules/model_field_value/model_time_range.md`) |
| `ModelDate` | 内部に`DateTime`を保持し日付を扱えるようにしながらJsonにパースしやすくしたオブジェクト。時刻は含まれず、日付のみを扱う。 | Usage(`documents/rules/model_field_value/model_date.md`) |
| `ModelDateRange` | 内部に`DateTimeRange`を保持し日付の範囲を扱えるようにしながらJsonにパースしやすくしたオブジェクト。時刻は含まれず、日付のみを扱う。 | Usage(`documents/rules/model_field_value/model_date_range.md`) |
| `ModelUri` | URIを扱うためのクラス。ファイルパスやURLなどのURIを保存・管理するために利用可能。 | Usage(`documents/rules/model_field_value/model_uri.md`) |
| `ModelVectorValue` | ベクトルデータ(埋め込みベクトル)を扱うためのクラス。RAG(Retrieval-Augmented Generation)やベクトル類似度検索、セマンティック検索に利用可能。 | Usage(`documents/rules/model_field_value/model_vector_value.md`) |
| `ModelVideoUri` | 動画のURIを扱うためのクラス。動画ファイルのパスやURLを保存・管理するために利用可能。`ModelUri`の特殊化バージョンで、動画ファイル専用の機能を提供。 | Usage(`documents/rules/model_field_value/model_video_uri.md`) |
