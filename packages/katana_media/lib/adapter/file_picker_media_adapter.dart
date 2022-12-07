part of katana_media;

class FilePickerMediaAdapter extends MediaAdapter {
  const FilePickerMediaAdapter();

  @override
  Future<List<MediaValue>> pickMultiple({
    String? dialogTitle,
    MediaType type = MediaType.others,
  }) async {
    switch (type) {
      case MediaType.image:
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
          return MediaValue(path: file.path!, bytes: file.bytes!);
        });
      case MediaType.video:
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
          return MediaValue(path: file.path!, bytes: file.bytes!);
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
          return MediaValue(path: file.path!, bytes: file.bytes!);
        });
    }
  }

  @override
  Future<MediaValue> pickSingle({
    String? dialogTitle,
    MediaType type = MediaType.others,
  }) async {
    switch (type) {
      case MediaType.image:
        final res = await FilePicker.platform.pickFiles(
          dialogTitle: dialogTitle,
          type: FileType.image,
        );
        final file = res?.files.firstOrNull;
        if (file == null || file.path == null || file.bytes == null) {
          throw Exception("File not found.");
        }
        return MediaValue(path: file.path!, bytes: file.bytes!);
      case MediaType.video:
        final res = await FilePicker.platform.pickFiles(
          dialogTitle: dialogTitle,
          type: FileType.video,
        );
        final file = res?.files.firstOrNull;
        if (file == null || file.path == null || file.bytes == null) {
          throw Exception("File not found.");
        }
        return MediaValue(path: file.path!, bytes: file.bytes!);
      default:
        final res = await FilePicker.platform.pickFiles(
          dialogTitle: dialogTitle,
        );
        final file = res?.files.firstOrNull;
        if (file == null || file.path == null || file.bytes == null) {
          throw Exception("File not found.");
        }
        return MediaValue(path: file.path!, bytes: file.bytes!);
    }
  }

  @override
  Future<MediaValue> pickCamera({
    String? dialogTitle,
    MediaType type = MediaType.others,
  }) {
    throw UnsupportedError("Camera functions are not supported.");
  }
}
