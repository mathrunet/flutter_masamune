part of masamune;

extension MasamunePickerUploaderAppRefExtensions on PickerValue {
  Future<Uri> upload({String dirPath = ""}) async {
    if (path.isEmpty) {
      throw Exception("[path] was not found.");
    }
    final remoteFile = path!.trimQuery().trimStringRight("/").last();
    final extension = remoteFile.last(separator: ".");
    final storage = Storage(
      StorageQuery(
        "$dirPath/$uuid.$extension".trimQuery().trimStringLeft("/"),
      ),
    );
    await storage.upload(path!);
    return await storage.fetchPublicURI();
  }
}
