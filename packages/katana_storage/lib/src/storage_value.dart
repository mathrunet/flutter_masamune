part of '/katana_storage.dart';

/// Define storage values.
///
/// The file path and byte data on the local side are stored in [local], and the file path and byte data on the remote side are stored in [remote].
///
/// ストレージの値を定義します。
///
/// [local]にローカル側のファイルパスやバイトデータが格納され、[remote]にリモート側のファイルパスやバイトデータが格納されます。
@immutable
class StorageValue {
  const StorageValue._({
    this.local,
    this.remote,
  });

  /// LocalFile], which contains the file path and byte data on the local side.
  ///
  /// ローカル側のファイルパスやバイトデータが格納された[LocalFile]。
  final LocalFile? local;

  /// [RemoteFile], which contains the file path and byte data on the remote side.
  ///
  /// リモート側のファイルパスやバイトデータが格納された[RemoteFile]。
  final RemoteFile? remote;

  StorageValue _copyWith({
    LocalFile? local,
    RemoteFile? remote,
  }) {
    return StorageValue._(
      local: local ?? this.local,
      remote: remote ?? this.remote,
    );
  }

  @override
  int get hashCode => local.hashCode ^ remote.hashCode;
  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

/// Class for handling local files and real data.
///
/// ローカルのファイルと実データを扱うためのクラス。
@immutable
class LocalFile extends StorageFile {
  /// Class for handling local files and real data.
  ///
  /// ローカルのファイルと実データを扱うためのクラス。
  const LocalFile({super.path, super.bytes})
      : super._();
}

/// Class for handling remote files and real data.
///
/// リモートのファイルと実データを扱うためのクラス。
@immutable
class RemoteFile extends StorageFile {
  /// Class for handling remote files and real data.
  ///
  /// リモートのファイルと実データを扱うためのクラス。
  const RemoteFile({super.path, super.bytes})
      : super._();
}

/// Abstract class for defining files for storage.
///
/// The full path of the file is stored in [path] and the actual data in [bytes].
///
/// ストレージ用のファイルを定義するための抽象クラス。
///
/// [path]にファイルのフルパスが格納され、[bytes]に実データが格納されます。
@immutable
abstract class StorageFile {
  const StorageFile._({
    this.path,
    this.bytes,
  });

  /// The full path of the file is stored.
  ///
  /// ファイルのフルパスが格納されます。
  final Uri? path;

  /// Real data is stored.
  ///
  /// 実データが格納されます。
  final Uint8List? bytes;

  @override
  int get hashCode => path.hashCode ^ bytes.hashCode;
  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
