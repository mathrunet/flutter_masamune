part of katana_model;

/// Class for asynchronously retrieving values returned from [CollectionBase.count].
///
/// You can get the number of elements in the collection from [value].
///
/// [CollectionBase.count]から返される値を非同期で取得するためのクラスです。
///
/// [value]からコレクションの要素数を取得できます。
class AsyncCountValue extends ChangeNotifier implements ValueListenable<int?> {
  AsyncCountValue._(Future<int> future) {
    future.then((value) {
      _value = value;
      notifyListeners();
    });
  }

  @override
  int? get value => _value;
  int? _value;
}
