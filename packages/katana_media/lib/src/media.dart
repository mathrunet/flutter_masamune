part of katana_media;

class Media extends ChangeNotifier {
  Media({MediaAdapter? adapter}) : _adapter = adapter;

  MediaAdapter get adapter {
    return _adapter ?? MediaAdapter.primary;
  }

  final MediaAdapter? _adapter;

  Future<void>? get future => _completer?.future;

  Completer<void>? _completer;

  Future<MediaValue> pickSingle({
    String? dialogTitle,
    MediaType type = MediaType.others,
  }) async {
    try {
      _completer = Completer();
      final res = await adapter.pickSingle(
        dialogTitle: dialogTitle,
        type: type,
      );
      _completer?.complete();
      _completer = null;
      return res;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  Future<List<MediaValue>> pickMultiple({
    String? dialogTitle,
    MediaType type = MediaType.others,
  }) async {
    try {
      _completer = Completer();
      final res = await adapter.pickMultiple(
        dialogTitle: dialogTitle,
        type: type,
      );
      _completer?.complete();
      _completer = null;
      return res;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }
}
