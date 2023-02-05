part of masamune_picker;

/// Adapter to use the file picker available on all platforms.
///
/// Define the data for the file to be returned by specifying [defaultFilePath] or [defaultFileBytes].
///
/// テスト用のファイルピッカーを利用するためのアダプター。
///
/// [defaultFilePath]、もしくは[defaultFileBytes]を指定して返すファイルのデータを定義してください。
class TestPickerAdapter extends MasamunePickerAdapter {
  /// Adapter to use the file picker available on all platforms.
  ///
  /// Define the data for the file to be returned by specifying [defaultFilePath] or [defaultFileBytes].
  ///
  /// テスト用のファイルピッカーを利用するためのアダプター。
  ///
  /// [defaultFilePath]、もしくは[defaultFileBytes]を指定して返すファイルのデータを定義してください。
  const TestPickerAdapter({
    this.defaultFilePath,
    this.defaultFileBytes,
  });

  /// Path of the file to be returned.
  ///
  /// 返却するファイルのパス。
  final String? defaultFilePath;

  /// Data to be returned.
  ///
  /// 返却するデータ。
  final Uint8List? defaultFileBytes;

  @override
  Future<List<PickerValue>> pickMultiple({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) async {
    if (defaultFileBytes == null && defaultFilePath == null) {
      throw Exception("File not found.");
    }
    return [
      PickerValue(path: defaultFilePath, bytes: defaultFileBytes),
    ];
  }

  @override
  Future<PickerValue> pickSingle({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) async {
    if (defaultFileBytes == null && defaultFilePath == null) {
      throw Exception("File not found.");
    }
    return PickerValue(path: defaultFilePath, bytes: defaultFileBytes);
  }

  @override
  Future<PickerValue> pickCamera({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) async {
    if (defaultFileBytes == null && defaultFilePath == null) {
      throw Exception("File not found.");
    }
    return PickerValue(path: defaultFilePath, bytes: defaultFileBytes);
  }
}
