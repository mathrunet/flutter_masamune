part of '/katana_model.dart';

/// Field key to store the last part of the document path (`ddd` for aaa/bbb/ccc/ddd).
///
/// ドキュメントのパスの一番最後の部分（aaa/bbb/ccc/dddの場合`ddd`）を格納しておくためのフィールドキー。
const kUidFieldKey = "@uid";

/// Field key to store the document update time.
///
/// ドキュメントの更新時間を保存しておくためのフィールドキー。
const kTimeFieldKey = "@time";

/// Field key to save the type of the special object in the field.
///
/// フィールドの特殊オブジェクトのタイプを保存してくためのフィールドキー。
const kTypeFieldKey = "@type";

/// Default field key to form a searchable field.
///
/// 検索可能なフィールドを形成するためのデフォルトのフィールドキー。
const kDefaultSearchableFieldKey = "@search";
