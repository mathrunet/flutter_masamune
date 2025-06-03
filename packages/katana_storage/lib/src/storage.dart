part of "/katana_storage.dart";

/// Provides access to file storage.
///
/// Pass [storageQuery] to set the path and adapter on the remote storage side.
///
/// Specify the local path in [upload] and upload the file.
/// It is also possible to upload with real data instead of paths by using [uploadWithBytes].
///
/// Uploaded files can be downloaded at [download].
/// In that case, cache the file by specifying the local cache path.
///
/// You can delete files on the remote side with [delete].
///
/// ファイルストレージへのアクセス機能を提供します。
///
/// [storageQuery]を渡してリモートストレージ側のパスやアダプターの設定を行ってください。
///
/// [upload]でローカルのパスを指定しファイルのアップロードを行います。
/// [uploadWithBytes]でパスではなく実データでアップロードすることも可能です。
///
/// アップロード済みのファイルを[download]にてダウンロードすることが可能です。
/// その場合、ローカルのキャッシュのパスを指定してファイルをキャッシュします。
///
/// [delete]でリモート側のファイルを削除することが可能です。
class Storage extends ChangeNotifier implements ValueListenable<StorageValue?> {
  /// Provides access to file storage.
  ///
  /// Pass [storageQuery] to set the path and adapter on the remote storage side.
  ///
  /// Specify the local path in [upload] and upload the file.
  /// It is also possible to upload with real data instead of paths by using [uploadWithBytes].
  ///
  /// Uploaded files can be downloaded at [download].
  /// In that case, cache the file by specifying the local cache path.
  ///
  /// You can delete files on the remote side with [delete].
  ///
  /// ファイルストレージへのアクセス機能を提供します。
  ///
  /// [storageQuery]を渡してリモートストレージ側のパスやアダプターの設定を行ってください。
  ///
  /// [upload]でローカルのパスを指定しファイルのアップロードを行います。
  /// [uploadWithBytes]でパスではなく実データでアップロードすることも可能です。
  ///
  /// アップロード済みのファイルを[download]にてダウンロードすることが可能です。
  /// その場合、ローカルのキャッシュのパスを指定してファイルをキャッシュします。
  ///
  /// [delete]でリモート側のファイルを削除することが可能です。
  Storage(this.storageQuery);

  /// Information about the target files on the storage side is defined.
  ///
  /// ストレージ側の対象となるファイルの情報が定義されます。
  final StorageQuery storageQuery;

  @override
  StorageValue? get value => _value;
  StorageValue? _value;

  /// If a file is being downloaded, you can wait.
  ///
  /// The full path of the cache to download can be obtained as a return value.
  ///
  /// ファイルをダウンロード中の場合待つことができます。
  ///
  /// 戻り値としてダウンロード先のキャッシュのフルパスを取得することが出来ます。
  Future<void>? get downloading => _downloadCompleter?.future;
  Completer<void>? _downloadCompleter;

  /// You can wait for the file to be uploaded.
  ///
  /// The full path to the upload destination can be obtained as a return value.
  ///
  /// ファイルのアップロードを待つことができます。
  ///
  /// 戻り値としてアップロード先のフルパスを取得することが出来ます。
  Future<void>? get uploading => _uploadCompleter?.future;
  Completer<void>? _uploadCompleter;

  /// You can wait for the file to be deleted.
  ///
  /// ファイルの削除を待つことができます。
  Future<void>? get deleting => _deleteCompleter?.future;
  Completer<void>? _deleteCompleter;

  /// Get a URL that can be made public. Use this URI when you want to retrieve images, etc. using `Image.network`, etc.
  ///
  /// 公開可能なURLを取得します。画像等を`Image.network`などで取得したい場合このURIを利用します。
  Future<Uri> fetchPublicURI() => storageQuery.adapter.fetchPublicURI(
        storageQuery.relativeRemotePathOrId.trimQuery().trimStringRight("/"),
      );

  /// Get the URI to download the file.
  ///
  /// ファイルをダウンロードするためのURIを取得します。
  Future<Uri> fetchDownloadURI() async {
    final path = await storageQuery.adapter.fetchDownloadURI(
      storageQuery.relativeRemotePathOrId.trimQuery().trimStringRight("/"),
    );
    notifyListeners();
    return path;
  }

  /// Download the file on the remote side specified by [storageQuery] to [localRelativePath] on the local side.
  ///
  /// You can wait in [downloading] while downloading.
  ///
  /// The full path of the cache to download can be obtained as a return value.
  ///
  /// [storageQuery]で指定されたリモート側のファイルをローカル上の[localRelativePath]にダウンロードします。
  ///
  /// ダウンロード中は[downloading]で待つことができます。
  ///
  /// 戻り値としてダウンロード先のキャッシュのフルパスを取得することが出来ます。
  Future<StorageValue?> download([String? localRelativePath]) async {
    if (_downloadCompleter != null) {
      await downloading;
      return value;
    }
    _downloadCompleter = Completer();
    try {
      final localFile = await storageQuery.adapter.download(
        storageQuery.relativeRemotePathOrId.trimQuery().trimStringRight("/"),
        localRelativePath?.trimQuery().trimStringRight("/"),
      );
      _value = _value?._copyWith(
            local: localFile,
          ) ??
          StorageValue._(
            local: localFile,
          );
      notifyListeners();
      _downloadCompleter?.complete();
      _downloadCompleter = null;
      return _value;
    } catch (e) {
      _downloadCompleter?.completeError(e);
      _downloadCompleter = null;
      rethrow;
    } finally {
      _downloadCompleter?.complete();
      _downloadCompleter = null;
    }
  }

  /// Uploads a file located at [localFullPath] on the local to the remote location specified by [storageQuery].
  ///
  /// While uploading, you can wait at [uploading].
  ///
  /// You can specify the MIME type for uploading by specifying [mimeType].
  ///
  /// The full path to the upload destination can be obtained as a return value.
  ///
  /// ローカル上の[localFullPath]にあるファイルを[storageQuery]で指定されたリモート側の位置にアップロードします。
  ///
  /// アップロード中は[uploading]で待つことができます。
  ///
  /// [mimeType]を指定することでアップロード時のMIMEタイプを指定することができます。
  ///
  /// 戻り値としてアップロード先のフルパスを取得することが出来ます。
  Future<StorageValue?> upload(String localFullPath) async {
    if (_uploadCompleter != null) {
      await uploading;
      return value;
    }
    _uploadCompleter = Completer();
    try {
      final remoteFile = await storageQuery.adapter.upload(
        localFullPath.trimQuery().trimStringRight("/"),
        storageQuery.relativeRemotePathOrId.trimQuery().trimStringRight("/"),
        mimeType: storageQuery.mimeType,
      );
      _value = _value?._copyWith(
            remote: remoteFile,
          ) ??
          StorageValue._(
            remote: remoteFile,
          );
      notifyListeners();
      _uploadCompleter?.complete();
      _uploadCompleter = null;
      return _value;
    } catch (e) {
      _uploadCompleter?.completeError(e);
      _uploadCompleter = null;
      rethrow;
    } finally {
      _uploadCompleter?.complete();
      _uploadCompleter = null;
    }
  }

  /// Uploads a file with the actual data in [uploadFileByte] to the location on the remote side specified by [storageQuery].
  ///
  /// While uploading, you can wait at [uploading].
  ///
  /// It takes a [StorageValue] as a return value and can retrieve both local and remote data.
  ///
  /// [uploadFileByte]の実データを持つファイルを[storageQuery]で指定されたリモート側の位置にアップロードします。
  ///
  /// アップロード中は[uploading]で待つことができます。
  ///
  /// 戻り値として[StorageValue]を受け取り、ローカルとリモートの両方のデータを取得することができます。
  Future<StorageValue?> uploadWithBytes(Uint8List uploadFileByte) async {
    if (_uploadCompleter != null) {
      await uploading;
      return value;
    }
    _uploadCompleter = Completer();
    try {
      final remoteFile = await storageQuery.adapter.uploadWithBytes(
        uploadFileByte,
        storageQuery.relativeRemotePathOrId.trimQuery().trimStringRight("/"),
        mimeType: storageQuery.mimeType,
      );
      _value = _value?._copyWith(
            remote: remoteFile,
          ) ??
          StorageValue._(
            remote: remoteFile,
          );
      notifyListeners();
      _uploadCompleter?.complete();
      _uploadCompleter = null;
      return _value;
    } catch (e) {
      _uploadCompleter?.completeError(e);
      _uploadCompleter = null;
      rethrow;
    } finally {
      _uploadCompleter?.complete();
      _uploadCompleter = null;
    }
  }

  /// Deletes the file on the remote side specified by [storageQuery].
  ///
  /// You can wait in [deleting] while it is being deleted.
  ///
  /// [storageQuery]で指定されたリモート側のファイルを削除します。
  ///
  /// 削除中は[deleting]で待つことができます。
  Future<void> delete() async {
    if (_deleteCompleter != null) {
      await deleting;
      return;
    }
    _deleteCompleter = Completer();
    try {
      await storageQuery.adapter.delete(
        storageQuery.relativeRemotePathOrId.trimQuery().trimStringRight("/"),
      );
      _value = null;
      notifyListeners();
      _deleteCompleter?.complete();
      _deleteCompleter = null;
    } catch (e) {
      _deleteCompleter?.completeError(e);
      _deleteCompleter = null;
      rethrow;
    } finally {
      _deleteCompleter?.complete();
      _deleteCompleter = null;
    }
  }
}
