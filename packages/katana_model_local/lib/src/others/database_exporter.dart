part of "others.dart";

/// Import and export [DynamicMap] data used in [NoSqlDatabase] to external files.
///
/// For types that cannot be serialized (e.g., objects), filtering is used to exclude them.
///
/// For Web, output to `LocalStorage`.
///
/// [NoSqlDatabase]で利用されている[DynamicMap]のデータを外部ファイルに対してインポート・エクスポートを行ないます。
///
/// シリアライズできない型（オブジェクトなど）に関しては、フィルタリングで除外します。
///
/// Webの場合は`LocalStorage`に出力します。
class DatabaseExporter {
  DatabaseExporter._();

  static Completer<void>? _completer;

  static const _platformInfo = PlatformInfo();

  /// Export [data] against [fileName].
  ///
  /// For Web, output to `LocalStorage` with [fileName] as the key.
  ///
  /// Encryption based on [fileName].
  ///
  /// [data]を[fileName]に対してエクスポートします。
  ///
  /// Webの場合は[fileName]をキーにした状態でLocalStorage`に出力します。
  ///
  /// [fileName]に基づく暗号化を行ないます。
  static Future<void> export(String fileName, DynamicMap data) async {
    if (_completer != null) {
      return _completer?.future;
    }
    _completer = Completer();
    try {
      await Future.delayed(Duration.zero);
      try {
        await compute<_ComputeMessaging, void>(
          (message) async {
            final json =
                jsonEncode(_unsupportedObjectFilter(message.data)).toAES(
              message.fileName.last().toSHA1(),
            );
            await File(message.fileName).writeAsString(json);
          },
          _ComputeMessaging(fileName: fileName, data: data),
        );
        _completer?.complete();
        _completer = null;
      } catch (e) {
        _completer?.completeError(e);
        _completer = null;
      } finally {
        _completer?.complete();
        _completer = null;
      }
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
    }
  }

  /// Import the data stored in [fileName].
  ///
  /// For Web, retrieve from `LocalStorage` with [fileName] as a key.
  ///
  /// Decryption is performed based on [fileName]. If the [fileName] is different from the exported file name, the file cannot be imported.
  ///
  /// [fileName]に保存されているデータをインポートします。
  ///
  /// Webの場合は[fileName]をキーにした状態で`LocalStorage`から取得します。
  ///
  /// [fileName]に基づく復号化を行ないます。エクスポート時と[fileName]が異なる場合インポートできません。
  static Future<DynamicMap> import(String fileName) async {
    return await compute<String, DynamicMap>(
      (fileName) async {
        final file = File(fileName);
        if (!file.existsSync()) {
          throw Exception("This file [$fileName] is not found.");
        }
        final json = await file.readAsString();
        return jsonDecodeAsMap(json.fromAES(fileName.last().toSHA1()), {});
      },
      fileName,
    );
  }

  /// Obtains the document path where the file can be placed by determining the platform.
  ///
  /// Use [getLibraryDirectory] for `iOS` and [getApplicationDocumentsDirectory] for others.
  ///
  /// `Web` returns [Null].
  ///
  /// ファイルを置けるドキュメントパスをプラットフォームを判別して取得します。
  ///
  /// `iOS`は[getLibraryDirectory]、その他は[getApplicationDocumentsDirectory]を利用します。
  ///
  /// `Web`は[Null]を返します。
  static Future<String?> get documentDirectory async {
    if (Platform.isIOS) {
      return (await _platformInfo.getLibraryDirectory()).path;
    } else {
      return (await _platformInfo.getApplicationDocumentsDirectory()).path;
    }
  }

  static DynamicMap _unsupportedObjectFilter(DynamicMap data) {
    final filtered = <String, dynamic>{};
    for (final entry in data.entries) {
      var val = entry.value;
      if (val == null) {
        continue;
      }
      if (val is num && (val.isNaN || val.isInfinite)) {
        continue;
      }
      if (val is DynamicMap) {
        val = _unsupportedObjectFilter(val);
      }
      filtered[entry.key] = val;
    }
    return filtered;
  }
}

@immutable
class _ComputeMessaging {
  const _ComputeMessaging({required this.fileName, required this.data});
  final String fileName;
  final DynamicMap data;
}
