part of '/masamune_builder.dart';

/// Class for storing annotation values in [GoogleSpreadSheetDataSource].
///
/// Specify the class element in [element] and the annotation type in [annotationType].
///
/// [GoogleSpreadSheetDataSource]のアノテーションの値を保存するためのクラス。
///
/// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
class GoogleSpreadSheetValue {
  /// Class for storing annotation values in [GoogleSpreadSheetDataSource].
  ///
  /// Specify the class element in [element] and the annotation type in [annotationType].
  ///
  /// [GoogleSpreadSheetDataSource]のアノテーションの値を保存するためのクラス。
  ///
  /// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
  GoogleSpreadSheetValue(this.element, this.annotationType) {
    const matcher = TypeChecker.fromRuntime(GoogleSpreadSheetDataSource);

    for (final meta in element.metadata) {
      final obj = meta.computeConstantValue()!;
      if (matcher.isExactlyType(obj.type!)) {
        _source = obj.getField("source")?.toStringValue();
        idKey = obj.getField("idKey")?.toStringValue();
        direct = obj.getField("direct")?.toBoolValue() ?? false;
        version = obj.getField("version")?.toIntValue() ?? 1;
        offsetX = obj.getField("offsetX")?.toIntValue() ?? 0;
        offsetY = obj.getField("offsetY")?.toIntValue() ?? 0;

        final directionMatch = _directionRegExp.firstMatch(meta.toSource());
        if (directionMatch != null) {
          direction =
              directionMatch.group(1)?.trim().trimString("'").trimString('"');
        } else {
          direction = null;
        }
        return;
      }
    }
    _source = null;
    version = 1;
    direction = null;
    direct = false;
    offsetX = 0;
    offsetY = 0;
  }

  static final _directionRegExp =
      RegExp("direction\\s*:\\s*([a-zA-Z0-9\$._'\"-]+)");

  /// Class Element.
  ///
  /// クラスエレメント。
  final ClassElement element;

  /// Annotation Type
  ///
  /// アノテーションのタイプ
  final Type annotationType;

  /// CSV Source.
  ///
  /// CSVソース。
  String? get source => _source;
  String? _source;

  /// Key for ID.
  ///
  /// ID用のキー。
  late final String? idKey;

  /// Download version.
  ///
  /// ダウンロードバージョン。
  late final int version;

  /// Setting the reading orientation.
  ///
  /// 読み込みの向きの設定。
  late final String? direction;

  /// Setting whether or not to download directly from the URL.
  ///
  /// 直接URLからダウンロードするかどうかの設定。
  late final bool direct;

  /// Offset for XY axis.
  ///
  /// XY軸のオフセット。
  late final int offsetX;

  /// Offset for Y axis.
  ///
  /// Y軸のオフセット。
  late final int offsetY;

  @override
  String toString() {
    return "$runtimeType()";
  }

  /// Output code.
  ///
  /// コードを出力します。
  String toCode() {
    if (annotationType == CollectionModelPath) {
      return "CsvCollectionSourceModelAdapter( source: r'''$source''', idKey: \"$idKey\", )";
    } else {
      switch (direction) {
        case "GoogleSpreadSheetDataSourceDirection.vertical":
          return "CsvDocumentSourceModelAdapter( source: r'''$source''', direction: Axis.vertical, offset: Offset($offsetX, $offsetY) )";
        default:
          return "CsvDocumentSourceModelAdapter( source: r'''$source''', direction: Axis.horizontal )";
      }
    }
  }

  /// Loads the file.
  ///
  /// ロードを行ないます。
  Future<void> load() async {
    if (_source.isEmpty) {
      return;
    }
    if (!_source!.startsWith("http")) {
      return;
    }
    final dir = Directory(".dart_tool/katana");
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    String? gid = "0";
    final spreadSheetId = RegExp(r"docs.google.com/spreadsheets/d/([^/]+)/")
            .firstMatch(_source!)
            ?.group(1) ??
        "";
    final endpoint = _source!.replaceAllMapped(
        RegExp(r"/edit(\?([^#]+))?(#gid=([0-9]+))?$"), (match) {
      gid = match.group(4);
      if (gid.isEmpty) {
        return "/export?format=csv";
      }
      return "/export?format=csv&gid=$gid";
    });
    if (direct) {
      _source = endpoint;
      return;
    }
    Uint8List bytes;
    final file = File("${dir.path}/$spreadSheetId.$gid.$version.csv");
    if (file.existsSync()) {
      bytes = await file.readAsBytes();
    } else {
      // ignore: avoid_print
      print("Load from $endpoint");
      final res = await http.get(Uri.parse(endpoint));
      if (res.statusCode != 200) {
        throw InvalidGenerationSourceError(
          "$_source could not be accessed successfully, please check if the URL and share settings are correct.",
        );
      }
      final list = dir.listSync();
      for (final file in list) {
        if (!file.path.contains("${dir.path}/$spreadSheetId.$gid.")) {
          continue;
        }
        await file.delete();
      }
      bytes = res.bodyBytes;
      await File("${dir.path}/$spreadSheetId.$gid.$version.csv")
          .writeAsBytes(bytes);
    }

    _source = utf8.decode(bytes);
  }
}
