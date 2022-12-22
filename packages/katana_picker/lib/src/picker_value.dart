part of katana_picker;

/// Data of the picked up files.
///
/// The path where the picked up file is located is in [path], and the actual data of the file is in [bytes].
/// One of the data may be missing, so please extract the data properly.
///
/// ピックアップしたファイルのデータ。
///
/// [path]にピックアップしたファイルが置かれているパス、[bytes]にファイルの実データが入っています。
/// 片方のデータがない場合があるので適切にデータを取り出してください。
@immutable
class PickerValue {
  /// Data of the picked up files.
  ///
  /// The path where the picked up file is located is in [path], and the actual data of the file is in [bytes].
  /// One of the data may be missing, so please extract the data properly.
  ///
  /// ピックアップしたファイルのデータ。
  ///
  /// [path]にピックアップしたファイルが置かれているパス、[bytes]にファイルの実データが入っています。
  /// 片方のデータがない場合があるので適切にデータを取り出してください。
  const PickerValue({
    this.path,
    this.bytes,
  }) : assert(
          path != null || bytes != null,
          "Either [path] or [bytes] must be non-null.",
        );

  /// The path where the picked up file is located.
  ///
  /// ピックアップしたファイルが置かれているパス。
  final String? path;

  /// Actual data of the picked up files.
  ///
  /// ピックアップしたファイルの実データ。
  final Uint8List? bytes;

  @override
  int get hashCode => path.hashCode ^ bytes.hashCode;

  @override
  bool operator ==(Object other) => other.hashCode == hashCode;
}
