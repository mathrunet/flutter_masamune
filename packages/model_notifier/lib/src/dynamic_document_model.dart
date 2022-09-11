part of model_notifier;

/// Documentation model for flexibly modifying the contents of an object that is primarily a [DynamicMap].
abstract class DynamicDocumentModel
    implements
        DocumentModel<DynamicMap>,
        DynamicMap,
        ListenableDynamicMap,
        FutureModel<DynamicMap> {}

/// Class for mix-ins to facilitate use of DynamicDocumentModel.
///
/// Only [value] is defined and used as shown below.
///
/// ```
/// class MyDynamicDocumentModel with DynamicDocumentModelMixin implements DynamicDocumentModel {
///   MyDynamicDocumentModel();
///
///   @override
///   final DynamicMap value = {};
/// }
/// ```
abstract class DynamicDocumentModelMixin implements DynamicDocumentModel {
  @override
  DynamicMap get value;
  @override
  Iterable<String> get keys => value.keys;
  @override
  dynamic operator [](Object? key) => value[key];
  @override
  operator []=(String key, Object? val) => value[key] = val;
  @override
  dynamic remove(Object? key) => value.remove(key);

  @override
  void clear() => value.clear();

  @override
  Map<RK, RV> cast<RK, RV>() => Map.castFrom<String, dynamic, RK, RV>(this);

  @override
  void forEach(void action(String key, dynamic value)) {
    for (final key in keys) {
      action(key, this[key]);
    }
  }

  @override
  void addAll(Map<String, dynamic> other) {
    other.forEach((String key, dynamic value) {
      this[key] = value;
    });
  }

  @override
  bool containsValue(Object? value) {
    for (final key in keys) {
      if (this[key] == value) {
        return true;
      }
    }
    return false;
  }

  @override
  dynamic putIfAbsent(String key, dynamic ifAbsent()) {
    if (containsKey(key)) {
      return this[key];
    }
    return this[key] = ifAbsent();
  }

  @override
  dynamic update(
    String key,
    dynamic update(dynamic value), {
    dynamic Function()? ifAbsent,
  }) {
    if (containsKey(key)) {
      return this[key] = update(this[key]);
    }
    if (ifAbsent != null) {
      return this[key] = ifAbsent();
    }
    throw ArgumentError.value(key, "key", "Key not in map.");
  }

  @override
  void updateAll(dynamic update(String key, dynamic value)) {
    for (final key in keys) {
      this[key] = update(key, this[key]);
    }
  }

  @override
  Iterable<MapEntry<String, dynamic>> get entries {
    return keys.map((String key) => MapEntry<String, dynamic>(key, this[key]));
  }

  @override
  Map<K2, V2> map<K2, V2>(
    MapEntry<K2, V2> transform(String key, dynamic value),
  ) {
    final result = <K2, V2>{};
    for (final key in keys) {
      final entry = transform(key, this[key]);
      result[entry.key] = entry.value;
    }
    return result;
  }

  @override
  void addEntries(Iterable<MapEntry<String, dynamic>> newEntries) {
    for (final entry in newEntries) {
      this[entry.key] = entry.value;
    }
  }

  @override
  void removeWhere(bool test(String key, dynamic value)) {
    final keysToRemove = <String>[];
    for (final key in keys) {
      if (test(key, this[key])) {
        keysToRemove.add(key);
      }
    }
    keysToRemove.forEach((key) => remove(key));
  }

  @override
  bool containsKey(Object? key) => keys.contains(key);
  @override
  int get length => keys.length;
  @override
  bool get isEmpty => keys.isEmpty;
  @override
  bool get isNotEmpty => keys.isNotEmpty;
  @override
  Iterable<dynamic> get values => value.values;
  @override
  String toString() => MapBase.mapToString(this);

  @override
  void addListener(VoidCallback listener) {
    if (value is Listenable) {
      (value as Listenable).addListener(listener);
    }
  }

  @override
  void dependOn(
    Listenable listenable, [
    Map<String, dynamic> Function(Map<String, dynamic> origin)? filter,
  ]) {
    if (value is ListenableDynamicMap) {
      (value as ListenableDynamicMap).dependOn(listenable, filter);
    }
  }

  @override
  void dispose() {
    if (value is ChangeNotifier) {
      (value as ChangeNotifier).dispose();
    }
  }

  @override
  bool get disposed {
    if (value is Model<DynamicMap>) {
      return (value as Model<DynamicMap>).disposed;
    }
    return false;
  }

  @override
  DynamicMap fromMap(DynamicMap map) {
    if (value is DynamicDocumentModel) {
      return (value as DynamicDocumentModel).fromMap(map);
    }
    return {};
  }

  @override
  bool get hasListeners {
    if (value is ChangeNotifier) {
      return (value as ChangeNotifier).hasListeners;
    }
    return false;
  }

  @override
  void initState() {
    if (value is Model<DynamicMap>) {
      (value as Model<DynamicMap>).initState();
    }
  }

  @override
  Future<void>? get loading {
    if (value is FutureModel<DynamicMap>) {
      return (value as FutureModel<DynamicMap>).loading;
    }
    return null;
  }

  @override
  void notifyListeners() {
    if (value is ChangeNotifier) {
      (value as ChangeNotifier).notifyListeners();
    }
  }

  @override
  bool get notifyOnChangeValue {
    if (value is ValueModel<DynamicMap>) {
      return (value as ValueModel<DynamicMap>).notifyOnChangeValue;
    }
    return false;
  }

  @override
  void removeListener(VoidCallback listener) {
    if (value is Listenable) {
      (value as Listenable).removeListener(listener);
    }
  }

  @override
  Future<void>? get saving {
    if (value is FutureModel<DynamicMap>) {
      return (value as FutureModel<DynamicMap>).saving;
    }
    return null;
  }

  @override
  DynamicMap toMap(DynamicMap value) {
    if (this.value is DynamicDocumentModel) {
      return (this.value as DynamicDocumentModel).toMap(value);
    }
    return {};
  }

  @override
  ValueNotifier<V> toNotifier<V>(V Function(DynamicMap value) converter) {
    if (value is ValueModel<DynamicMap>) {
      return (value as ValueModel<DynamicMap>).toNotifier(converter);
    }
    return ValueNotifier<V>(converter(<String, dynamic>{}));
  }
}
