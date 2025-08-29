part of "/katana.dart";

/// A file to be uploaded as part of a [ApiMultipartFile].
///
/// This doesn't need to correspond to a physical file.
///
/// マルチパートリクエストの一部としてアップロードされるファイル。
///
/// 物理ファイルに対応する必要はありません。
@immutable
class ApiMultipartFile {
  const ApiMultipartFile._({
    required this.field,
    required this.type,
    this.value,
    this.bytes,
    this.filename,
  })  : assert(value != null && bytes != null,
            "value and bytes cannot be both null"),
        assert(value == null || bytes == null,
            "value and bytes cannot be both set");

  /// Creates a new [ApiMultipartFile] from a byte array.
  ///
  /// バイト配列から新しい [ApiMultipartFile] を作成します。
  factory ApiMultipartFile.fromBytes(String field, List<int> value,
      {String? filename}) {
    return ApiMultipartFile._(
        field: field,
        type: ApiMultipartFileType.bytes,
        bytes: value,
        filename: filename);
  }

  /// Creates a new [ApiMultipartFile] from a string.
  ///
  /// 文字列から新しい [ApiMultipartFile] を作成します。
  factory ApiMultipartFile.fromString(String field, String value,
      {String? filename}) {
    return ApiMultipartFile._(
        field: field,
        type: ApiMultipartFileType.string,
        value: value,
        filename: filename);
  }

  /// Creates a new [ApiMultipartFile] from a path to a file on disk.
  ///
  /// Throws an [UnsupportedError] if `dart:io` isn't supported in this
  /// environment.
  ///
  /// ディスク上のファイルへのパスから新しい [ApiMultipartFile] を作成します。
  ///
  /// この環境で dart:io がサポートされていない場合、[UnsupportedError] をスローします。
  factory ApiMultipartFile.fromPath(String field, String filePath,
      {String? filename}) {
    return ApiMultipartFile._(
        field: field,
        type: ApiMultipartFileType.path,
        value: filePath,
        filename: filename);
  }

  /// The type of the multipart file.
  ///
  /// マルチパートファイルの型。
  final ApiMultipartFileType type;

  /// Field name.
  ///
  /// フィールド名。
  final String field;

  /// String data and text data.
  ///
  /// 文字列データおよびテキストデータ。
  final String? value;

  /// Binary data.
  ///
  /// バイナリデータ。
  final List<int>? bytes;

  /// File name.
  ///
  /// ファイル名。
  final String? filename;

  @override
  String toString() {
    return "ApiMultipartFile(field: $field, type: $type, value: $value, bytes: $bytes, filename: $filename)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ApiMultipartFile &&
        other.field == field &&
        other.type == type &&
        other.value == value &&
        other.bytes == bytes &&
        other.filename == filename;
  }

  @override
  int get hashCode =>
      field.hashCode ^
      type.hashCode ^
      value.hashCode ^
      bytes.hashCode ^
      filename.hashCode;
}

/// The type of the multipart file.
///
/// マルチパートファイルの型。
enum ApiMultipartFileType {
  /// String data and text data.
  ///
  /// 文字列データおよびテキストデータ。
  string,

  /// Binary data.
  ///
  /// バイナリデータ。
  bytes,

  /// File path.
  ///
  /// ファイルパス。
  path;
}
