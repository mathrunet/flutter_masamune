part of katana_storage;

class Storage extends ChangeNotifier {
  Storage(this.storageQuery);

  final StorageQuery storageQuery;

  Future<void>? get downloading => _downloadCompleter?.future;
  Completer<void>? _downloadCompleter;

  Future<void>? get uploading => _uploadCompleter?.future;
  Completer<void>? _uploadCompleter;

  Future<void>? get deleting => _deleteCompleter?.future;
  Completer<void>? _deleteCompleter;

  Future<String> get publicURI => storageQuery.adapter.fetchPublicURI(
        storageQuery.path.trimQuery().trimStringRight("/"),
      );

  Future<String> fetchDownloadURI() async {
    final path = await storageQuery.adapter.fetchDownloadURI(
      storageQuery.path.trimQuery().trimStringRight("/"),
    );
    notifyListeners();
    return path;
  }

  Future<Storage> download(String cachePath) async {
    if (_downloadCompleter != null) {
      await downloading;
      return this;
    }
    _downloadCompleter = Completer();
    try {
      await storageQuery.adapter.download(
        storageQuery.path.trimQuery().trimStringRight("/"),
        cachePath.trimQuery().trimStringRight("/"),
      );
      notifyListeners();
      _downloadCompleter?.complete();
      _downloadCompleter = null;
    } catch (e) {
      _downloadCompleter?.completeError(e);
      _downloadCompleter = null;
      rethrow;
    } finally {
      _downloadCompleter?.complete();
      _downloadCompleter = null;
    }
    return this;
  }

  Future<Storage> upload(String filePath) async {
    if (_uploadCompleter != null) {
      await uploading;
      return this;
    }
    _uploadCompleter = Completer();
    try {
      await storageQuery.adapter.upload(
        filePath.trimQuery().trimStringRight("/"),
        storageQuery.path.trimQuery().trimStringRight("/"),
      );
      notifyListeners();
      _uploadCompleter?.complete();
      _uploadCompleter = null;
    } catch (e) {
      _uploadCompleter?.completeError(e);
      _uploadCompleter = null;
      rethrow;
    } finally {
      _uploadCompleter?.complete();
      _uploadCompleter = null;
    }
    return this;
  }

  Future<Storage> uploadWithBytes(Uint8List fileBytes) async {
    if (_uploadCompleter != null) {
      await uploading;
      return this;
    }
    _uploadCompleter = Completer();
    try {
      await storageQuery.adapter.uploadWithBytes(
        fileBytes,
        storageQuery.path.trimQuery().trimStringRight("/"),
      );
      notifyListeners();
      _uploadCompleter?.complete();
      _uploadCompleter = null;
    } catch (e) {
      _uploadCompleter?.completeError(e);
      _uploadCompleter = null;
      rethrow;
    } finally {
      _uploadCompleter?.complete();
      _uploadCompleter = null;
    }
    return this;
  }

  Future<Storage> delete() async {
    if (_deleteCompleter != null) {
      await deleting;
      return this;
    }
    _deleteCompleter = Completer();
    try {
      await storageQuery.adapter.delete(
        storageQuery.path.trimQuery().trimStringRight("/"),
      );
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
    return this;
  }
}
