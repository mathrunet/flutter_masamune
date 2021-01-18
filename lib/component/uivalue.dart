// part of masamune.flutter;

// /// Class that manages values.
// ///
// /// Please use in conjunction with UIWidget.
// ///
// /// Usually used to get the value using [get()] and [text()].
// class UIValue {
//   /// Root observer.
//   ///
//   /// ```
//   /// return new MaterialApp(
//   ///   ...
//   ///   navigatorObservers: <NavigatorObserver>[UIValue.routeObserver],
//   ///   ...
//   /// );
//   /// ```
//   static RouteObserver<PageRoute> get routeObserver => _routeObserver;
//   static RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();
//   UIWidgetState _state;

//   /// List of Paths to dispose with when UIValue is disposed.
//   PathList get willDisposePathList => this._willDisposePathList;
//   PathList _willDisposePathList = PathList();
//   Map<String, Observer> _data = MapPool.get();
//   UIValue._(UIWidgetState state) : this._state = state;
//   _UIWidgetContainerState _container;
//   IDataDocument _form;
//   int _updatedTime = 0;

//   /// The closest instance of this class that encloses the given context.
//   ///
//   /// Typical usage:
//   ///
//   /// ```dart
//   /// UIValue controller = UIValue.of(context);
//   /// ```
//   ///
//   /// [context]: Build context.
//   static UIValue of(BuildContext context) {
//     final _UIWidgetScope scope = context
//         .getElementForInheritedWidgetOfExactType<_UIWidgetScope>()
//         ?.widget;
//     return scope?.target?._value;
//   }

//   /// Forces the widget to update.
//   void refresh() => this._state?._refresh();

//   /// Get text from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to text.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   T watch<T extends Object>(String path, {T defaultValue, T filter(T value)}) {
//     path = path?.applyTags();
//     if (isEmpty(path)) {
//       return filter != null
//           ? filter(PathMap.get<T>(path) ?? defaultValue)
//           : (PathMap.get<T>(path) ?? defaultValue);
//     }
//     this._addPath(path);
//     return filter != null
//         ? filter(PathMap.get<T>(path) ?? defaultValue)
//         : (PathMap.get<T>(path) ?? defaultValue);
//   }

//   /// Get object from pathmap in conjunction with UIWidget.
//   ///
//   /// You can get any IPath object other than String.
//   ///
//   /// Please use it for update processing in the widget.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   T read<T extends Object>(String path, {T defaultValue, T filter(T value)}) {
//     path = path?.applyTags();
//     if (isEmpty(path)) {
//       return filter != null
//           ? filter(PathMap.get<T>(path) ?? defaultValue)
//           : (PathMap.get<T>(path) ?? defaultValue);
//     }
//     return filter != null
//         ? filter(PathMap.get<T>(path) ?? defaultValue)
//         : (PathMap.get<T>(path) ?? defaultValue);
//   }

//   /// Get model from pathmap in conjunction with UIWidget.
//   ///
//   /// [model]: The model to get.
//   T watchModel<T extends Model>(T model) {
//     if (model == null) return model;
//     this.watch<dynamic>(model.path);
//     return model;
//   }

//   /// Get text from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to text.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   String watchText(String path,
//           {String defaultValue = Const.empty, String filter(String value)}) =>
//       filter != null
//           ? filter(this.watch<dynamic>(path)?.toString() ?? defaultValue)
//           : (this.watch<dynamic>(path)?.toString() ?? defaultValue);

//   /// Get text from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to text.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   String readText(String path,
//           {String defaultValue = Const.empty, String filter(String value)}) =>
//       filter != null
//           ? filter(this.read<dynamic>(path)?.toString() ?? defaultValue)
//           : (this.read<dynamic>(path)?.toString() ?? defaultValue);

//   /// Get localized text from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to text.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   String watchLocalized(String path,
//           {String defaultValue = Const.empty, String filter(String value)}) =>
//       filter != null
//           ? filter(Localize.get(
//               this.watch<dynamic>(path)?.toString() ?? defaultValue))
//           : (Localize.get(
//               this.watch<dynamic>(path)?.toString() ?? defaultValue));

//   /// Get localized text from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to text.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   String readLocalized(String path,
//           {String defaultValue = Const.empty, String filter(String value)}) =>
//       filter != null
//           ? filter(Localize.get(
//               this.read<dynamic>(path)?.toString() ?? defaultValue))
//           : (Localize.get(
//               this.read<dynamic>(path)?.toString() ?? defaultValue));

//   /// Get number from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to double.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   double watchNumber(String path,
//       {double defaultValue = 0, double filter(double value)}) {
//     dynamic tmp = this.watch<dynamic>(path);
//     if (tmp is double) return filter != null ? filter(tmp) : tmp;
//     if (tmp is int) return filter != null ? filter(tmp as double) : tmp;
//     if (tmp is bool)
//       return filter != null ? filter(tmp ? 1 : 0) : (tmp ? 1 : 0);
//     if (tmp is String) {
//       return filter != null
//           ? filter(double.tryParse(tmp) ?? defaultValue)
//           : (double.tryParse(tmp) ?? defaultValue);
//     }
//     return filter != null ? filter(defaultValue) : defaultValue;
//   }

//   /// Get number from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to double.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   double readNumber(String path,
//       {double defaultValue = 0, double filter(double value)}) {
//     dynamic tmp = this.read<dynamic>(path);
//     if (tmp is double) return filter != null ? filter(tmp) : tmp;
//     if (tmp is int)
//       return filter != null ? filter(tmp?.toDouble()) : tmp?.toDouble();
//     if (tmp is bool)
//       return filter != null ? filter(tmp ? 1 : 0) : (tmp ? 1 : 0);
//     if (tmp is String) {
//       return filter != null
//           ? filter(double.tryParse(tmp) ?? defaultValue)
//           : (double.tryParse(tmp) ?? defaultValue);
//     }
//     return filter != null ? filter(defaultValue) : defaultValue;
//   }

//   /// Get boolean flag from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to double.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   bool watchBoolean(String path,
//       {bool defaultValue = false, bool filter(bool value)}) {
//     dynamic tmp = this.watch<dynamic>(path);
//     if (tmp is bool) return filter != null ? filter(tmp) : tmp;
//     if (tmp is double) return filter != null ? filter(tmp != 0) : tmp != 0;
//     if (tmp is int) return filter != null ? filter(tmp != 0) : tmp != 0;
//     if (tmp is String) {
//       return filter != null
//           ? filter(tmp.toLowerCase() == "true")
//           : (tmp.toLowerCase() == "true");
//     }
//     return filter != null ? filter(defaultValue) : defaultValue;
//   }

//   /// Get boolean flag from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to double.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   bool readBoolean(String path,
//       {bool defaultValue = false, bool filter(bool value)}) {
//     dynamic tmp = this.read<dynamic>(path);
//     if (tmp is bool) return filter != null ? filter(tmp) : tmp;
//     if (tmp is double) return filter != null ? filter(tmp != 0) : tmp != 0;
//     if (tmp is int) return filter != null ? filter(tmp != 0) : tmp != 0;
//     if (tmp is String) {
//       return filter != null
//           ? filter(tmp.toLowerCase() == "true")
//           : (tmp.toLowerCase() == "true");
//     }
//     return filter != null ? filter(defaultValue) : defaultValue;
//   }

//   /// Get List from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to List.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   Iterable<T> watchList<T extends Object>(String path,
//           {Iterable<T> defaultValue = const [],
//           Iterable<T> filter(Iterable<T> value)}) =>
//       filter != null
//           ? filter(this.watch<Iterable<T>>(path) ?? defaultValue)
//           : (this.watch<Iterable<T>>(path) ?? defaultValue);

//   /// Get List from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to List.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   Iterable<T> readList<T extends Object>(String path,
//           {Iterable<T> defaultValue = const [],
//           Iterable<T> filter(Iterable<T> value)}) =>
//       filter != null
//           ? filter(this.read<Iterable<T>>(path) ?? defaultValue)
//           : (this.read<Iterable<T>>(path) ?? defaultValue);

//   /// Get Map from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to Map.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   Map<K, V> watchMap<K extends Object, V extends Object>(String path,
//           {Map<K, V> defaultValue = const {},
//           Map<K, V> filter(Map<K, V> value)}) =>
//       filter != null
//           ? filter(this.watch<Map<K, V>>(path) ?? defaultValue)
//           : (this.watch<Map<K, V>>(path) ?? defaultValue);

//   /// Get Map from pathmap in conjunction with UIWidget.
//   ///
//   /// Displays anything as long as Path is Unit and can be converted to Map.
//   ///
//   /// If not, [defaultValue] will be displayed.
//   ///
//   /// [path]: The path to get.
//   /// [defaultValue]: Value if none.
//   /// [filter]: Filter values.
//   Map<K, V> readMap<K extends Object, V extends Object>(String path,
//           {Map<K, V> defaultValue = const {},
//           Map<K, V> filter(Map<K, V> value)}) =>
//       filter != null
//           ? filter(this.read<Map<K, V>>(path) ?? defaultValue)
//           : (this.read<Map<K, V>>(path) ?? defaultValue);

//   /// Get the action callback from pathmap in conjunction with UIWidget.
//   ///
//   /// If it does not exist, the action that does nothing is called.
//   ///
//   /// [path]: The path to get.
//   /// [defaultAction]: Default callback when no value exists in path.
//   VoidAction watchAction(String path, {VoidAction defaultAction}) {
//     return this.watch<VoidAction>(path) ?? defaultAction ?? () {};
//   }

//   /// Get the action callback from pathmap in conjunction with UIWidget.
//   ///
//   /// If it does not exist, the action that does nothing is called.
//   ///
//   /// [path]: The path to get.
//   /// [defaultAction]: Default callback when no value exists in path.
//   VoidAction readAction(String path, {VoidAction defaultAction}) {
//     return this.read<VoidAction>(path) ?? defaultAction ?? () {};
//   }

//   /// Writes the value to the specified path.
//   ///
//   /// It is possible to enter one of the [value] is
//   /// [bool], [int], [double], [String], [Map<String, dynamic>].
//   ///
//   /// [Map] the case of [DataDocument] other than the [DataField] will be saved as.
//   ///
//   /// [path]: The path to write.
//   /// [value]: The value to write.
//   void write<T extends Object>(String path, T value) {
//     assert(value != null);
//     if (value == null) return;
//     if (value is bool || value is double || value is int || value is String) {
//       DataField(path, value);
//     } else if (value is Map<String, dynamic>) {
//       DataDocument.fromMap(path, value);
//     }
//   }

//   /// Increase or decrease the int number for a particular path.
//   ///
//   /// Enter a negative value to decrease it.
//   ///
//   /// [path]: Target path.
//   /// [value]: The value to increase or decrease.
//   void incrementInt(String path, int value) {
//     assert(value != null);
//     if (value == null) return;
//     IDataField field = PathMap.get<IDataField>(path);
//     if (field == null) {
//       DataField(path, value);
//     } else {
//       field.data = (field.data as int) + value.toInt();
//     }
//   }

//   /// Increase or decrease the double number for a particular path.
//   ///
//   /// Enter a negative value to decrease it.
//   ///
//   /// [path]: Target path.
//   /// [value]: The value to increase or decrease.
//   void incrementDouble(String path, double value) {
//     assert(value != null);
//     if (value == null) return;
//     IDataField field = PathMap.get<IDataField>(path);
//     if (field == null) {
//       DataField(path, value);
//     } else {
//       field.data = (field.data as double) + value;
//     }
//   }

//   /// True if data is present in the path.
//   ///
//   /// [path]: The path you want to check.
//   bool exists(String path) {
//     final tmp = PathMap.get(path);
//     if (tmp is ICollection) {
//       return tmp.length > 0;
//     } else if (tmp is IDocument) {
//       return tmp.length > 0;
//     } else if (tmp is IUnit) {
//       return tmp.data != null;
//     } else {
//       return tmp != null;
//     }
//   }

//   /// Get the form data.
//   IDataDocument get form {
//     if (this._form != null) return this._form;
//     this._form = TemporaryDocument();
//     return this._form;
//   }

//   /// Set the form data.
//   set form(IDataDocument document) => this._form = document;

//   /// Gets the current context.
//   BuildContext get context => this._container?.context;

//   /// Gets the current widget.
//   Widget get widget => this._state.widget;
//   bool _containsPath(IPath path) {
//     if (path == null) return false;
//     UIValue parent = UIValue.of(this._state.context);
//     if (parent != null && parent._containsPath(path)) return true;
//     return this._data.containsKey(path.path);
//   }

//   void _addPath(String path) {
//     if (isEmpty(path) || this._data.containsKey(path)) return;
//     Observer observer = Observer();
//     PathListener.listen(path, this._notifyUpdate, observer: observer);
//     this._data[path] = observer;
//     Log.ast("Add rebuild listener: %s (%s) %d at %s", [
//       this._state.widget.runtimeType,
//       this._state.widget.key?.toString(),
//       this._updatedTime,
//       path
//     ]);
//   }

//   void _notifyUpdate(dynamic object) {
//     if (object is IPath) {
//       int updatedTime = object.asType<IPath>().updatedTime;
//       if (this._updatedTime >= updatedTime) return;
//       this._updatedTime = updatedTime;
//     }
//     this._state?._notifyUpdate(object);
//   }

//   void _dispose() {
//     for (Observer tmp in this._data.values) tmp.dispose();
//     this._willDisposePathList.dispose();
//     this._data.release();
//     this._state = null;
//   }
// }
