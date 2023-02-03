part of katana_model_firestore;

class _FirestoreCache {
  _FirestoreCache();
  final _document = <String, DynamicMap>{};

  static final _caches = <FirebaseOptions?, _FirestoreCache>{};

  static _FirestoreCache getCache(FirebaseOptions? options) {
    if (_caches.containsKey(options)) {
      return _caches[options]!;
    }
    return _caches[options] = _FirestoreCache();
  }

  void set(String path, [DynamicMap? value]) {
    if (value == null) {
      _document.remove(path);
    } else {
      _document[path] = value;
    }
  }

  DynamicMap? get(String path) {
    if (_document.containsKey(path)) {
      return _document[path]!;
    }
    return null;
  }
}
