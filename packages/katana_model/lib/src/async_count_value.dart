part of '/katana_model.dart';

/// This class is used to asynchronously retrieve values returned from [CollectionBase.count], etc.
///
/// You can get the number of elements in the collection from [value].
///
/// [CollectionBase.count]などから返される値を非同期で取得するためのクラスです。
///
/// [value]からコレクションの要素数を取得できます。
class AsyncModelValue extends ChangeNotifier implements ValueListenable<int?> {
  AsyncModelValue._(Future<int> future) : _loading = future {
    _process();
  }

  Future<void> _process() async {
    await _loading;
    _value = value;
    _loading = null;
    notifyListeners();
  }

  /// You can wait for it to load.
  ///
  /// 読み込みを待つことができます。
  Future<int>? get loading => _loading;
  Future<int>? _loading;

  @override
  int? get value => _value;
  int? _value;
}
