part of masamune_picker_file;

/// Adapter to use the file picker available on all platforms.
///
/// Internally, the `file_picker` package is used.
///
/// The [pickCamera] function is not available.
///
/// すべてのプラットフォームで利用可能なファイルピッカーを利用するためのアダプター。
///
/// 内部的には`file_picker`のパッケージが利用されています。
///
/// [pickCamera]の機能は利用できません。
class FilePickerAdapter extends MasamunePickerAdapter {
  /// Adapter to use the file picker available on all platforms.
  ///
  /// Internally, the `file_picker` package is used.
  ///
  /// The [pickCamera] function is not available.
  ///
  /// すべてのプラットフォームで利用可能なファイルピッカーを利用するためのアダプター。
  ///
  /// 内部的には`file_picker`のパッケージが利用されています。
  ///
  /// [pickCamera]の機能は利用できません。
  const FilePickerAdapter();

  @override
  Future<List<PickerValue>> pickMultiple({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) async {
    switch (type) {
      case PickerFileType.image:
        final res = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          dialogTitle: dialogTitle,
          type: FileType.image,
        );
        final files = res?.files;
        if (files == null) {
          throw Exception("File not found.");
        }
        return files.mapAndRemoveEmpty((file) {
          if (file.path == null && file.bytes == null) {
            return null;
          }
          return PickerValue(path: file.path, bytes: file.bytes);
        });
      case PickerFileType.video:
        final res = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          dialogTitle: dialogTitle,
          type: FileType.video,
        );
        final files = res?.files;
        if (files == null) {
          throw Exception("File not found.");
        }
        return files.mapAndRemoveEmpty((file) {
          if (file.path == null && file.bytes == null) {
            return null;
          }
          return PickerValue(path: file.path, bytes: file.bytes);
        });
      default:
        final res = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          dialogTitle: dialogTitle,
        );
        final files = res?.files;
        if (files == null) {
          throw Exception("File not found.");
        }
        return files.mapAndRemoveEmpty((file) {
          if (file.path == null && file.bytes == null) {
            return null;
          }
          return PickerValue(path: file.path, bytes: file.bytes);
        });
    }
  }

  @override
  Future<PickerValue> pickSingle({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) async {
    switch (type) {
      case PickerFileType.image:
        final res = await FilePicker.platform.pickFiles(
          dialogTitle: dialogTitle,
          type: FileType.image,
        );
        final file = res?.files.firstOrNull;
        if (file == null || (file.path == null && file.bytes == null)) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path, bytes: file.bytes);
      case PickerFileType.video:
        final res = await FilePicker.platform.pickFiles(
          dialogTitle: dialogTitle,
          type: FileType.video,
        );
        final file = res?.files.firstOrNull;
        if (file == null || (file.path == null && file.bytes == null)) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path, bytes: file.bytes);
      default:
        final res = await FilePicker.platform.pickFiles(
          dialogTitle: dialogTitle,
        );
        final file = res?.files.firstOrNull;
        if (file == null || (file.path == null && file.bytes == null)) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path, bytes: file.bytes);
    }
  }

  @override
  Future<PickerValue> pickCamera({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) {
    throw UnsupportedError("Camera functions are not supported.");
  }
}
