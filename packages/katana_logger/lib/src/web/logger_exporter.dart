part of "web.dart";

/// Import and export [DynamicMap] data used in [LoggerDatabase] to external files.
///
/// For types that cannot be serialized (e.g., objects), filtering is used to exclude them.
///
/// For Web, output to `LocalStorage`.
///
/// [LoggerDatabase]で利用されている[DynamicMap]のデータを外部ファイルに対してインポート・エクスポートを行ないます。
///
/// シリアライズできない型（オブジェクトなど）に関しては、フィルタリングで除外します。
///
/// Webの場合は`LocalStorage`に出力します。
class LoggerExporter {
  LoggerExporter._();

  static Completer<void>? _completer;

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
  static Future<void> export(
    String fileName,
    Map<String, DynamicMap> data,
  ) async {
    if (_completer != null) {
      return _completer?.future;
    }
    _completer = Completer();
    try {
      WidgetsBinding.instance.scheduleFrameCallback((_) async {
        try {
          final sharedPreference = SharedPreferencesAsync();
          final json = jsonEncode(_unsupportedObjectFilter(data)).toAES(
            fileName.last().toSHA1(),
          );
          await sharedPreference.setString(fileName.toSHA1(), json);
          _completer?.complete();
          _completer = null;
        } catch (e) {
          _completer?.completeError(e);
          _completer = null;
        } finally {
          _completer?.complete();
          _completer = null;
        }
      });
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
  static Future<Map<String, DynamicMap>> import(String fileName) async {
    final sharedPreference = SharedPreferencesAsync();
    final json = await sharedPreference.getString(fileName.toSHA1()) ?? "";
    return jsonDecodeAsMap(json.fromAES(fileName.last().toSHA1()), {});
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
    return null;
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
