part of masamune_picker;

/// Adapter for defining the internal process for file picks in [Picker].
///
/// Some file pick functions restrict the platform (e.g., camera functions), so if necessary, an adapter can be defined and used.
///
/// If you have a [PickerMasamuneAdapter] that you want to use, define it in advance in [PickerAdapterScope] or pass it directly when creating a [Picker] object.
///
/// It is also possible to pass it as [MasamuneAdapter] in [runMasamuneApp].
///
/// [Picker]でファイルピックを行うための内部処理を定義するためのアダプター。
///
/// ファイルピックの機能によってはプラットフォームを制限するものがある（カメラ機能など）ため必要であればアダプターを定義して利用します。
///
/// 利用したい[PickerMasamuneAdapter]がある場合は、[PickerAdapterScope]で予め定義するか[Picker]のオブジェクト作成時に直接渡してください。
///
/// [runMasamuneApp]で[MasamuneAdapter]として渡すことも可能です。
abstract class PickerMasamuneAdapter extends MasamuneAdapter {
  /// Adapter for defining the internal process for file picks in [Picker].
  ///
  /// Some file pick functions restrict the platform (e.g., camera functions), so if necessary, an adapter can be defined and used.
  ///
  /// If you have a [PickerMasamuneAdapter] that you want to use, define it in advance in [PickerAdapterScope] or pass it directly when creating a [Picker] object.
  ///
  /// It is also possible to pass it as [MasamuneAdapter] in [runMasamuneApp].
  ///
  /// [Picker]でファイルピックを行うための内部処理を定義するためのアダプター。
  ///
  /// ファイルピックの機能によってはプラットフォームを制限するものがある（カメラ機能など）ため必要であればアダプターを定義して利用します。
  ///
  /// 利用したい[PickerMasamuneAdapter]がある場合は、[PickerAdapterScope]で予め定義するか[Picker]のオブジェクト作成時に直接渡してください。
  ///
  /// [runMasamuneApp]で[MasamuneAdapter]として渡すことも可能です。
  const PickerMasamuneAdapter();

  /// You can retrieve the [PickerMasamuneAdapter] first given by [PickerAdapterScope].
  ///
  /// 最初に[PickerAdapterScope]で与えた[PickerMasamuneAdapter]を取得することができます。
  static PickerMasamuneAdapter get primary {
    assert(
      _primary != null,
      "MediaAdapter is not set. Place [MediaAdapterScope] widget closer to the root.",
    );
    return _primary ?? const TestPickerMasamuneAdapter();
  }

  static PickerMasamuneAdapter? _primary;

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

  @override
  final bool runZonedGuarded = false;

  @override
  final List<NavigatorObserver> navigatorObservers = const [];

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return PickerAdapterScope(adapter: this, child: app);
  }

  @override
  FutureOr<void> onPreRunApp() {}

  @override
  void onError(Object error, StackTrace stackTrace) {}
}

/// [PickerMasamuneAdapter] for the entire app by placing it on top of [MaterialApp], etc.
///
/// Pass [PickerMasamuneAdapter] to [adapter].
///
/// Also, by using [PickerAdapterScope.of] in a descendant widget, you can retrieve the [PickerMasamuneAdapter] set in the [PickerAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[PickerMasamuneAdapter]を設定します。
///
/// [adapter]に[PickerMasamuneAdapter]を渡してください。
///
/// また[PickerAdapterScope.of]を子孫のウィジェット内で利用することにより[PickerAdapterScope]で設定された[PickerMasamuneAdapter]を取得することができます。
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
  /// [PickerMasamuneAdapter] for the entire app by placing it on top of [MaterialApp], etc.
  ///
  /// Pass [PickerMasamuneAdapter] to [adapter].
  ///
  /// Also, by using [PickerAdapterScope.of] in a descendant widget, you can retrieve the [PickerMasamuneAdapter] set in the [PickerAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[PickerMasamuneAdapter]を設定します。
  ///
  /// [adapter]に[PickerMasamuneAdapter]を渡してください。
  ///
  /// また[PickerAdapterScope.of]を子孫のウィジェット内で利用することにより[PickerAdapterScope]で設定された[PickerMasamuneAdapter]を取得することができます。
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

  /// [PickerMasamuneAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[PickerMasamuneAdapter]。
  final PickerMasamuneAdapter adapter;

  /// By passing [context], the [PickerMasamuneAdapter] set in [PickerAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [PickerAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[PickerAdapterScope]で設定された[PickerMasamuneAdapter]を取得することができます。
  ///
  /// 祖先に[PickerAdapterScope]がない場合はエラーになります。
  static PickerMasamuneAdapter? of(BuildContext context) {
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
    PickerMasamuneAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _PickerAdapterScope(adapter: widget.adapter, child: widget.child);
  }
}

class _PickerAdapterScope extends InheritedWidget {
  const _PickerAdapterScope({
    required super.child,
    required this.adapter,
  });

  final PickerMasamuneAdapter adapter;

  @override
  bool updateShouldNotify(covariant _PickerAdapterScope oldWidget) => false;
}
