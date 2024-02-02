part of '/masamune_ai_openai.dart';

const _fileStorageAdapter = OpenAIStorageAdapter(
  purpose: OpenAIFilePurpose.assistants,
);

/// Controller for uploading & downloading local files to the OpenAI side.
///
/// Specify [storageQuery] when downloading or deleting files.
/// (Not required when uploading files.)
///
/// ローカルのファイルをOpenAI側にアップロード＆ダウンロードするためのコントローラー。
///
/// ファイルをダウンロードもしくは削除する際は[storageQuery]を指定してください。
/// （ファイルアップロード時は必要ありません。）
class OpenAIFileStorage
    extends MasamuneControllerBase<OpenAIFile, OpenAIMasamuneAdapter> {
  /// Controller for uploading & downloading local files to the OpenAI side.
  ///
  /// Specify [storageQuery] when downloading or deleting files.
  /// (Not required when uploading files.)
  ///
  /// ローカルのファイルをOpenAI側にアップロード＆ダウンロードするためのコントローラー。
  ///
  /// ファイルをダウンロードもしくは削除する際は[storageQuery]を指定してください。
  /// （ファイルアップロード時は必要ありません。）
  OpenAIFileStorage({this.storageQuery, super.adapter});

  @override
  OpenAIMasamuneAdapter get primaryAdapter => OpenAIMasamuneAdapter.primary;

  /// Information about the target files on the storage side is defined.
  ///
  /// ストレージ側の対象となるファイルの情報が定義されます。
  final OpenAIFileStorageQuery? storageQuery;

  @override
  OpenAIFile? get value => _value;
  OpenAIFile? _value;

  /// If a file is being downloaded, you can wait.
  ///
  /// The full path of the cache to download can be obtained as a return value.
  ///
  /// ファイルをダウンロード中の場合待つことができます。
  ///
  /// 戻り値としてダウンロード先のキャッシュのフルパスを取得することが出来ます。
  Future<void>? get downloading => _downloadCompleter?.future;
  Completer<void>? _downloadCompleter;

  /// You can wait for the file to be uploaded.
  ///
  /// The full path to the upload destination can be obtained as a return value.
  ///
  /// ファイルのアップロードを待つことができます。
  ///
  /// 戻り値としてアップロード先のフルパスを取得することが出来ます。
  Future<void>? get uploading => _uploadCompleter?.future;
  Completer<void>? _uploadCompleter;

  /// You can wait for the file to be deleted.
  ///
  /// ファイルの削除を待つことができます。
  Future<void>? get deleting => _deleteCompleter?.future;
  Completer<void>? _deleteCompleter;

  /// Download the file on the remote side specified by [storageQuery] to [localRelativePath] on the local side.
  ///
  /// If [storageQuery] is [Null], an exception is raised.
  ///
  /// The return value is an [OpenAIFile] containing the full path to the cache where the file was downloaded.
  ///
  /// [storageQuery]で指定されたリモート側のファイルをローカル上の[localRelativePath]にダウンロードします。
  ///
  /// [storageQuery]が[Null]の場合は例外が発生します。
  ///
  /// ダウンロード中は[downloading]で待つことができます。
  ///
  /// 戻り値としてダウンロード先のキャッシュのフルパスを含んだ[OpenAIFile]を取得することが出来ます。
  Future<OpenAIFile?> download([String? localRelativePath]) async {
    if (_downloadCompleter != null) {
      await downloading;
      return _value;
    }
    if (storageQuery == null) {
      throw Exception("StorageQuery is not defined.");
    }
    _downloadCompleter = Completer();
    try {
      final remoteId =
          storageQuery!.relativeRemotePathOrId.trimQuery().trimStringRight("/");
      final localFile = await storageQuery!.adapter.download(
        remoteId,
        localRelativePath?.trimQuery().trimStringRight("/"),
      );
      _value = OpenAIFile(
        id: remoteId,
        localFile: localFile,
      );
      notifyListeners();
      _downloadCompleter?.complete();
      _downloadCompleter = null;
      return _value;
    } catch (e) {
      _downloadCompleter?.completeError(e);
      _downloadCompleter = null;
      rethrow;
    } finally {
      _downloadCompleter?.complete();
      _downloadCompleter = null;
    }
  }

  /// Upload files in [localFullPath] locally to the OpenAI side.
  ///
  /// While uploading, you can wait at [uploading].
  ///
  /// You can get an [OpenAIFile] containing the uploaded file ID as the return value.
  ///
  /// ローカル上の[localFullPath]にあるファイルをOpenAI側にアップロードします。
  ///
  /// アップロード中は[uploading]で待つことができます。
  ///
  /// 戻り値としてアップロードしたファイルIDを含む[OpenAIFile]を取得することが出来ます。
  Future<OpenAIFile?> upload(String localFullPath) async {
    if (_uploadCompleter != null) {
      await uploading;
      return value;
    }
    _uploadCompleter = Completer();
    try {
      final adapter = storageQuery?.adapter ?? _fileStorageAdapter;
      final remoteFile = await adapter.upload(
        localFullPath.trimQuery().trimStringRight("/"),
        "",
      );
      _value = OpenAIFile(
        id: remoteFile.path?.path ?? "",
      );
      notifyListeners();
      _uploadCompleter?.complete();
      _uploadCompleter = null;
      return _value;
    } catch (e) {
      _uploadCompleter?.completeError(e);
      _uploadCompleter = null;
      rethrow;
    } finally {
      _uploadCompleter?.complete();
      _uploadCompleter = null;
    }
  }

  /// Deletes the file on the remote side specified by [storageQuery].
  ///
  /// If [storageQuery] is [Null], an exception is raised.
  ///
  /// You can wait in [deleting] while it is being deleted.
  ///
  /// [storageQuery]で指定されたリモート側のファイルを削除します。
  ///
  /// [storageQuery]が[Null]の場合は例外が発生します。
  ///
  /// 削除中は[deleting]で待つことができます。
  Future<void> delete() async {
    if (_deleteCompleter != null) {
      await deleting;
      return;
    }
    if (storageQuery == null) {
      throw Exception("StorageQuery is not defined.");
    }
    _deleteCompleter = Completer();
    try {
      await storageQuery!.adapter.delete(
        storageQuery!.relativeRemotePathOrId.trimQuery().trimStringRight("/"),
      );
      _value = null;
      notifyListeners();
      _deleteCompleter?.complete();
      _deleteCompleter = null;
    } catch (e) {
      _deleteCompleter?.completeError(e);
      _deleteCompleter = null;
      rethrow;
    } finally {
      _deleteCompleter?.complete();
      _deleteCompleter = null;
    }
  }
}

/// Query to specify the file ID on the OpenAI side.
///
/// Specify the file ID on the OpenAI side in [relativeRemotePathOrId].
///
/// OpenAI側のファイルIDを指定するためのクエリ。
///
/// [relativeRemotePathOrId]でOpenAI側のファイルIDを指定します。
class OpenAIFileStorageQuery extends StorageQuery {
  const OpenAIFileStorageQuery(super.fileId)
      : super(
          adapter: _fileStorageAdapter,
        );
}

/// Class in which data related to the actual data of the file obtained from OpenAI is stored.
///
/// Specify the file ID in [id].
///
/// When retrieved from [OpenAIFileStorage.download], the full path or byte data of the file is stored in [localFile].
///
/// OpenAIから取得したファイルの実データ関連のデータが格納されているクラス。
///
/// [id]にファイルIDを指定します。
///
/// [OpenAIFileStorage.download]から取得した場合、[localFile]にファイルのフルパスもしくはバイトデータが格納されています。
class OpenAIFile {
  const OpenAIFile({
    required this.id,
    this.localFile,
  });

  Map<String, String> get _header {
    return {
      "Authorization": "Bearer ${OpenAIMasamuneAdapter.primary.apiKey}",
    };
  }

  /// Convert to [TextProvider].
  ///
  /// [TextProvider]に変換します。
  TextProvider? toTextProvider() {
    return Asset.text(
      "https://api.openai.com/v1/files/$id/content",
      headers: _header,
    );
  }

  /// Convert to [ImageProvider].
  ///
  /// [ImageProvider]に変換します。
  ImageProvider? toImageProvider() {
    return Asset.image(
      "https://api.openai.com/v1/files/$id/content",
      headers: _header,
    );
  }

  /// File ID.
  ///
  /// ファイルID。
  final String id;

  /// Local file information.
  ///
  /// When retrieved from [OpenAIFileStorage.download], the full path or byte data of the file is stored in [localFile].
  ///
  /// ローカルファイル情報。
  ///
  /// [OpenAIFileStorage.download]から取得した場合、[localFile]にファイルのフルパスもしくはバイトデータが格納されています。
  final LocalFile? localFile;
}

/// Intended use of the file.
///
/// ファイルの利用目的。
enum OpenAIFilePurpose {
  /// For fine-tune.
  ///
  /// ファインチューニング用。
  fineTune,

  /// For assistant.
  ///
  /// アシスタント用。
  assistants;

  /// ID for the purpose of use.
  ///
  /// 利用目的のID。
  String get id {
    switch (this) {
      case OpenAIFilePurpose.fineTune:
        return "fine-tune";
      case OpenAIFilePurpose.assistants:
        return "assistants";
    }
  }
}
