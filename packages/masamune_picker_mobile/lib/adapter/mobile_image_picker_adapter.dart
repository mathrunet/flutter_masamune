part of masamune_picker_mobile;

/// Adapter to use mobile and other camera-enabled file pickers.
///
/// Internally, the `image_picker` package is used.
///
/// You can pick up media files captured by the camera with [pickCamera].
///
/// モバイルなどカメラが利用可能なファイルピッカーを利用するためのアダプター。
///
/// 内部的には`image_picker`のパッケージを利用しています。
///
/// [pickCamera]でカメラ撮影したメディアファイルをピックアップすることができます。
class MobileImagePickerAdapter extends MasamunePickerAdapter {
  /// Adapter to use mobile and other camera-enabled file pickers.
  ///
  /// Internally, the `image_picker` package is used.
  ///
  /// You can pick up media files captured by the camera with [pickCamera].
  ///
  /// モバイルなどカメラが利用可能なファイルピッカーを利用するためのアダプター。
  ///
  /// 内部的には`image_picker`のパッケージを利用しています。
  ///
  /// [pickCamera]でカメラ撮影したメディアファイルをピックアップすることができます。
  const MobileImagePickerAdapter();

  @override
  Future<List<PickerValue>> pickMultiple({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) async {
    switch (type) {
      case PickerFileType.image:
        final files = await ImagePicker().pickMultiImage();
        return Future.wait(
          files.mapAndRemoveEmpty((file) async {
            return PickerValue(
              path: file.path,
              bytes: await file.readAsBytes(),
            );
          }),
        );
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
          if (file.path == null || file.bytes == null) {
            return null;
          }
          return PickerValue(path: file.path!, bytes: file.bytes!);
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
          if (file.path == null || file.bytes == null) {
            return null;
          }
          return PickerValue(path: file.path!, bytes: file.bytes!);
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
        final file = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (file == null) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path, bytes: await file.readAsBytes());
      case PickerFileType.video:
        final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
        if (file == null) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path, bytes: await file.readAsBytes());
      default:
        final res = await FilePicker.platform.pickFiles(
          dialogTitle: dialogTitle,
        );
        final file = res?.files.firstOrNull;
        if (file == null || file.path == null || file.bytes == null) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path!, bytes: file.bytes!);
    }
  }

  @override
  Future<PickerValue> pickCamera({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  }) async {
    switch (type) {
      case PickerFileType.image:
        final file = await ImagePicker().pickImage(source: ImageSource.camera);
        if (file == null) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path, bytes: await file.readAsBytes());
      case PickerFileType.video:
        final file = await ImagePicker().pickVideo(source: ImageSource.camera);
        if (file == null) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path, bytes: await file.readAsBytes());
      default:
        throw UnsupportedError("This file format is not supported.");
    }
  }
}
