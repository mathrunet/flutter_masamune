part of '/masamune_picker.dart';

/// Provides an extension method for [PickerValue] that is nullable.
///
/// Nullableな[PickerValue]用の拡張メソッドを提供します。
extension NullablePickerValueExtension on PickerValue? {
  /// Whether this [PickerValue] is empty.
  ///
  /// Returns `true` if itself is [Null].
  ///
  /// この[PickerValue]が空かどうかを調べます。
  ///
  /// 自身が[Null]の場合`true`を返します。
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.uri.isEmpty && this!.bytes.isEmpty;
  }

  /// Whether this [Uri] is not empty.
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// この[Uri]が空でないかどうかを調べます。
  ///
  /// 自身が[Null]の場合`false`を返します。
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.uri.isNotEmpty || this!.bytes.isNotEmpty;
  }
}

/// Data of the picked up files.
///
/// The path where the picked up file is located is in [uri], and the actual data of the file is in [bytes].
/// One of the data may be missing, so please extract the data properly.
///
/// ピックアップしたファイルのデータ。
///
/// [uri]にピックアップしたファイルが置かれているパス、[bytes]にファイルの実データが入っています。
/// 片方のデータがない場合があるので適切にデータを取り出してください。
@immutable
class PickerValue {
  /// Data of the picked up files.
  ///
  /// The path where the picked up file is located is in [uri], and the actual data of the file is in [bytes].
  /// One of the data may be missing, so please extract the data properly.
  ///
  /// ピックアップしたファイルのデータ。
  ///
  /// [uri]にピックアップしたファイルが置かれているパス、[bytes]にファイルの実データが入っています。
  /// 片方のデータがない場合があるので適切にデータを取り出してください。
  const PickerValue({
    this.uri,
    this.bytes,
    String? mimeType,
  })  : assert(
          uri != null || bytes != null,
          "Either [path] or [bytes] must be non-null.",
        ),
        _mimeType = mimeType;

  /// The path where the picked up file is located.
  ///
  /// ピックアップしたファイルが置かれているパス。
  final Uri? uri;

  /// Actual data of the picked up files.
  ///
  /// ピックアップしたファイルの実データ。
  final Uint8List? bytes;

  /// If the MimeType is known, its value is entered.
  ///
  /// MimeTypeが分かる場合その値が入ります。
  MimeTypeValue? get mimeType {
    if (_mimeType != null) {
      return MimeTypeValue(_mimeType!);
    }
    final filename = uri?.path.last();
    if (filename == null) {
      return null;
    }
    final mimeType = lookupMimeType(filename);
    if (mimeType == null) {
      return null;
    }
    return MimeTypeValue(mimeType);
  }

  final String? _mimeType;

  @override
  int get hashCode => uri.hashCode ^ bytes.hashCode;

  @override
  bool operator ==(Object other) => other.hashCode == hashCode;

  /// Copy the [PickerValue] with the specified values.
  ///
  /// 指定した値で[PickerValue]をコピーします。
  PickerValue copyWith({
    Uri? uri,
    Uint8List? bytes,
    String? mimeType,
  }) {
    return PickerValue(
      uri: uri ?? this.uri,
      bytes: bytes ?? this.bytes,
      mimeType: mimeType ?? _mimeType,
    );
  }
}
