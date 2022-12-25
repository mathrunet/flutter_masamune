part of katana_storage;

/// Adapter for storage functions.
///
/// Switch this adapter when running on various platforms such as local or Firebase.
///
/// Allows files to be uploaded from local with [upload] or [uploadWithBytes].
///
/// After uploading, use [fetchPublicURI] or [fetchDownloadURI] to get the full path on the storage side.
///
/// Also, please make it available for download at [download].
///
/// Please also enable file deletion with [delete].
///
/// ストレージ機能を利用するためのアダプター。
///
/// ローカルやFirebaseなど様々なプラットフォーム上で動かす場合にこのアダプターを切り替えて利用します。
///
/// [upload]や[uploadWithBytes]でファイルをローカルからアップロードできるようにします。
///
/// アップロード後は[fetchPublicURI]や[fetchDownloadURI]でストレージ側のフルパスを取得できるようにしてください。
///
/// また、[download]でダウンロードできるようにしてください。
///
/// [delete]でファイル削除も可能にしてください。
@immutable
abstract class StorageAdapter {
  /// Adapter for storage functions.
  ///
  /// Switch this adapter when running on various platforms such as local or Firebase.
  ///
  /// Allows files to be uploaded from local with [upload] or [uploadWithBytes].
  ///
  /// After uploading, use [fetchPublicURI] or [fetchDownloadURI] to get the full path on the storage side.
  ///
  /// Also, please make it available for download at [download].
  ///
  /// Please also enable file deletion with [delete].
  ///
  /// ストレージ機能を利用するためのアダプター。
  ///
  /// ローカルやFirebaseなど様々なプラットフォーム上で動かす場合にこのアダプターを切り替えて利用します。
  ///
  /// [upload]や[uploadWithBytes]でファイルをローカルからアップロードできるようにします。
  ///
  /// アップロード後は[fetchPublicURI]や[fetchDownloadURI]でストレージ側のフルパスを取得できるようにしてください。
  ///
  /// また、[download]でダウンロードできるようにしてください。
  ///
  /// [delete]でファイル削除も可能にしてください。
  const StorageAdapter();

  /// You can retrieve the [StorageAdapter] first given by [StorageAdapterScope].
  ///
  /// 最初に[StorageAdapterScope]で与えた[StorageAdapter]を取得することができます。
  static StorageAdapter get primary {
    assert(
      _primary != null,
      "StorageAdapter is not set. Place [StorageAdapterScope] widget closer to the root.",
    );
    return _primary ?? const LocalStorageAdapter();
  }

  static StorageAdapter? _primary;

  /// Please make sure that you can get a publicly available URL. Use this URI when you want to retrieve images, etc. using `Image.network`, etc.
  ///
  /// 公開可能なURLを取得できるようにしてください。画像等を`Image.network`などで取得したい場合このURIを利用します。
  Future<Uri> fetchPublicURI(String remoteRelativePath);

  /// Please make sure you can get the URI to download the file.
  ///
  /// ファイルをダウンロードするためのURIを取得できるようにしてください。
  Future<Uri> fetchDownloadURI(String remoteRelativePath);

  /// Download the file on the remote side specified in [remoteRelativePath] to [localRelativePath] on the local.
  ///
  /// Both are passed relative to the root folder on each platform.
  ///
  /// Return [LocalFile] containing the full path of the cache to download and the actual data as the return value.
  ///
  /// If [localRelativePath] is not specified, ensure that only byte data is retrieved.
  ///
  /// [remoteRelativePath]で指定されたリモート側のファイルをローカル上の[localRelativePath]にダウンロードします。
  ///
  /// どちらも各プラットフォーム上のルートフォルダに対する相対パスが渡されます。
  ///
  /// 戻り値としてダウンロード先のキャッシュのフルパスと実データを格納した[LocalFile]を返してください。
  ///
  /// [localRelativePath]が指定されない場合はバイトデータのみが取得されるようにしてください。
  Future<LocalFile> download(
    String remoteRelativePath, [
    String? localRelativePath,
  ]);

  /// Uploads the local file specified in [localFullPath] to [remoteRelativePath], which is the location on the remote side.
  ///
  /// The full path in the platform is passed to [localFullPath] and the relative path is passed to [remoteRelativePath].
  ///
  /// Return [RemoteFile] containing the full path of the upload destination and the actual data as the return value.
  ///
  /// [localFullPath]で指定されたローカル上のファイルをリモート側の位置であるの[remoteRelativePath]にアップロードします。
  ///
  /// [localFullPath]にプラットフォーム内のフルパスが渡され[remoteRelativePath]に相対パスが渡されます。
  ///
  /// 戻り値としてアップロード先のフルパスと実データを格納した[RemoteFile]を返してください。
  Future<RemoteFile> upload(
    String localFullPath,
    String remoteRelativePath,
  );

  Future<RemoteFile> uploadWithBytes(
    Uint8List uploadFileByte,
    String remoteRelativePath,
  );

  /// Delete files on the remote side in [relativePath].
  ///
  /// A path relative to the root folder on each platform is passed.
  ///
  /// [relativePath]にあるリモート側のファイルを削除します。
  ///
  /// 各プラットフォーム上のルートフォルダに対する相対パスが渡されます。
  Future<void> delete(String relativePath);
}

/// [StorageAdapter] for the entire app by placing it on top of [MaterialApp], etc.
///
/// Pass [StorageAdapter] to [adapter].
///
/// Also, by using [StorageAdapterScope.of] in a descendant widget, you can retrieve the [StorageAdapter] set in the [StorageAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[StorageAdapter]を設定します。
///
/// [adapter]に[StorageAdapter]を渡してください。
///
/// また[StorageAdapterScope.of]を子孫のウィジェット内で利用することにより[StorageAdapterScope]で設定された[StorageAdapter]を取得することができます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return StorageAdapterScope(
///       adapter: const RuntimeStorageAdapter(),
///       child: MaterialApp(
///         home: const StoragePage(),
///       ),
///     );
///   }
/// }
/// ```
class StorageAdapterScope extends StatefulWidget {
  /// [StorageAdapter] for the entire app by placing it on top of [MaterialApp], etc.
  ///
  /// Pass [StorageAdapter] to [adapter].
  ///
  /// Also, by using [StorageAdapterScope.of] in a descendant widget, you can retrieve the [StorageAdapter] set in the [StorageAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[StorageAdapter]を設定します。
  ///
  /// [adapter]に[StorageAdapter]を渡してください。
  ///
  /// また[StorageAdapterScope.of]を子孫のウィジェット内で利用することにより[StorageAdapterScope]で設定された[StorageAdapter]を取得することができます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return StorageAdapterScope(
  ///       adapter: const RuntimeStorageAdapter(),
  ///       child: MaterialApp(
  ///         home: const StoragePage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const StorageAdapterScope({
    super.key,
    required this.child,
    required this.adapter,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [StorageAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[StorageAdapter]。
  final StorageAdapter adapter;

  /// By passing [context], the [StorageAdapter] set in [StorageAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [StorageAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[StorageAdapterScope]で設定された[StorageAdapter]を取得することができます。
  ///
  /// 祖先に[StorageAdapterScope]がない場合はエラーになります。
  static StorageAdapter? of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<_StorageAdapterScope>();
    assert(
      scope != null,
      "StorageAdapterScope is not found. Place [StorageAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _StorageAdapterScope?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() => _StorageAdapterScopeState();
}

class _StorageAdapterScopeState extends State<StorageAdapterScope> {
  @override
  void initState() {
    super.initState();
    StorageAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _StorageAdapterScope(child: widget.child, adapter: widget.adapter);
  }
}

class _StorageAdapterScope extends InheritedWidget {
  const _StorageAdapterScope({
    required super.child,
    required this.adapter,
  });

  final StorageAdapter adapter;

  @override
  bool updateShouldNotify(covariant _StorageAdapterScope oldWidget) => false;
}
