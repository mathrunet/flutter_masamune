part of '/katana_storage.dart';

/// Abstract class for implementing internal storage functionality.
///
/// With [read], you can retrieve already stored rice paddies.
///
/// [write] to save the new data.
///
/// You can delete data with [delete].
///
/// You can check to see if data is stored in that path under [exists].
///
/// 内部的なストレージ機能を実装するための抽象クラス。
///
/// [read]ですでに保存されているで０田を取得することが出来ます。
///
/// [write]で新しくデータを保存します。
///
/// [delete]でデータを削除することが出来ます。
///
/// [exists]でそのパスにデータが保存されているかを確認することができます。
abstract class StorageBase {
  /// Abstract class for implementing internal storage functionality.
  ///
  /// With [read], you can retrieve already stored rice paddies.
  ///
  /// [write] to save the new data.
  ///
  /// You can delete data with [delete].
  ///
  /// You can check to see if data is stored in that path under [exists].
  ///
  /// 内部的なストレージ機能を実装するための抽象クラス。
  ///
  /// [read]ですでに保存されているで０田を取得することが出来ます。
  ///
  /// [write]で新しくデータを保存します。
  ///
  /// [delete]でデータを削除することが出来ます。
  ///
  /// [exists]でそのパスにデータが保存されているかを確認することができます。
  const StorageBase();

  /// By passing [fileFullPath], the full path of the storage, data can be retrieved from that path.
  ///
  /// ストレージのフルパスである[fileFullPath]を渡すことでそのパスからデータを取得することが出来ます。
  Future<Uint8List> read(String fileFullPath);

  /// By passing the full path of the storage [fileFullPath] and the actual data [bytes], the file can be saved in that path.
  ///
  /// ストレージのフルパスである[fileFullPath]と実データ[bytes]を渡すことでそのパスにファイルを保存することができます。
  Future<void> write(String fileFullPath, Uint8List bytes);

  /// Passing [fileFullPath], the full path of the storage, will delete files at that location.
  ///
  /// ストレージのフルパスである[fileFullPath]を渡すことでその位置にあるファイルを削除します。
  Future<void> delete(String fileFullPath);

  /// By passing [fileFullPath], which is the full path of the storage, it checks if the file exists at that location.
  ///
  /// Returns `true` if the file exists.
  ///
  /// ストレージのフルパスである[fileFullPath]を渡すことでその位置にファイルがあるかをチェックします。
  ///
  /// ファイルが存在する場合`true`を返します。
  Future<bool> exists(String fileFullPath);

  /// Passing [fileRelativePath], a path relative to the storage root, returns the full path to the file at that location.
  ///
  /// ストレージのルートからの相対パスである[fileRelativePath]を渡すことでその位置にファイルのフルパスを返します。
  Future<String> fetchURI(String fileRelativePath);
}
