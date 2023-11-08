part of '/masamune_picker.dart';

/// Adapter to use the file picker.
///
/// Internally, the `image_picker` and `file_picker` packages are used.
/// Use according to [PickerFileType] and platform.
///
/// You can pick up media files captured by the camera with [pickCamera].
///
/// ファイルピッカーを利用するためのアダプター。
///
/// 内部的には`image_picker`および`file_picker`のパッケージを利用しています。
/// [PickerFileType]やプラットフォームに応じて使い分けます。
///
/// [pickCamera]でカメラ撮影したメディアファイルをピックアップすることができます。
class PickerMasamuneAdapter extends MasamuneAdapter {
  /// Adapter to use the file picker.
  ///
  /// Internally, the `image_picker` and `file_picker` packages are used.
  /// Use according to [PickerFileType] and platform.
  ///
  /// You can pick up media files captured by the camera with [pickCamera].
  ///
  /// ファイルピッカーを利用するためのアダプター。
  ///
  /// 内部的には`image_picker`および`file_picker`のパッケージを利用しています。
  /// [PickerFileType]やプラットフォームに応じて使い分けます。
  ///
  /// [pickCamera]でカメラ撮影したメディアファイルをピックアップすることができます。
  const PickerMasamuneAdapter();

  /// Implement a process to pick up multiple files.
  ///
  /// The title of the file dialog to be picked up is passed in [dialogTitle].
  ///
  /// Please specify [type] to restrict the type of file.
  ///
  /// 複数のファイルをピックアップするための処理を実装してください。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルが渡されます。
  ///
  /// [type]を指定するとファイルの種類を制限するようにしてください。
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
              uri: Uri.tryParse(file.path),
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
          return PickerValue(uri: Uri.tryParse(file.path!), bytes: file.bytes!);
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
          return PickerValue(uri: Uri.tryParse(file.path!), bytes: file.bytes!);
        });
    }
  }

  /// Implement a process to pick up single files.
  ///
  /// The title of the file dialog to be picked up is passed in [dialogTitle].
  ///
  /// Please specify [type] to restrict the type of file.
  ///
  /// 単一のファイルをピックアップするための処理を実装してください。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルが渡されます。
  ///
  /// [type]を指定するとファイルの種類を制限するようにしてください。
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
        return PickerValue(
            uri: Uri.tryParse(file.path), bytes: await file.readAsBytes());
      case PickerFileType.video:
        final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
        if (file == null) {
          throw Exception("File not found.");
        }
        return PickerValue(
            uri: Uri.tryParse(file.path), bytes: await file.readAsBytes());
      default:
        final res = await FilePicker.platform.pickFiles(
          dialogTitle: dialogTitle,
        );
        final file = res?.files.firstOrNull;
        if (file == null || file.path == null || file.bytes == null) {
          throw Exception("File not found.");
        }
        return PickerValue(uri: Uri.tryParse(file.path!), bytes: file.bytes!);
    }
  }

  /// Implement a process to activate the camera and pick up the captured media files.
  ///
  /// The title of the file dialog to be picked up is passed in [dialogTitle].
  ///
  /// Please specify [type] to restrict the type of file.
  ///
  /// カメラを起動し、撮影したメディアファイルをピックアップするための処理を実装してください。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルが渡されます。
  ///
  /// [type]を指定するとファイルの種類を制限するようにしてください。
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
        return PickerValue(
            uri: Uri.tryParse(file.path), bytes: await file.readAsBytes());
      case PickerFileType.video:
        final file = await ImagePicker().pickVideo(source: ImageSource.camera);
        if (file == null) {
          throw Exception("File not found.");
        }
        return PickerValue(
            uri: Uri.tryParse(file.path), bytes: await file.readAsBytes());
      default:
        throw UnsupportedError("This file format is not supported.");
    }
  }

  /// You can retrieve the [PickerMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[PickerMasamuneAdapter]を取得することができます。
  static PickerMasamuneAdapter get primary {
    assert(
      _primary != null,
      "PickerMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary ?? const PickerMasamuneAdapter();
  }

  static PickerMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is PickerMasamuneAdapter) {
      PickerMasamuneAdapter._primary ??= adapter;
    }
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<PickerMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
