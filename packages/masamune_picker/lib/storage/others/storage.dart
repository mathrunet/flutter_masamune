part of "others.dart";

/// Extension methods of Storage system related to PickerValue.
///
/// PickerValueに関連するStorage系の拡張メソッド。
extension MasamunePickerUploaderAppRefExtensions on PickerValue {
  /// Upload picked up files directly to storage.
  ///
  /// Pass [relativeDirPath] the relative path of the folder where you want to upload the file.
  ///
  /// After uploading, the public URL is returned after the upload.
  ///
  /// You can also specify the maximum vertical and horizontal size of the image by passing [limitSize].
  /// This value is applied if [PickerMasamuneAdapter.forceImageResize] is `true`.
  ///
  /// ピックアップしたファイルを直接ストレージにアップロードします。
  ///
  /// [relativeDirPath]にファイルをアップロードしたいフォルダの相対パスを渡してください。
  ///
  /// アップロードした後、アップロード後の公開URLが返されます。
  ///
  /// また[limitSize]を渡すことで、画像の縦および横の最大サイズを指定することが可能です。
  /// [PickerMasamuneAdapter.forceImageResize]がtrueの場合、この値が適用されます。
  Future<Uri> upload({String relativeDirPath = "", int? limitSize}) async {
    relativeDirPath = relativeDirPath.trimQuery().trimString("/");
    final path = uri.toString();
    final adapter = PickerMasamuneAdapter.primary;
    if (uri == null || path.isEmpty) {
      throw Exception("Upload data was not found.");
    }
    if (adapter.forceImageResize) {
      final image = await _decodeImage(path, mimeType?.value);
      if (image != null) {
        final imageResizeLimit =
            adapter.imageResizeLimits.sortTo((a, b) => b.compareTo(a));
        final width = image.width;
        final height = image.height;
        final resizedImage = img.resize(
          image,
          maintainAspect: true,
          interpolation: adapter.imageResizeInterpolation.toInterpolation(),
          width: width >= height
              ? limitSize != null
                  ? limitSize <= width
                      ? limitSize
                      : imageResizeLimit.firstWhere((limit) => width >= limit)
                  : imageResizeLimit.firstWhere((limit) => width >= limit)
              : null,
          height: height > width
              ? limitSize != null
                  ? limitSize <= height
                      ? limitSize
                      : imageResizeLimit.firstWhere((limit) => height >= limit)
                  : imageResizeLimit.firstWhere((limit) => height >= limit)
              : null,
        );
        final remoteFile = path.trimQuery().trimStringRight("/").last();
        // .が入っていない場合blobのため拡張子を取得できない
        final extension = remoteFile.contains(".")
            ? remoteFile.last(separator: ".")
            : mimeType?.extension ?? "";
        final storage = Storage(
          StorageQuery(
            "$relativeDirPath/${uuid()}.$extension"
                .trimQuery()
                .trimStringLeft("/"),
            mimeType: mimeType?.value,
          ),
        );
        await storage
            .uploadWithBytes(_encodeImage(resizedImage, mimeType?.value));
        return await storage.fetchPublicURI();
      }
    }
    final remoteFile = path.trimQuery().trimStringRight("/").last();
    // .が入っていない場合blobのため拡張子を取得できない
    final extension = remoteFile.contains(".")
        ? remoteFile.last(separator: ".")
        : mimeType?.extension ?? "";
    final storage = Storage(
      StorageQuery(
        "$relativeDirPath/${uuid()}.$extension".trimQuery().trimStringLeft("/"),
        mimeType: mimeType?.value,
      ),
    );
    await storage.upload(uri!.toString().replaceAll(RegExp("file://"), ""));
    return await storage.fetchPublicURI();
  }

  Future<img.Image?> _decodeImage(String path, String? mimeType) async {
    switch (mimeType) {
      case "image/jpeg":
        return img.decodeImageFile(path);
      case "image/png":
        return img.decodePngFile(path);
      case "image/gif":
        return img.decodeGifFile(path);
      case "image/bmp":
        return img.decodeBmpFile(path);
      case "image/tiff":
        return img.decodeTiffFile(path);
      default:
        return null;
    }
  }

  Uint8List _encodeImage(img.Image image, String? mimeType) {
    switch (mimeType) {
      case "image/jpeg":
        return img.encodeJpg(image);
      case "image/png":
        return img.encodePng(image);
      case "image/gif":
        return img.encodeGif(image);
      case "image/bmp":
        return img.encodeBmp(image);
      case "image/tiff":
        return img.encodeTiff(image);
      default:
        throw Exception("Unsupported image format: $mimeType");
    }
  }

  /// Uploads the selected file directly to the storage's `public/userId` folder.
  ///
  /// Pass `[relativeDirPath]` the relative path (within the `public/userId` folder) of the folder where you want to upload the file.
  ///
  /// After uploading, the public URL is returned after the upload.
  ///
  /// You can also specify the maximum vertical and horizontal size of the image by passing [limitSize].
  /// This value is applied if [PickerMasamuneAdapter.forceImageResize] is `true`.
  ///
  /// ピックアップしたファイルを直接ストレージの`public/userId`フォルダにアップロードします。
  ///
  /// [relativeDirPath]にファイルをアップロードしたいフォルダの相対パス（public/userIdフォルダ内）を渡してください。
  ///
  /// アップロードした後、アップロード後の公開URLが返されます。
  ///
  /// また[limitSize]を渡すことで、画像の縦および横の最大サイズを指定することが可能です。
  /// [PickerMasamuneAdapter.forceImageResize]がtrueの場合、この値が適用されます。
  Future<Uri> uploadToPublic(String userId,
      {String relativeDirPath = "", int? limitSize}) {
    return upload(
      relativeDirPath:
          "public/${userId.trimQuery().trimString("/")}/${relativeDirPath.trimStringLeft("/")}",
      limitSize: limitSize,
    );
  }

  /// Uploads the selected file directly to the storage's `private` folder.
  ///
  /// Pass `[relativeDirPath]` the relative path (within the `private` folder) of the folder where you want to upload the file.
  ///
  /// After uploading, the private URL is returned after the upload.
  ///
  /// You can also specify the maximum vertical and horizontal size of the image by passing [limitSize].
  /// This value is applied if [PickerMasamuneAdapter.forceImageResize] is `true`.
  ///
  /// ピックアップしたファイルを直接ストレージの`private/userId`フォルダにアップロードします。
  ///
  /// [relativeDirPath]にファイルをアップロードしたいフォルダの相対パス（private/userIdフォルダ内）を渡してください。
  ///
  /// アップロードした後、アップロード後の非公開URLが返されます。
  ///
  /// また[limitSize]を渡すことで、画像の縦および横の最大サイズを指定することが可能です。
  /// [PickerMasamuneAdapter.forceImageResize]がtrueの場合、この値が適用されます。
  Future<Uri> uploadToPrivate(String userId,
      {String relativeDirPath = "", int? limitSize}) {
    if (userId.isEmpty) {
      throw Exception("User ID is empty.");
    }
    return upload(
      relativeDirPath:
          "private/${userId.trimQuery().trimString("/")}/${relativeDirPath.trimStringLeft("/")}",
      limitSize: limitSize,
    );
  }
}

extension on PickerInterpolation {
  img.Interpolation toInterpolation() {
    switch (this) {
      case PickerInterpolation.nearest:
        return img.Interpolation.nearest;
      case PickerInterpolation.linear:
        return img.Interpolation.linear;
      case PickerInterpolation.cubic:
        return img.Interpolation.cubic;
      case PickerInterpolation.average:
        return img.Interpolation.average;
    }
  }
}
