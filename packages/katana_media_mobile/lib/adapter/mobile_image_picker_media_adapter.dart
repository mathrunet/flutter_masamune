part of katana_media_mobile;

class FilePickerMediaAdapter extends MediaAdapter {
  const FilePickerMediaAdapter();

  @override
  Future<List<MediaValue>> pickMultiple({
    String? dialogTitle,
    MediaType type = MediaType.others,
  }) async {
    switch (type) {
      case MediaType.image:
        final files = await ImagePicker().pickMultiImage();
        return Future.wait(
          files.mapAndRemoveEmpty((file) async {
            return MediaValue(path: file.path, bytes: await file.readAsBytes());
          }),
        );
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
        final file = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (file == null) {
          throw Exception("File not found.");
        }
        return MediaValue(path: file.path, bytes: await file.readAsBytes());
      case MediaType.video:
        final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
        if (file == null) {
          throw Exception("File not found.");
        }
        return MediaValue(path: file.path, bytes: await file.readAsBytes());
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
  }) async {
    switch (type) {
      case MediaType.image:
        final file = await ImagePicker().pickImage(source: ImageSource.camera);
        if (file == null) {
          throw Exception("File not found.");
        }
        return MediaValue(path: file.path, bytes: await file.readAsBytes());
      case MediaType.video:
        final file = await ImagePicker().pickVideo(source: ImageSource.camera);
        if (file == null) {
          throw Exception("File not found.");
        }
        return MediaValue(path: file.path, bytes: await file.readAsBytes());
      default:
        throw UnsupportedError("This file format is not supported.");
    }
  }
}
