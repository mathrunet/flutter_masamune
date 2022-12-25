part of katana_storage;

/// Query to specify the path of storage on the remote side.
///
/// Specify the local path on the storage side in [relativePath].
///
/// If you want to specify [StorageAdapter] directly, pass it to [adapter].
///
/// リモート側のストレージのパスを指定するためのクエリ。
///
/// [relativePath]でストレージ側のローカルパスを指定します。
///
/// [StorageAdapter]を直接指定したい場合、[adapter]に渡してください。
@immutable
class StorageQuery {
  /// Query to specify the path of storage on the remote side.
  ///
  /// Specify the local path on the storage side in [relativePath].
  ///
  /// If you want to specify [StorageAdapter] directly, pass it to [adapter].
  ///
  /// リモート側のストレージのパスを指定するためのクエリ。
  ///
  /// [relativePath]でストレージ側のローカルパスを指定します。
  ///
  /// [StorageAdapter]を直接指定したい場合、[adapter]に渡してください。
  const StorageQuery(
    this.relativePath, {
    StorageAdapter? adapter,
  }) : _adapter = adapter;

  /// Local path on the storage side.
  ///
  /// Specify a relative path with the root folder as the storage side storable folder.
  ///
  /// ストレージ側のローカルパス。
  ///
  /// ストレージ側の保存可能なフォルダをルートにした相対パスを指定します。
  final String relativePath;

  /// [StorageAdapter] to be used.
  ///
  /// If not specified, [StorageAdapter.primary] is used.
  ///
  /// 使用する[StorageAdapter]。
  ///
  /// 指定されない場合は[StorageAdapter.primary]が利用されます。
  StorageAdapter get adapter {
    return _adapter ?? StorageAdapter.primary;
  }

  final StorageAdapter? _adapter;
}
