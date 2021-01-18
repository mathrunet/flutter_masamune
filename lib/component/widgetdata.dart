// part of masamune.flutter;

// /// Data model for storing data for widgets.
// ///
// /// If the widget is destroyed by passing it along with BuildContext,
// /// this object will be destroyed automatically.
// ///
// /// Normally, use from [context.read] or [context.write].
// class WidgetData<T extends Object> extends Unit<T> {
//   /// BuildContext
//   ///
//   /// When the widget related to this is deleted,
//   /// this object is automatically destroyed.
//   final BuildContext context;

//   /// Process to create a new instance.
//   ///
//   /// Do not use from outside the class.
//   ///
//   /// [path]: Destination path.
//   /// [isTemporary]: True if the data is temporary.
//   @override
//   T createInstance<T extends IClonable>(String path, bool isTemporary) =>
//       WidgetData._(path, this.context) as T;

//   /// Get the protocol of the path.
//   @override
//   String get protocol => Protocol.widget;

//   /// Data model for storing data for widgets.
//   ///
//   /// If the widget is destroyed by passing it along with BuildContext,
//   /// this object will be destroyed automatically.
//   ///
//   /// Normally, use from [context.read] or [context.write].
//   ///
//   /// [path]: The path.
//   /// [context]: BuildContext.
//   /// [value]: The value to save.
//   factory WidgetData(String path, BuildContext context, [T value]) {
//     path = path?.applyTags();
//     assert(isNotEmpty(path));
//     assert(context != null);
//     if (isEmpty(path)) {
//       Log.error("The path is invalid.");
//       return null;
//     }
//     if (context == null) {
//       Log.error("The build context is empty.");
//       return null;
//     }
//     WidgetData<T> unit = PathMap.get<WidgetData<T>>(path);
//     if (unit != null) {
//       if (value != null) unit.data = value;
//       return unit;
//     }
//     return WidgetData._(path, context, value);
//   }
//   WidgetData._(String path, BuildContext context, [T value])
//       : this.context = context,
//         super(path, value: value, isTemporary: false, group: 0, order: 10) {
//     UIValue value = UIValue.of(this.context);
//     assert(value != null);
//     value?.willDisposePathList?.add(this);
//   }
// }
