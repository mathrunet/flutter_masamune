part of masamune_picker;

/// Adapter for defining the internal process for file picks in [Picker].
///
/// Some file pick functions restrict the platform (e.g., camera functions), so if necessary, an adapter can be defined and used.
///
/// If you have a [PickerAdapter] that you want to use, define it in advance in [PickerAdapterScope] or pass it directly when creating a [Picker] object.
///
/// [Picker]でファイルピックを行うための内部処理を定義するためのアダプター。
///
/// ファイルピックの機能によってはプラットフォームを制限するものがある（カメラ機能など）ため必要であればアダプターを定義して利用します。
///
/// 利用したい[PickerAdapter]がある場合は、[PickerAdapterScope]で予め定義するか[Picker]のオブジェクト作成時に直接渡してください。
abstract class PickerAdapter {
  /// Adapter for defining the internal process for file picks in [Picker].
  ///
  /// Some file pick functions restrict the platform (e.g., camera functions), so if necessary, an adapter can be defined and used.
  ///
  /// If you have a [PickerAdapter] that you want to use, define it in advance in [PickerAdapterScope] or pass it directly when creating a [Picker] object.
  ///
  /// [Picker]でファイルピックを行うための内部処理を定義するためのアダプター。
  ///
  /// ファイルピックの機能によってはプラットフォームを制限するものがある（カメラ機能など）ため必要であればアダプターを定義して利用します。
  ///
  /// 利用したい[PickerAdapter]がある場合は、[PickerAdapterScope]で予め定義するか[Picker]のオブジェクト作成時に直接渡してください。
  const PickerAdapter();

  /// You can retrieve the [PickerAdapter] first given by [PickerAdapterScope].
  ///
  /// 最初に[PickerAdapterScope]で与えた[PickerAdapter]を取得することができます。
  static PickerAdapter get primary {
    assert(
      _primary != null,
      "MediaAdapter is not set. Place [MediaAdapterScope] widget closer to the root.",
    );
    return _primary ?? const TestPickerAdapter();
  }

  static PickerAdapter? _primary;

  /// Implement a process to pick up single files.
  ///
  /// The title of the file dialog to be picked up is passed in [dialogTitle].
  ///
  /// Please specify [type] to restrict the type of file.
  ///
  /// 単一のファイルをピックアップするための処理を実装してください。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルが渡されます。
  ///
  /// [type]を指定するとファイルの種類を制限するようにしてください。
  Future<PickerValue> pickSingle({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  });

  /// Implement a process to pick up multiple files.
  ///
  /// The title of the file dialog to be picked up is passed in [dialogTitle].
  ///
  /// Please specify [type] to restrict the type of file.
  ///
  /// 複数のファイルをピックアップするための処理を実装してください。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルが渡されます。
  ///
  /// [type]を指定するとファイルの種類を制限するようにしてください。
  Future<List<PickerValue>> pickMultiple({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  });

  /// Implement a process to activate the camera and pick up the captured media files.
  ///
  /// The title of the file dialog to be picked up is passed in [dialogTitle].
  ///
  /// Please specify [type] to restrict the type of file.
  ///
  /// カメラを起動し、撮影したメディアファイルをピックアップするための処理を実装してください。
  ///
  /// [dialogTitle]でピックアップする際のファイルダイアログのタイトルが渡されます。
  ///
  /// [type]を指定するとファイルの種類を制限するようにしてください。
  Future<PickerValue> pickCamera({
    String? dialogTitle,
    PickerFileType type = PickerFileType.any,
  });
}

/// [PickerAdapter] for the entire app by placing it on top of [MaterialApp], etc.
///
/// Pass [PickerAdapter] to [adapter].
///
/// Also, by using [PickerAdapterScope.of] in a descendant widget, you can retrieve the [PickerAdapter] set in the [PickerAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[PickerAdapter]を設定します。
///
/// [adapter]に[PickerAdapter]を渡してください。
///
/// また[PickerAdapterScope.of]を子孫のウィジェット内で利用することにより[PickerAdapterScope]で設定された[PickerAdapter]を取得することができます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return PickerAdapterScope(
///       adapter: const FilePickerAdapter(),
///       child: MaterialApp(
///         home: const PickerPage(),
///       ),
///     );
///   }
/// }
/// ```
class PickerAdapterScope extends StatefulWidget {
  /// [PickerAdapter] for the entire app by placing it on top of [MaterialApp], etc.
  ///
  /// Pass [PickerAdapter] to [adapter].
  ///
  /// Also, by using [PickerAdapterScope.of] in a descendant widget, you can retrieve the [PickerAdapter] set in the [PickerAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[PickerAdapter]を設定します。
  ///
  /// [adapter]に[PickerAdapter]を渡してください。
  ///
  /// また[PickerAdapterScope.of]を子孫のウィジェット内で利用することにより[PickerAdapterScope]で設定された[PickerAdapter]を取得することができます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return PickerAdapterScope(
  ///       adapter: const FilePickerAdapter(),
  ///       child: MaterialApp(
  ///         home: const PickerPage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const PickerAdapterScope({
    super.key,
    required this.child,
    required this.adapter,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [PickerAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[PickerAdapter]。
  final PickerAdapter adapter;

  /// By passing [context], the [PickerAdapter] set in [PickerAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [PickerAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[PickerAdapterScope]で設定された[PickerAdapter]を取得することができます。
  ///
  /// 祖先に[PickerAdapterScope]がない場合はエラーになります。
  static PickerAdapter? of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<_PickerAdapterScope>();
    assert(
      scope != null,
      "PickerAdapterScope is not found. Place [PickerAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _PickerAdapterScope?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() => _PickerAdapterScopeState();
}

class _PickerAdapterScopeState extends State<PickerAdapterScope> {
  @override
  void initState() {
    super.initState();
    PickerAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _PickerAdapterScope(child: widget.child, adapter: widget.adapter);
  }
}

class _PickerAdapterScope extends InheritedWidget {
  const _PickerAdapterScope({
    required super.child,
    required this.adapter,
  });

  final PickerAdapter adapter;

  @override
  bool updateShouldNotify(covariant _PickerAdapterScope oldWidget) => false;
}
