part of katana_picker;

class FilePickerAdapter extends PickerAdapter {
  const FilePickerAdapter();

  @override
  Future<List<PickerValue>> pickMultiple({
    String? dialogTitle,
    PickerMediaType type = PickerMediaType.others,
  }) async {
    switch (type) {
      case PickerMediaType.image:
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
          if (file.path == null || file.bytes == null) {
            return null;
          }
          return PickerValue(path: file.path!, bytes: file.bytes!);
        });
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
        final res = await FilePicker.platform.pickFiles(
          dialogTitle: dialogTitle,
          type: FileType.image,
        );
        final file = res?.files.firstOrNull;
        if (file == null || file.path == null || file.bytes == null) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path!, bytes: file.bytes!);
      case PickerMediaType.video:
        final res = await FilePicker.platform.pickFiles(
          dialogTitle: dialogTitle,
          type: FileType.video,
        );
        final file = res?.files.firstOrNull;
        if (file == null || file.path == null || file.bytes == null) {
          throw Exception("File not found.");
        }
        return PickerValue(path: file.path!, bytes: file.bytes!);
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
  }) {
    throw UnsupportedError("Camera functions are not supported.");
  }
}
