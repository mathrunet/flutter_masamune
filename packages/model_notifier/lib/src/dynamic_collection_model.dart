part of model_notifier;

/// Collection model for flexibly modifying the contents of an object that is primarily a [DynamicMap].
abstract class DynamicCollectionModel<T extends DynamicDocumentModel>
    implements ListModel<T>, List<T>, ListenableList<T>, FutureModel<List<T>> {}

/// Class for mix-ins to facilitate use of DynamicCollectionModel.
///
/// Only [value] is defined and used as shown below.
///
/// ```
/// class MyDynamicCollectionModel with DynamicCollectionModelMixin implements DynamicCollectionModel {
///   MyDynamicCollectionModel();
///
///   @override
///   final DynamicMap value = {};
/// }
/// ```
abstract class DynamicCollectionModelMixin<T extends DynamicDocumentModel>
    implements DynamicCollectionModel<T> {
  @override
  List<T> get value;

  @override
  List<T> operator +(List<T> other) => value + other;

  @override
  T operator [](int index) => value[index];

  @override
  void operator []=(int index, T val) => value[index] = val;

  @override
  void add(T val) => value.add(val);

  @override
  void addAll(Iterable<T> iterable) => value.addAll(iterable);

  @override
  bool any(bool Function(T element) test) => value.any(test);

  @override
  Map<int, T> asMap() => value.asMap();

  @override
  List<E> cast<E>() => value.cast<E>();

  @override
  void clear() => value.clear();

  @override
  bool contains(Object? element) => value.contains(element);

  @override
  T elementAt(int index) => value.elementAt(index);

  @override
  bool every(bool Function(T element) test) => value.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T element) f) =>
      value.expand<E>(f);

  @override
  void fillRange(int start, int end, [T? fillValue]) =>
      value.fillRange(start, end, fillValue);

  @override
  T firstWhere(
    bool Function(T element) test, {
    T Function()? orElse,
  }) =>
      value.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E Function(E previousValue, T element) combine) =>
      value.fold<E>(initialValue, combine);

  @override
  Iterable<T> followedBy(Iterable<T> other) => value.followedBy(other);

  @override
  void forEach(void Function(T element) f) => value.forEach(f);

  @override
  Iterable<T> getRange(int start, int end) => value.getRange(start, end);

  @override
  int indexOf(T element, [int start = 0]) => value.indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) =>
      value.indexWhere(test, start);

  @override
  void insert(int index, T element) => value.insert(index, element);

  @override
  void insertAll(int index, Iterable<T> iterable) =>
      value.insertAll(index, iterable);

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  Iterator<T> get iterator => value.iterator;

  @override
  String join([String separator = ""]) => value.join(separator);

  @override
  int lastIndexOf(T element, [int? start]) => value.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) =>
      value.lastIndexWhere(test, start);

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) =>
      value.lastWhere(test, orElse: orElse);

  @override
  Iterable<E> map<E>(E Function(T e) f) => value.map<E>(f);

  @override
  T reduce(T Function(T value, T element) combine) => value.reduce(combine);

  @override
  bool remove(Object? val) => value.remove(val);

  @override
  T removeAt(int index) => value.removeAt(index);

  @override
  T removeLast() => value.removeLast();

  @override
  void removeRange(int start, int end) => value.removeRange(start, end);

  @override
  void removeWhere(bool Function(T element) test) => value.removeWhere(test);

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) =>
      value.replaceRange(start, end, replacement);

  @override
  void retainWhere(bool Function(T element) test) => value.retainWhere(test);

  @override
  Iterable<T> get reversed => value.reversed;

  @override
  void setAll(int index, Iterable<T> iterable) => value.setAll(index, iterable);

  @override
  void setRange(
    int start,
    int end,
    Iterable<T> iterable, [
    int skipCount = 0,
  ]) =>
      value.setRange(start, end, iterable, skipCount);

  @override
  void shuffle([Random? random]) => value.shuffle(random);

  @override
  T get single => value.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) =>
      value.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int n) => value.skip(n);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => value.skipWhile(test);

  @override
  void sort([int Function(T a, T b)? compare]) => value.sort(compare);

  @override
  List<T> sublist(int start, [int? end]) => value.sublist(start, end);

  @override
  Iterable<T> take(int n) => value.take(n);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => value.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => value.toList(growable: growable);

  @override
  Set<T> toSet() => value.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => value.where(test);

  @override
  Iterable<E> whereType<E>() => value.whereType<E>();

  @override
  void dependOn(
    Listenable listenable, [
    List<T> Function(List<T> origin)? filter,
  ]) {
    if (value is DynamicCollectionModel<T>) {
      (value as DynamicCollectionModel<T>).dependOn(listenable, filter);
    }
  }

  @override
  void initState() {
    if (value is Model<List<T>>) {
      (value as Model<List<T>>).initState();
    }
  }

  @override
  void dispose() {
    if (value is ChangeNotifier) {
      (value as ChangeNotifier).dispose();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    if (value is Listenable) {
      (value as Listenable).addListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (value is Listenable) {
      (value as Listenable).removeListener(listener);
    }
  }

  @override
  bool get hasListeners {
    if (value is ChangeNotifier) {
      return (value as ChangeNotifier).hasListeners;
    }
    return false;
  }

  @override
  void notifyListeners() {
    if (value is ChangeNotifier) {
      (value as ChangeNotifier).notifyListeners();
    }
  }

  @override
  bool get disposed {
    if (value is ValueModel<List<T>>) {
      return (value as ValueModel<List<T>>).disposed;
    }
    return false;
  }

  @override
  Future<void>? get loading {
    if (value is FutureModel<List<T>>) {
      return (value as FutureModel<List<T>>).loading;
    }
    return null;
  }

  @override
  Future<void>? get saving {
    if (value is FutureModel<List<T>>) {
      return (value as FutureModel<List<T>>).saving;
    }
    return null;
  }

  @override
  bool get notifyOnChangeList {
    if (value is ListModel<T>) {
      return (value as ListModel<T>).notifyOnChangeList;
    }
    return false;
  }

  @override
  bool get notifyOnChangeValue {
    if (value is ValueModel<List<T>>) {
      return (value as ValueModel<List<T>>).notifyOnChangeValue;
    }
    return false;
  }

  @override
  ValueNotifier<V> toNotifier<V>(V Function(List<T> value) converter) {
    if (value is ValueModel<List<T>>) {
      (value as ValueModel<List<T>>).toNotifier(converter);
    }
    return ValueNotifier<V>(converter(const []));
  }
}
