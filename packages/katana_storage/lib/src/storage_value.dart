part of "/katana_storage.dart";

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
  const LocalFile({super.path, super.bytes, super.mimeType}) : super._();
}

/// Class for handling remote files and real data.
///
/// リモートのファイルと実データを扱うためのクラス。
@immutable
class RemoteFile extends StorageFile {
  /// Class for handling remote files and real data.
  ///
  /// リモートのファイルと実データを扱うためのクラス。
  const RemoteFile({super.path, super.bytes, super.mimeType}) : super._();
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
    String? mimeType,
  }) : _mimeType = mimeType;

  /// The full path of the file is stored.
  ///
  /// ファイルのフルパスが格納されます。
  final Uri? path;

  /// Real data is stored.
  ///
  /// 実データが格納されます。
  final Uint8List? bytes;

  /// If the MimeType is known, its value is entered.
  ///
  /// MimeTypeが分かる場合その値が入ります。
  MimeTypeValue? get mimeType {
    if (_mimeType != null) {
      return MimeTypeValue(_mimeType!);
    }
    final filename = path?.path.last();
    if (filename == null) {
      return null;
    }
    final mimeType = lookupMimeType(filename);
    if (mimeType == null) {
      return null;
    }
    return MimeTypeValue(mimeType);
  }

  final String? _mimeType;

  @override
  int get hashCode => path.hashCode ^ bytes.hashCode;
  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

/// Class that defines the MimeType.
///
/// MimeTypeを定義したクラス。
@immutable
class MimeTypeValue {
  /// Class that defines the MimeType.
  ///
  /// MimeTypeを定義したクラス。
  const MimeTypeValue(this.value);

  /// Gets the value of a MimeType string.
  ///
  /// MimeTypeの文字列の値を取得します。
  final String value;

  /// Gets the MimeType extension.
  ///
  /// MimeTypeの拡張子を取得します。
  // ignore: dead_null_aware_expression
  String get extension => extensionFromMime(value) ?? "";

  @override
  int get hashCode => value.hashCode;
  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
