part of katana_picker;

class Picker extends ChangeNotifier {
  Picker({PickerAdapter? adapter}) : _adapter = adapter;

  PickerAdapter get adapter {
    return _adapter ?? PickerAdapter.primary;
  }

  final PickerAdapter? _adapter;

  Future<void>? get future => _completer?.future;

  Completer<void>? _completer;

  Future<PickerValue> pickSingle({
    String? dialogTitle,
    PickerMediaType type = PickerMediaType.others,
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

  Future<List<PickerValue>> pickMultiple({
    String? dialogTitle,
    PickerMediaType type = PickerMediaType.others,
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
