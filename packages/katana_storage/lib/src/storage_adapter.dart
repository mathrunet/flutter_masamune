part of "/katana_storage.dart";

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
  static StorageAdapter? _test;

  /// Please make sure that you can get a publicly available URL. Use this URI when you want to retrieve images, etc. using `Image.network`, etc.
  ///
  /// 公開可能なURLを取得できるようにしてください。画像等を`Image.network`などで取得したい場合このURIを利用します。
  Future<Uri> fetchPublicURI(String remoteRelativePathOrId);

  /// Please make sure you can get the URI to download the file.
  ///
  /// ファイルをダウンロードするためのURIを取得できるようにしてください。
  Future<Uri> fetchDownloadURI(String remoteRelativePathOrId);

  /// Download the file on the remote side specified in [remoteRelativePathOrId] to [localRelativePath] on the local.
  ///
  /// Both are passed relative to the root folder on each platform.
  ///
  /// Return [LocalFile] containing the full path of the cache to download and the actual data as the return value.
  ///
  /// If [localRelativePath] is not specified, ensure that only byte data is retrieved.
  ///
  /// [remoteRelativePathOrId]で指定されたリモート側のファイルをローカル上の[localRelativePath]にダウンロードします。
  ///
  /// どちらも各プラットフォーム上のルートフォルダに対する相対パスが渡されます。
  ///
  /// 戻り値としてダウンロード先のキャッシュのフルパスと実データを格納した[LocalFile]を返してください。
  ///
  /// [localRelativePath]が指定されない場合はバイトデータのみが取得されるようにしてください。
  Future<LocalFile> download(
    String remoteRelativePathOrId, [
    String? localRelativePath,
  ]);

  /// Uploads the local file specified in [localFullPath] to [remoteRelativePathOrId], which is the location on the remote side.
  ///
  /// The full path in the platform is passed to [localFullPath] and the relative path is passed to [remoteRelativePathOrId].
  ///
  /// Return [RemoteFile] containing the full path of the upload destination and the actual data as the return value.
  ///
  /// You can specify the MIME type for uploading with [mimeType].
  ///
  /// [localFullPath]で指定されたローカル上のファイルをリモート側の位置であるの[remoteRelativePathOrId]にアップロードします。
  ///
  /// [localFullPath]にプラットフォーム内のフルパスが渡され[remoteRelativePathOrId]に相対パスが渡されます。
  ///
  /// 戻り値としてアップロード先のフルパスと実データを格納した[RemoteFile]を返してください。
  ///
  /// [mimeType]でアップロード時のMIMEタイプを指定できます。
  Future<RemoteFile> upload(
    String localFullPath,
    String remoteRelativePathOrId, {
    String? mimeType,
  });

  /// Uploads the data specified in [uploadFileByte] to [remoteRelativePathOrId], which is the location on the remote side.
  ///
  /// The byte data of the file is passed to [uploadFileByte] and the relative path is passed to [remoteRelativePathOrId].
  ///
  /// Return [RemoteFile] containing the full path of the upload destination and the actual data as the return value.
  ///
  /// You can specify the MIME type for uploading with [mimeType].
  ///
  /// [uploadFileByte]で指定されたデータをリモート側の位置であるの[remoteRelativePathOrId]にアップロードします。
  ///
  /// [uploadFileByte]にファイルのバイトデータが渡され[remoteRelativePathOrId]に相対パスが渡されます。
  ///
  /// 戻り値としてアップロード先のフルパスと実データを格納した[RemoteFile]を返してください。
  ///
  /// [mimeType]でアップロード時のMIMEタイプを指定できます。
  Future<RemoteFile> uploadWithBytes(
    Uint8List uploadFileByte,
    String remoteRelativePathOrId, {
    String? mimeType,
  });

  /// Delete files on the remote side in [remoteRelativePathOrId].
  ///
  /// A path relative to the root folder on each platform is passed.
  ///
  /// [remoteRelativePathOrId]にあるリモート側のファイルを削除します。
  ///
  /// 各プラットフォーム上のルートフォルダに対する相対パスが渡されます。
  Future<void> delete(String remoteRelativePathOrId);
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
    required this.child,
    required this.adapter,
    super.key,
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
    return _StorageAdapterScope(adapter: widget.adapter, child: widget.child);
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

/// Test scope for [StorageAdapter].
///
/// [StorageAdapter]のテスト用スコープ。
class TestStorageAdapterScope {
  const TestStorageAdapterScope._();

  /// Set the [StorageAdapter] for testing.
  ///
  /// テスト用に[StorageAdapter]を設定します。
  static void setTestAdapter(StorageAdapter adapter) {
    StorageAdapter._primary = adapter;
  }
}
