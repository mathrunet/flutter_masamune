part of katana_storage;

@immutable
class StorageQuery {
  const StorageQuery(
    this.path, {
    StorageAdapter? adapter,
  }) : _adapter = adapter;

  final String path;

  StorageAdapter get adapter {
    return _adapter ?? StorageAdapter.primary;
  }

  final StorageAdapter? _adapter;
}
