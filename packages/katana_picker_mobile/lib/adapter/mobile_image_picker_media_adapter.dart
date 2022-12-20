part of katana_picker_mobile;

class FilePickerMediaAdapter extends PickerAdapter {
  const FilePickerMediaAdapter();

  @override
  Future<List<PickerValue>> pickMultiple({
    String? dialogTitle,
    PickerMediaType type = PickerMediaType.others,
  }) async {
    switch (type) {
      case PickerMediaType.image:
        final files = await ImagePicker().pickMultiImage();
        return Future.wait(
          files.mapAndRemoveEmpty((file) async {
            return PickerValue(
              path: file.path,
              bytes: await file.readAsBytes(),
            );
          }),
        );
      case PickerMediaType.video:
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
    PickerMediaType type = PickerMediaType.others,
  }) async {
    switch (type) {
      case PickerMediaType.image:
        final file = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (file == null) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path, bytes: await file.readAsBytes());
      case PickerMediaType.video:
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
    PickerMediaType type = PickerMediaType.others,
  }) async {
    switch (type) {
      case PickerMediaType.image:
        final file = await ImagePicker().pickImage(source: ImageSource.camera);
        if (file == null) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path, bytes: await file.readAsBytes());
      case PickerMediaType.video:
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
