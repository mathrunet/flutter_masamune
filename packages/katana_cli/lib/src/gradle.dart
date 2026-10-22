// Dart imports:
import "dart:io";

// Package imports:
import "package:katana/katana.dart";

// Project imports:
import "package:katana_cli/config.dart";

/// Class for retrieving and saving files in `android/build.gradle`.
///
/// Only the values changed after [load] are written back by [save].
/// Any other content in the file, such as custom blocks, comments and
/// options that are not modeled by this class, is kept as it is.
///
/// `android/build.gradle`のファイルを取得して保存するためのクラス。
///
/// [save]では[load]後に変更された値だけを書き戻します。
/// このクラスで扱わない独自のブロックやコメント、オプションはそのまま残ります。
class AppGradle {
  /// Class for retrieving and saving files in `android/build.gradle`.
  ///
  /// `android/build.gradle`のファイルを取得して保存するためのクラス。
  AppGradle();

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  bool _isKotlin = false;

  /// Original text data.
  ///
  /// 元のテキストデータ。
  String get rawData => _rawData;
  late String _rawData;

  /// Data reading part of `xxx.properties`.
  ///
  /// `xxx.properties`のデータ読み込み部分。
  List<GradleLoadProperties> get loadProperties => _loadProperties;
  late List<GradleLoadProperties> _loadProperties;
  late List<String> _originalLoadProperties;

  /// List of `import`.
  ///
  /// `import`のリスト。
  List<GradleImport> get imports => _imports;
  late List<GradleImport> _imports;
  late List<String> _originalImports;

  /// List of `apply plugin`.
  ///
  /// `apply plugin`のリスト。
  List<GradlePlugin> get plugins => _plugins;
  late List<GradlePlugin> _plugins;
  late List<String> _originalPlugins;

  /// Data in the `android` section.
  ///
  /// `android`セクションのデータ。
  GradleAndroid? get android => _android;
  GradleAndroid? _android;

  /// Data in the `android` section.
  ///
  /// `dependencies`セクションのデータ。
  List<GradleDependencies> get dependencies => _dependencies;
  late List<GradleDependencies> _dependencies;
  late List<String> _originalDependencies;

  /// Data loading.
  ///
  /// データの読み込み。
  Future<void> load() async {
    if (File("android/app/build.gradle").existsSync()) {
      final gradle = File("android/app/build.gradle");
      _rawData = await gradle.readAsString();
    } else if (File("android/app/build.gradle.kts").existsSync()) {
      _isKotlin = true;
      final gradle = File("android/app/build.gradle.kts");
      _rawData = await gradle.readAsString();
    }
    _loadProperties = GradleLoadProperties._load(_rawData);
    _originalLoadProperties = _loadProperties.map((e) => e.name).toList();
    _imports = GradleImport._load(_rawData);
    _originalImports = _imports.map((e) => e.import).toList();
    _plugins = GradlePlugin._load(_rawData);
    _originalPlugins = _plugins.map((e) => e.plugin).toList();
    _android = GradleAndroid._load(_rawData);
    _dependencies = GradleDependencies._load(_rawData);
    _originalDependencies = _dependencies.map((e) => e._key).toList();
  }

  /// Data storage.
  ///
  /// データの保存。
  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    _rawData = GradleImport._save(_rawData, _imports, _originalImports);
    _rawData = GradlePlugin._save(_rawData, _plugins, _originalPlugins);
    _rawData = GradleLoadProperties._save(
      _rawData,
      _loadProperties,
      _originalLoadProperties,
    );
    if (_android != null) {
      _rawData = GradleAndroid._save(_rawData, _android!, isKotlin: _isKotlin);
    }
    _rawData = GradleDependencies._save(
      _rawData,
      _dependencies,
      _originalDependencies,
    );
    _originalLoadProperties = _loadProperties.map((e) => e.name).toList();
    _originalImports = _imports.map((e) => e.import).toList();
    _originalPlugins = _plugins.map((e) => e.plugin).toList();
    _originalDependencies = _dependencies.map((e) => e._key).toList();
    _android?._original = GradleAndroid._load(_rawData);
    if (File("android/app/build.gradle").existsSync()) {
      final gradle = File("android/app/build.gradle");
      await gradle.writeAsString(_rawData);
    } else if (File("android/app/build.gradle.kts").existsSync()) {
      final gradle = File("android/app/build.gradle.kts");
      await gradle.writeAsString(_rawData);
    }
  }
}

/// Range of a `name { ... }` block in a Gradle script.
class _GradleBlock {
  const _GradleBlock(this.start, this.open, this.close);

  /// Start of the line containing the block header.
  final int start;

  /// Index of the opening brace.
  final int open;

  /// Index of the closing brace.
  final int close;
}

/// Helpers for editing Gradle scripts without rebuilding them.
///
/// Braces inside strings and comments are ignored when blocks are located.
class _GradleText {
  /// Returns [source] with string literals and comments replaced by spaces.
  ///
  /// Line breaks are kept so that indices and lines match [source].
  static String mask(String source) {
    final codes = source.codeUnits.toList();
    void blank(int from, int to) {
      for (var i = from; i < to && i < codes.length; i++) {
        if (codes[i] != 0x0A) {
          codes[i] = 0x20;
        }
      }
    }

    var i = 0;
    while (i < source.length) {
      if (source.startsWith("//", i)) {
        final end = source.indexOf("\n", i);
        final to = end < 0 ? source.length : end;
        blank(i, to);
        i = to;
      } else if (source.startsWith("/*", i)) {
        final end = source.indexOf("*/", i + 2);
        final to = end < 0 ? source.length : end + 2;
        blank(i, to);
        i = to;
      } else if (source.startsWith('"""', i) || source.startsWith("'''", i)) {
        final end = source.indexOf(source.substring(i, i + 3), i + 3);
        final to = end < 0 ? source.length : end + 3;
        blank(i, to);
        i = to;
      } else if (source[i] == '"' || source[i] == "'") {
        final to = _endOfQuoted(source, i);
        blank(i, to);
        i = to;
      } else {
        i++;
      }
    }
    return String.fromCharCodes(codes);
  }

  static int _endOfQuoted(String source, int start) {
    final quote = source[start];
    var i = start + 1;
    while (i < source.length) {
      final char = source[i];
      if (char == r"\") {
        i += 2;
      } else if (char == quote) {
        return i + 1;
      } else if (char == "\n") {
        return i;
      } else if (char == r"$" && source.startsWith("{", i + 1)) {
        i = _endOfTemplate(source, i + 2);
      } else {
        i++;
      }
    }
    return source.length;
  }

  static int _endOfTemplate(String source, int start) {
    var depth = 1;
    var i = start;
    while (i < source.length) {
      final char = source[i];
      if (char == '"' || char == "'") {
        i = _endOfQuoted(source, i);
        continue;
      }
      if (char == "{") {
        depth++;
      } else if (char == "}") {
        depth--;
        if (depth == 0) {
          return i + 1;
        }
      }
      i++;
    }
    return source.length;
  }

  static int? _matchingBrace(String masked, int open) {
    var depth = 0;
    for (var i = open; i < masked.length; i++) {
      final char = masked[i];
      if (char == "{") {
        depth++;
      } else if (char == "}") {
        depth--;
        if (depth == 0) {
          return i;
        }
      }
    }
    return null;
  }

  /// Returns the start indices of lines located directly in `[from, to)`.
  static Iterable<int> _lineStarts(String masked, int from, int to) sync* {
    var depth = 0;
    var lineStart = true;
    for (var i = from; i < to; i++) {
      if (lineStart && depth == 0) {
        yield i;
      }
      final char = masked[i];
      if (char == "{") {
        depth++;
      } else if (char == "}") {
        depth--;
      }
      lineStart = char == "\n";
    }
  }

  static bool _isCode(String source, String masked, int start, int end) {
    for (var i = start; i < end; i++) {
      if (source[i] != " " && source[i] != "\t") {
        return masked[i] == source[i];
      }
    }
    return false;
  }

  /// Finds a block whose header matches [head] directly in `[from, to)`.
  static _GradleBlock? find(
    String source,
    String head, {
    int from = 0,
    int? to,
    String? masked,
  }) {
    masked ??= mask(source);
    final limit = to ?? source.length;
    final pattern = RegExp("[ \\t]*(?:$head)[ \\t]*\\{");
    for (final start in _lineStarts(masked, from, limit)) {
      final match = pattern.matchAsPrefix(source, start);
      if (match == null ||
          masked[match.end - 1] != "{" ||
          !_isCode(source, masked, start, match.end)) {
        continue;
      }
      final close = _matchingBrace(masked, match.end - 1);
      if (close != null && close < limit) {
        return _GradleBlock(start, match.end - 1, close);
      }
    }
    return null;
  }

  /// Finds nested blocks along [path] from the top level.
  static _GradleBlock? path(String source, List<String> path) {
    final masked = mask(source);
    _GradleBlock? block;
    for (final head in path) {
      block = find(
        source,
        head,
        from: block == null ? 0 : block.open + 1,
        to: block?.close,
        masked: masked,
      );
      if (block == null) {
        return null;
      }
    }
    return block;
  }

  /// Returns the body of the block at [path].
  static String body(String source, List<String> path) {
    final block = _GradleText.path(source, path);
    if (block == null) {
      return "";
    }
    return source.substring(block.open + 1, block.close);
  }

  static Match? _property(
    String source,
    _GradleBlock block,
    List<String> keys,
  ) {
    final masked = mask(source);
    final pattern = RegExp(
      "([ \\t]*)(${keys.map(RegExp.escape).join("|")})([ \\t]*=[ \\t]*|[ \\t]+)(.*)",
    );
    for (final start in _lineStarts(masked, block.open + 1, block.close)) {
      final match = pattern.matchAsPrefix(source, start);
      if (match == null ||
          match.end > block.close ||
          !_isCode(source, masked, start, match.end) ||
          (match.group(4) ?? "").trim().isEmpty ||
          (match.group(4) ?? "").trimLeft().startsWith("{")) {
        continue;
      }
      return match;
    }
    return null;
  }

  /// Returns the value of the first of [keys] in the block at [path].
  static String? value(String source, List<String> path, List<String> keys) {
    final block = _GradleText.path(source, path);
    if (block == null) {
      return null;
    }
    return _property(source, block, keys)?.group(4)?.trim();
  }

  /// Returns the lines located directly in the block at [path].
  static List<String> lines(String source, List<String> path) {
    final block = _GradleText.path(source, path);
    if (block == null) {
      return [];
    }
    final masked = mask(source);
    return _lineStarts(masked, block.open + 1, block.close).map((start) {
      final end = source.indexOf("\n", start);
      return source.substring(
        start,
        end < 0 || end > block.close ? block.close : end,
      );
    }).toList();
  }

  static String _indent(String source, _GradleBlock block) {
    final header = source.substring(block.start, block.open);
    return "${RegExp(r"^[ \t]*").firstMatch(header)?.group(0) ?? ""}    ";
  }

  /// Sets [value] to the first of [keys] in the block at [path].
  ///
  /// When no key exists, `keys.first = value` is added to the block.
  static String setValue(
    String source,
    List<String> path,
    List<String> keys,
    String value, {
    bool atStart = false,
  }) {
    final block = _GradleText.path(source, path);
    if (block == null) {
      return source;
    }
    final match = _property(source, block, keys);
    if (match != null) {
      return source.replaceRange(
        match.start,
        match.end,
        "${match.group(1)}${match.group(2)}${match.group(3)}$value",
      );
    }
    return addLines(source, path, ["${keys.first} = $value"], atStart: atStart);
  }

  /// Adds [lines] to the block at [path] with its indentation.
  static String addLines(
    String source,
    List<String> path,
    List<String> lines, {
    bool atStart = false,
  }) {
    final block = _GradleText.path(source, path);
    if (block == null || lines.isEmpty) {
      return source;
    }
    final indent = _indent(source, block);
    final code = lines.map((e) => "$indent$e\n").join();
    if (atStart) {
      final lineEnd = source.indexOf("\n", block.open);
      if (lineEnd >= 0 &&
          lineEnd < block.close &&
          source.substring(block.open + 1, lineEnd).trim().isEmpty) {
        return source.replaceRange(lineEnd + 1, lineEnd + 1, code);
      }
    }
    final closeLineStart = source.lastIndexOf("\n", block.close - 1) + 1;
    if (closeLineStart > block.open &&
        source.substring(closeLineStart, block.close).trim().isEmpty) {
      return source.replaceRange(closeLineStart, closeLineStart, code);
    }
    final closeIndent = indent.substring(0, indent.length - 4);
    return source.replaceRange(block.close, block.close, "\n$code$closeIndent");
  }

  /// Removes the lines in the block at [path] that satisfy [test].
  static String removeLines(
    String source,
    List<String> path,
    bool Function(String line) test,
  ) {
    final block = _GradleText.path(source, path);
    if (block == null) {
      return source;
    }
    final masked = mask(source);
    final starts = _lineStarts(masked, block.open + 1, block.close).toList();
    for (final start in starts.reversed) {
      final end = source.indexOf("\n", start);
      if (end < 0 || end >= block.close) {
        continue;
      }
      if (test(source.substring(start, end).trim())) {
        source = source.replaceRange(start, end + 1, "");
      }
    }
    return source;
  }

  /// Creates an empty block [header] in the block at [parent] when missing.
  ///
  /// The block is placed before the first block in [before] that exists,
  /// otherwise at the end of [parent].
  static String ensureBlock(
    String source,
    List<String> parent,
    String head,
    String header, {
    List<String> before = const [],
  }) {
    if (path(source, [...parent, head]) != null) {
      return source;
    }
    final parentBlock = path(source, parent);
    if (parentBlock == null) {
      return source;
    }
    final indent = _indent(source, parentBlock);
    for (final next in before) {
      final nextBlock = path(source, [...parent, next]);
      if (nextBlock != null) {
        return source.replaceRange(
          nextBlock.start,
          nextBlock.start,
          "$indent$header {\n$indent}\n\n",
        );
      }
    }
    final block = "$indent$header {\n$indent}\n";
    final closeLineStart = source.lastIndexOf("\n", parentBlock.close - 1) + 1;
    if (closeLineStart <= parentBlock.open ||
        source.substring(closeLineStart, parentBlock.close).trim().isNotEmpty) {
      return source.replaceRange(
        parentBlock.close,
        parentBlock.close,
        "\n$block${indent.substring(0, indent.length - 4)}",
      );
    }
    // 中身がある場合は空行で区切る。
    final body = source.substring(parentBlock.open + 1, closeLineStart);
    final separator = body.trim().isEmpty || body.endsWith("\n\n") ? "" : "\n";
    return source.replaceRange(
      closeLineStart,
      closeLineStart,
      "$separator$block",
    );
  }

  /// Replaces the whole block at [path] with [code].
  ///
  /// When [code] is empty, the block is removed.
  static String replaceBlock(String source, List<String> path, String code) {
    final block = _GradleText.path(source, path);
    if (block == null) {
      return source;
    }
    final lineEnd = source.indexOf("\n", block.close);
    final end = lineEnd < 0 ? source.length : lineEnd + 1;
    return source.replaceRange(block.start, end, code);
  }

  /// Returns the end index of the top-level block that follows [from].
  static int? nextTopLevelBlockEnd(String source, int from) {
    final masked = mask(source);
    final open = masked.indexOf("{", from);
    if (open < 0) {
      return null;
    }
    final close = _matchingBrace(masked, open);
    return close == null ? null : close + 1;
  }
}

/// Data reading part of `xxx.properties`.
///
/// `xxx.properties`のデータ読み込み部分。
class GradleLoadProperties {
  /// Data reading part of `xxx.properties`.
  ///
  /// `xxx.properties`のデータ読み込み部分。
  factory GradleLoadProperties({
    required String path,
    required String name,
    required String file,
    bool isKotlin = false,
  }) {
    return GradleLoadProperties._(
      name: name,
      path: path,
      file: file,
      isKotlin: isKotlin,
    );
  }
  GradleLoadProperties._({
    required this.name,
    required this.file,
    required this.path,
    required this.isKotlin,
  });

  static List<GradleLoadProperties> _load(String content) {
    // 旧バージョン
    if (content.contains("def localProperties = new Properties()")) {
      final region = RegExp(
        r"^([\s\S]*?)def localProperties = new Properties\(\)",
      ).firstMatch(content);
      if (region == null) {
        return [];
      }
      return RegExp(
        r"def (?<name>[a-zA-Z_-]+) = new Properties\(\)([\s\S]*?)def (?<file>[a-zA-Z_-]+) = rootProject.file\('(?<path>[a-zA-Z./_-]+)'\)([\s\S]*?)if \(([a-zA-Z_-]+).exists\(\)\) {([\s\S]*?)([a-zA-Z_-]+).withReader\('UTF-8'\) { reader ->([\s\S]*?)([a-zA-Z_-]+).load\(reader\)([\s\S]*?)}([\s\S]*?)}",
      ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
        return GradleLoadProperties._(
          file: e.namedGroup("file") ?? "",
          name: e.namedGroup("name") ?? "",
          path: e.namedGroup("path") ?? "",
          isKotlin: false,
        );
      });
      // 新バージョン
    } else {
      final region = RegExp(
        r"(?<plugins>plugins[^{]*?\{[\s\S]*?\})?([\s\S]*?)android \{",
      ).firstMatch(content);
      if (region == null) {
        return [];
      }
      // KTSバージョン
      if (content.contains("= Properties()")) {
        return RegExp(
          r'val (?<name>[a-zA-Z_-]+) = Properties\(\)([\s\S]*?)rootProject.file\("(?<path>[a-zA-Z./_-]+)"\).let([\s\S]*?){([\s\S]*?)(?<file>[a-zA-Z_-]+)([\s\S]*?)->([\s\S]*?)if([\s\S]*?)\(([a-zA-Z_-]+).exists\(\)\)([\s\S]*?){([\s\S]*?)([a-zA-Z_-]+).inputStream\(\).use([\s\S]*?){([\s\S]*?)stream([\s\S]*?)->([\s\S]*?)([a-zA-Z_-]+).load\(stream\)([\s\S]*?)}([\s\S]*?)}([\s\S]*?)}',
        ).allMatches(region.group(2) ?? "").mapAndRemoveEmpty((e) {
          return GradleLoadProperties._(
            file: e.namedGroup("file") ?? "",
            name: e.namedGroup("name") ?? "",
            path: e.namedGroup("path") ?? "",
            isKotlin: true,
          );
        });
      } else {
        return RegExp(
          r"def (?<name>[a-zA-Z_-]+) = new Properties\(\)([\s\S]*?)def (?<file>[a-zA-Z_-]+) = rootProject.file\('(?<path>[a-zA-Z./_-]+)'\)([\s\S]*?)if \(([a-zA-Z_-]+).exists\(\)\) {([\s\S]*?)([a-zA-Z_-]+).withReader\('UTF-8'\) { reader ->([\s\S]*?)([a-zA-Z_-]+).load\(reader\)([\s\S]*?)}([\s\S]*?)}",
        ).allMatches(region.group(2) ?? "").mapAndRemoveEmpty((e) {
          return GradleLoadProperties._(
            file: e.namedGroup("file") ?? "",
            name: e.namedGroup("name") ?? "",
            path: e.namedGroup("path") ?? "",
            isKotlin: false,
          );
        });
      }
    }
  }

  static String _save(
    String content,
    List<GradleLoadProperties> list,
    List<String> original,
  ) {
    final added = list.where((e) => !original.contains(e.name)).toList();
    if (added.isEmpty) {
      return content;
    }
    final code = added.map((e) => e.toString()).join("\n");
    // 既存の読み込み処理の直後に追加し、それ以外の記述には触れない。
    int? end;
    for (final name in original) {
      final declaration = RegExp(
        "^[ \\t]*(?:val|def) ${RegExp.escape(name)} = (?:new )?Properties\\(\\)",
        multiLine: true,
      ).firstMatch(content);
      if (declaration == null) {
        continue;
      }
      final blockEnd = _GradleText.nextTopLevelBlockEnd(
        content,
        declaration.end,
      );
      if (blockEnd != null && (end == null || blockEnd > end)) {
        end = blockEnd;
      }
    }
    if (end != null) {
      return content.replaceRange(end, end, "\n$code");
    }
    final plugins = _GradleText.find(content, r"plugins");
    if (plugins != null) {
      return content.replaceRange(
        plugins.close + 1,
        plugins.close + 1,
        "\n\n$code",
      );
    }
    final android = _GradleText.find(content, r"android");
    if (android != null) {
      return content.replaceRange(android.start, android.start, "$code\n\n");
    }
    return "$code\n\n$content";
  }

  /// Variable name of the property file.
  ///
  /// プロパティファイルの変数名。
  final String name;

  /// Property file name.
  ///
  /// プロパティファイル名。
  final String file;

  /// Path of the property file.
  ///
  /// プロパティファイルのパス。
  final String path;

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  final bool isKotlin;

  @override
  String toString() {
    if (isKotlin) {
      return "val $name = Properties()\nrootProject.file(\"$path\").let { $file ->\n    if ($file.exists()) {\n        $file.inputStream().use { stream ->\n            $name.load(stream)\n        }\n    }\n}";
    } else {
      return "def $name = new Properties()\ndef $file = rootProject.file('$path')\nif ($file.exists()) {\n    $file.withReader('UTF-8') { reader ->\n        $name.load(reader)\n    }\n}";
    }
  }
}

/// Data in the `import` section.
///
/// `import`セクションのデータ。
class GradleImport {
  /// Data in the `import` section.
  ///
  /// `import`セクションのデータ。
  GradleImport({required this.import});

  static final _lineRegExp = RegExp(
    r"^[ \t]*import[ \t]+([a-zA-Z0-9_.*-]+)[ \t]*$",
    multiLine: true,
  );

  static List<GradleImport> _load(String content) {
    final plugins = _GradleText.find(content, r"plugins");
    final region = content.substring(0, plugins?.start ?? content.length);
    return RegExp(
      r"import (?<import>[a-zA-Z0-9_.-]+)",
    ).allMatches(region).mapAndRemoveEmpty((e) {
      return GradleImport(import: e.namedGroup("import") ?? "");
    });
  }

  static String _save(
    String content,
    List<GradleImport> list,
    List<String> original,
  ) {
    final imports = list.map((e) => e.import).toList();
    for (final removed in original.where((e) => !imports.contains(e))) {
      content = content.replaceAll(
        RegExp(
          "^[ \\t]*import[ \\t]+${RegExp.escape(removed)}[ \\t]*\\n",
          multiLine: true,
        ),
        "",
      );
    }
    final added = list.where((e) => !original.contains(e.import)).toList();
    if (added.isEmpty) {
      return content;
    }
    final code = added.map((e) => "${e.toString()}\n").join();
    final plugins = _GradleText.find(content, r"plugins");
    final last = _lineRegExp
        .allMatches(content)
        .where((e) => plugins == null || e.start < plugins.start)
        .lastOrNull;
    if (last != null) {
      final end = last.end < content.length ? last.end + 1 : last.end;
      return content.replaceRange(end, end, code);
    }
    return "$code\n$content";
  }

  /// Plugin Name.
  ///
  /// プラグインの名前。
  String import;

  @override
  String toString() {
    return "import $import";
  }
}

/// Data in the `apply plugin` section.
///
/// `apply plugin`セクションのデータ。
class GradlePlugin {
  /// Data in the `apply plugin` section.
  ///
  /// `apply plugin`セクションのデータ。
  GradlePlugin({required this.plugin, bool isKotlin = false})
      : _isKotlin = isKotlin;

  static List<GradlePlugin> _load(String content) {
    final plugins = _GradleText.find(content, r"plugins");
    if (plugins != null) {
      return RegExp("id[^(]*?\\(('|\")(?<plugin>[a-zA-Z0-9_.-]+)('|\")\\)")
          .allMatches(content.substring(plugins.open + 1, plugins.close))
          .mapAndRemoveEmpty((e) {
        return GradlePlugin(
          plugin: e.namedGroup("plugin") ?? "",
          isKotlin: e.group(0)?.contains("id(") ?? false,
        );
      });
    }
    final region = RegExp(
      r"apply plugin: 'kotlin-android'([\s\S]*?)apply from:",
    ).firstMatch(content);
    if (region != null) {
      return RegExp(
        r"apply plugin: '(?<plugin>[a-zA-Z0-9_.-]+)'",
      ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
        return GradlePlugin(
          plugin: e.namedGroup("plugin") ?? "",
          isKotlin: e.group(0)?.contains("id(") ?? false,
        );
      });
    }
    return [];
  }

  static String _save(
    String content,
    List<GradlePlugin> list,
    List<String> original,
  ) {
    final names = list.map((e) => e.plugin).toList();
    final removed = original.where((e) => !names.contains(e)).toList();
    final added = list.where((e) => !original.contains(e.plugin)).toList();
    if (removed.isEmpty && added.isEmpty) {
      return content;
    }
    if (_GradleText.find(content, r"plugins") != null) {
      content = _GradleText.removeLines(
        content,
        [r"plugins"],
        (line) => removed.any(
          (e) =>
              line.startsWith("id") &&
              (line.contains('"$e"') || line.contains("'$e'")),
        ),
      );
      return _GradleText.addLines(
        content,
        [r"plugins"],
        added.map((e) {
          if (e.isKotlin) {
            return "id(\"${e.toString()}\")";
          } else {
            return "id \"${e.toString()}\"";
          }
        }).toList(),
      );
    }
    for (final plugin in removed) {
      content = content.replaceAll(
        RegExp(
          "^apply plugin: '${RegExp.escape(plugin)}'[ \\t]*\\n",
          multiLine: true,
        ),
        "",
      );
    }
    if (added.isEmpty) {
      return content;
    }
    final code = added.map((e) => "apply plugin: '${e.toString()}'\n").join();
    final anchor = RegExp(
      r"^apply plugin: 'kotlin-android'[ \t]*\n",
      multiLine: true,
    ).firstMatch(content);
    if (anchor == null) {
      return content;
    }
    return content.replaceRange(anchor.end, anchor.end, code);
  }

  /// Plugin Name.
  ///
  /// プラグインの名前。
  String plugin;

  /// Whether the plugin is written in Kotlin.
  ///
  /// プラグインがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  final bool _isKotlin;

  @override
  String toString() {
    return plugin;
  }
}

const _androidPath = [r"android"];
const _compileOptionsPath = [r"android", r"compileOptions"];
const _defaultConfigPath = [r"android", r"defaultConfig"];
const _buildFeaturesPath = [r"android", r"buildFeatures"];
const _sourceSetsPath = [r"android", r"sourceSets"];
const _signingConfigsPath = [r"android", r"signingConfigs"];
const _buildTypesPath = [r"android", r"buildTypes"];
const _releaseHead = r'release|getByName\("release"\)';
const _debugHead = r'debug|getByName\("debug"\)';

/// Data in the `android` section.
///
/// `android`セクションのデータ。
class GradleAndroid {
  /// Data in the `android` section.
  ///
  /// `android`セクションのデータ。
  GradleAndroid({
    required this.buildTypes,
    required this.compileOptions,
    required this.compileSdkVersion,
    required this.defaultConfig,
    required this.sourceSets,
    this.namespace,
    this.ndkVersion,
    this.buildToolsVersion,
    this.signingConfigs,
  });

  static GradleAndroid? _load(String content) {
    final data = _parse(content);
    data?._original = _parse(content);
    return data;
  }

  static GradleAndroid? _parse(String content) {
    if (_GradleText.path(content, _androidPath) == null) {
      return null;
    }
    String? value(List<String> keys) {
      return _GradleText.value(content, _androidPath, keys);
    }

    return GradleAndroid(
      namespace: value(["namespace"]),
      buildTypes: GradleAndroidBuildTypes._load(content),
      signingConfigs: GradleAndroidSigningConfigs._load(content),
      compileOptions: GradleAndroidCompileOptions._load(content),
      compileSdkVersion: value(["compileSdk", "compileSdkVersion"]) ?? "0",
      defaultConfig: GradleAndroidDefaultConfig._load(content),
      buildToolsVersion: value(["buildToolsVersion"]),
      ndkVersion: value(["ndkVersion"]),
      sourceSets: GradleAndroidSourceSet._load(content),
    );
  }

  static String _save(
    String content,
    GradleAndroid data, {
    required bool isKotlin,
  }) {
    final original = data._original;
    String set(String? value, String? before, List<String> keys) {
      if (value.isEmpty || value == before) {
        return content;
      }
      return _GradleText.setValue(
        content,
        _androidPath,
        keys,
        value!,
        atStart: true,
      );
    }

    content = set(data.namespace, original?.namespace, ["namespace"]);
    content = set(data.compileSdkVersion, original?.compileSdkVersion, [
      "compileSdk",
      "compileSdkVersion",
    ]);
    content = set(data.buildToolsVersion, original?.buildToolsVersion, [
      "buildToolsVersion",
    ]);
    content = set(data.ndkVersion, original?.ndkVersion, ["ndkVersion"]);
    content = GradleAndroidCompileOptions._save(
      content,
      data.compileOptions,
      original?.compileOptions,
      isKotlin: isKotlin,
    );
    content = GradleAndroidSourceSet._save(
      content,
      data.sourceSets,
      original?.sourceSets ?? const [],
    );
    content = GradleAndroidDefaultConfig._save(
      content,
      data.defaultConfig,
      original?.defaultConfig,
    );
    if (data.defaultConfig.resValues.isNotEmpty) {
      content = _GradleText.ensureBlock(
        content,
        _androidPath,
        r"buildFeatures",
        "buildFeatures",
        before: [r"sourceSets", r"defaultConfig"],
      );
      if (_GradleText.value(content, _buildFeaturesPath, ["resValues"]) !=
          "true") {
        content = _GradleText.setValue(
            content,
            _buildFeaturesPath,
            [
              "resValues",
            ],
            "true");
      }
    }
    content = GradleAndroidSigningConfigs._save(
      content,
      data.signingConfigs,
      original?.signingConfigs,
    );
    content = GradleAndroidBuildTypes._save(
      content,
      data.buildTypes,
      original?.buildTypes,
    );
    return content;
  }

  GradleAndroid? _original;

  /// Namespace.
  ///
  /// 名前空間。
  String? namespace;

  /// SDK version of the compilation.
  ///
  /// コンパイルのSDKバージョン。
  String compileSdkVersion;

  /// NDK Version.
  ///
  /// NDKのバージョン。
  String? ndkVersion;

  /// Build tool version.
  ///
  /// ビルドツールのバージョン。
  String? buildToolsVersion;

  /// Compile Option Setting.
  ///
  /// コンパイルオプション設定。
  GradleAndroidCompileOptions compileOptions;

  /// Source setting.
  ///
  /// ソースの設定。
  List<GradleAndroidSourceSet> sourceSets;

  /// Default settings.
  ///
  /// デフォルトの設定。
  GradleAndroidDefaultConfig defaultConfig;

  /// Build type setting.
  ///
  /// ビルドタイプの設定。
  GradleAndroidBuildTypes buildTypes;

  /// Signature settings.
  ///
  /// 署名の設定。
  GradleAndroidSigningConfigs? signingConfigs;

  @override
  String toString() {
    return "${namespace.isEmpty ? "" : "    namespace = $namespace\n"}    compileSdk = $compileSdkVersion\n${buildToolsVersion != null ? "    buildToolsVersion = $buildToolsVersion\n" : ""}${ndkVersion != null ? "    ndkVersion = $ndkVersion\n" : ""}\n$compileOptions\n${sourceSets.isNotEmpty ? "    sourceSets {\n${sourceSets.map((e) => e.toString()).join("\n")}\n    }\n\n" : ""}$defaultConfig\n${signingConfigs != null ? "$signingConfigs\n" : ""}\n$buildTypes";
  }
}

/// Compile Option Setting.
///
/// コンパイルオプション設定。
class GradleAndroidCompileOptions {
  /// Compile Option Setting.
  ///
  /// コンパイルオプション設定。
  GradleAndroidCompileOptions({
    required this.sourceCompatibility,
    required this.targetCompatibility,
    this.coreLibraryDesugaringEnabled,
  });

  factory GradleAndroidCompileOptions._load(String content) {
    String? value(List<String> keys) {
      return _GradleText.value(content, _compileOptionsPath, keys);
    }

    final coreLibraryDesugaringEnabledString = value([
      "isCoreLibraryDesugaringEnabled",
      "coreLibraryDesugaringEnabled",
    ])?.toLowerCase();
    final coreLibraryDesugaringEnabled =
        coreLibraryDesugaringEnabledString == null
            ? null
            : (coreLibraryDesugaringEnabledString == "true" ? true : false);
    return GradleAndroidCompileOptions(
      sourceCompatibility: value(["sourceCompatibility"]) ?? "",
      targetCompatibility: value(["targetCompatibility"]) ?? "",
      coreLibraryDesugaringEnabled: coreLibraryDesugaringEnabled,
    );
  }

  static String _save(
    String content,
    GradleAndroidCompileOptions data,
    GradleAndroidCompileOptions? original, {
    required bool isKotlin,
  }) {
    final changes = <List<String>, String>{
      if (data.sourceCompatibility.isNotEmpty &&
          data.sourceCompatibility != original?.sourceCompatibility)
        ["sourceCompatibility"]: data.sourceCompatibility,
      if (data.targetCompatibility.isNotEmpty &&
          data.targetCompatibility != original?.targetCompatibility)
        ["targetCompatibility"]: data.targetCompatibility,
      if (data.coreLibraryDesugaringEnabled != null &&
          data.coreLibraryDesugaringEnabled !=
              original?.coreLibraryDesugaringEnabled)
        isKotlin
            ? [
                "isCoreLibraryDesugaringEnabled",
                "coreLibraryDesugaringEnabled",
              ]
            : [
                "coreLibraryDesugaringEnabled",
                "isCoreLibraryDesugaringEnabled",
              ]: "${data.coreLibraryDesugaringEnabled}",
    };
    if (changes.isEmpty) {
      return content;
    }
    content = _GradleText.ensureBlock(
      content,
      _androidPath,
      r"compileOptions",
      "compileOptions",
      before: [
        r"kotlinOptions",
        r"buildFeatures",
        r"sourceSets",
        r"defaultConfig",
      ],
    );
    for (final entry in changes.entries) {
      content = _GradleText.setValue(
        content,
        _compileOptionsPath,
        entry.key,
        entry.value,
      );
    }
    return content;
  }

  /// Data for `sourceCompatibility`.
  ///
  /// `sourceCompatibility`のデータ。
  String sourceCompatibility;

  /// Data for `targetCompatibility`.
  ///
  /// `targetCompatibility`のデータ。
  String targetCompatibility;

  /// Data for `coreLibraryDesugaringEnabled`.
  ///
  /// `coreLibraryDesugaringEnabled`のデータ。
  bool? coreLibraryDesugaringEnabled;

  /// Raises Java compatibility values below [minimumVersion].
  ///
  /// 未設定または[minimumVersion]未満のJava互換性だけを引き上げます。
  void ensureMinimumJavaVersion(int minimumVersion) {
    sourceCompatibility = _ensureMinimumJavaVersion(
      sourceCompatibility,
      minimumVersion,
    );
    targetCompatibility = _ensureMinimumJavaVersion(
      targetCompatibility,
      minimumVersion,
    );
  }

  static String _ensureMinimumJavaVersion(String value, int minimumVersion) {
    if (value.isEmpty) {
      return "JavaVersion.VERSION_$minimumVersion";
    }
    final version = _parseJavaVersion(value);
    if (version != null && version < minimumVersion) {
      return "JavaVersion.VERSION_$minimumVersion";
    }
    return value;
  }

  static int? _parseJavaVersion(String value) {
    final javaVersion = RegExp(
      r"JavaVersion\.VERSION_(?:1_)?(\d+)",
    ).firstMatch(value)?.group(1);
    if (javaVersion != null) {
      return int.tryParse(javaVersion);
    }
    final toVersion = RegExp(
      "JavaVersion\\.toVersion\\(\\s*[\"']?(\\d+(?:\\.\\d+)?)[\"']?\\s*\\)",
    ).firstMatch(value)?.group(1);
    if (toVersion != null) {
      return _parseJavaVersionNumber(toVersion);
    }
    final literal = RegExp(
      "^[\"']?(\\d+(?:\\.\\d+)?)[\"']?\$",
    ).firstMatch(value.trim())?.group(1);
    return literal == null ? null : _parseJavaVersionNumber(literal);
  }

  static int? _parseJavaVersionNumber(String value) {
    final parts = value.split(".");
    if (parts.length == 2 && parts.first == "1") {
      return int.tryParse(parts.last);
    }
    return int.tryParse(value);
  }

  @override
  String toString() {
    return "    compileOptions {\n        sourceCompatibility = $sourceCompatibility\n        targetCompatibility = $targetCompatibility${coreLibraryDesugaringEnabled != null ? "\n        isCoreLibraryDesugaringEnabled = $coreLibraryDesugaringEnabled" : ""}\n    }\n";
  }
}

/// Source setting.
///
/// ソースの設定。
class GradleAndroidSourceSet {
  /// Source setting.
  ///
  /// ソースの設定。
  GradleAndroidSourceSet({
    required this.source,
    required this.target,
    required this.symbol,
  });

  /// Source Target.
  ///
  /// ソースのターゲット。
  String target;

  /// Additive Method.
  ///
  /// 加算方法。
  String symbol;

  /// Path of the source data.
  ///
  /// ソースデータのパス。
  String source;

  static List<GradleAndroidSourceSet> _load(String content) {
    final region = _GradleText.body(content, _sourceSetsPath);
    return RegExp(
      "(?<target>[a-zA-Z_.-]+) (?<symbol>[+=]+) (?<source>[a-zA-Z0-9_/\"'.-]+)",
    ).allMatches(region).mapAndRemoveEmpty((e) {
      return GradleAndroidSourceSet(
        source: e.namedGroup("source") ?? "",
        symbol: e.namedGroup("symbol") ?? "",
        target: e.namedGroup("target") ?? "",
      );
    });
  }

  static String _save(
    String content,
    List<GradleAndroidSourceSet> data,
    List<GradleAndroidSourceSet> original,
  ) {
    final existing = original.map((e) => e.toString().trim()).toSet();
    final added =
        data.where((e) => !existing.contains(e.toString().trim())).toList();
    if (added.isEmpty) {
      return content;
    }
    content = _GradleText.ensureBlock(
      content,
      _androidPath,
      r"sourceSets",
      "sourceSets",
      before: [r"defaultConfig"],
    );
    return _GradleText.addLines(
      content,
      _sourceSetsPath,
      added.map((e) => e.toString().trim()).toList(),
    );
  }

  @override
  String toString() {
    return "        $target $symbol $source";
  }
}

/// Default settings.
///
/// デフォルトの設定。
class GradleAndroidDefaultConfig {
  /// Default settings.
  ///
  /// デフォルトの設定。
  GradleAndroidDefaultConfig({
    required this.applicationId,
    required this.minSdkVersion,
    required this.targetSdkVersion,
    required this.versionCode,
    required this.versionName,
    this.testInstrumentationRunner,
    this.multiDexEnabled,
    this.resValues = const [],
  });

  factory GradleAndroidDefaultConfig._load(String content) {
    String? value(List<String> keys) {
      return _GradleText.value(content, _defaultConfigPath, keys);
    }

    final resValues =
        _GradleText.lines(content, _defaultConfigPath).mapAndRemoveEmpty(
      (e) => RegExp(r"^[ \t]*resValue(.+)$").firstMatch(e)?.group(1),
    );
    return GradleAndroidDefaultConfig(
      applicationId: value(["applicationId"]) ?? "",
      minSdkVersion: value(["minSdk", "minSdkVersion"]) ?? "",
      targetSdkVersion: value(["targetSdk", "targetSdkVersion"]) ?? "",
      versionCode: value(["versionCode"]) ?? "",
      versionName: value(["versionName"]) ?? "",
      testInstrumentationRunner: value(["testInstrumentationRunner"]),
      multiDexEnabled: value(["multiDexEnabled"]),
      resValues: resValues,
    );
  }

  static String _save(
    String content,
    GradleAndroidDefaultConfig data,
    GradleAndroidDefaultConfig? original,
  ) {
    final changes = <List<String>, String?>{
      ["applicationId"]: data.applicationId == original?.applicationId
          ? null
          : data.applicationId,
      ["minSdk", "minSdkVersion"]: data.minSdkVersion == original?.minSdkVersion
          ? null
          : data.minSdkVersion,
      [
        "targetSdk",
        "targetSdkVersion",
      ]: data.targetSdkVersion == original?.targetSdkVersion
          ? null
          : data.targetSdkVersion,
      ["versionCode"]:
          data.versionCode == original?.versionCode ? null : data.versionCode,
      ["versionName"]:
          data.versionName == original?.versionName ? null : data.versionName,
      [
        "testInstrumentationRunner",
      ]: data.testInstrumentationRunner == original?.testInstrumentationRunner
          ? null
          : data.testInstrumentationRunner,
      ["multiDexEnabled"]: data.multiDexEnabled == original?.multiDexEnabled
          ? null
          : data.multiDexEnabled,
    }..removeWhere((key, value) => value.isEmpty);
    final originalResValues =
        (original?.resValues ?? const <String>[]).map((e) => e.trim()).toSet();
    final resValues = data.resValues.map((e) => e.trim()).toSet();
    final addedResValues = data.resValues
        .where((e) => !originalResValues.contains(e.trim()))
        .toList();
    final removedResValues =
        originalResValues.where((e) => !resValues.contains(e)).toSet();
    if (changes.isEmpty && addedResValues.isEmpty && removedResValues.isEmpty) {
      return content;
    }
    content = _GradleText.ensureBlock(
      content,
      _androidPath,
      r"defaultConfig",
      "defaultConfig",
      before: [r"signingConfigs", r"buildTypes"],
    );
    for (final entry in changes.entries) {
      content = _GradleText.setValue(
        content,
        _defaultConfigPath,
        entry.key,
        entry.value!,
      );
    }
    if (removedResValues.isNotEmpty) {
      content = _GradleText.removeLines(
        content,
        _defaultConfigPath,
        (line) =>
            line.startsWith("resValue") &&
            removedResValues.contains(line.substring(8).trim()),
      );
    }
    return _GradleText.addLines(
      content,
      _defaultConfigPath,
      addedResValues
          .map((e) => "resValue${e.replaceAll(RegExp(r"^resValue\s*"), "")}")
          .toList(),
    );
  }

  /// Application ID.
  ///
  /// アプリケーションID。
  String applicationId;

  /// Minimum SDK version.
  ///
  /// 最小のSDKバージョン。
  String minSdkVersion;

  /// SDK version of the main target.
  ///
  /// メインターゲットのSDKバージョン。
  String targetSdkVersion;

  /// App version code.
  ///
  /// アプリのバージョンコード。
  String versionCode;

  /// Version name of the application.
  ///
  /// アプリのバージョン名。
  String versionName;

  /// Configuration of `testInstrumentationRunner`.
  ///
  /// `testInstrumentationRunner`の設定。
  String? testInstrumentationRunner;

  /// Set `multiDexEnabled`.
  ///
  /// `multiDexEnabled`の設定。
  String? multiDexEnabled;

  /// Setting of `resValue` (multiple settings possible).
  ///
  /// `resValue`の設定（複数設定可能）。
  List<String> resValues;

  @override
  String toString() {
    return "    defaultConfig {\n        applicationId = $applicationId\n        minSdk = $minSdkVersion\n        targetSdk = $targetSdkVersion\n        versionCode = $versionCode\n        versionName = $versionName\n${testInstrumentationRunner.isNotEmpty ? "        testInstrumentationRunner = $testInstrumentationRunner\n" : ""}${multiDexEnabled.isNotEmpty ? "        multiDexEnabled = $multiDexEnabled\n" : ""}${resValues.isNotEmpty ? "${resValues.map((e) => "        resValue${e.replaceAll(RegExp(r"^resValue\s*"), "")}").join("\n")}\n" : ""}    }\n";
  }
}

/// Build type setting.
///
/// ビルドタイプの設定。
class GradleAndroidBuildTypes {
  /// Build type setting.
  ///
  /// ビルドタイプの設定。
  GradleAndroidBuildTypes({this.release, this.debug});

  factory GradleAndroidBuildTypes._load(String content) {
    GradleAndroidBuildType? load(String head) {
      final path = [..._buildTypesPath, head];
      if (_GradleText.path(content, path) == null) {
        return null;
      }
      return GradleAndroidBuildType._load(content, path);
    }

    return GradleAndroidBuildTypes(
      release: load(_releaseHead),
      debug: load(_debugHead),
    );
  }

  static String _save(
    String content,
    GradleAndroidBuildTypes data,
    GradleAndroidBuildTypes? original,
  ) {
    content = GradleAndroidBuildType._save(
      content,
      _releaseHead,
      "release",
      data.release,
      original?.release,
    );
    content = GradleAndroidBuildType._save(
      content,
      _debugHead,
      "debug",
      data.debug,
      original?.debug,
    );
    return content;
  }

  /// Settings at the time of release.
  ///
  /// リリース時の設定。
  GradleAndroidBuildType? release;

  /// Settings during debugging.
  ///
  /// デバッグ時の設定。
  GradleAndroidBuildType? debug;

  @override
  String toString() {
    if (release == null && debug == null) {
      return "";
    }
    return "    buildTypes {\n${release != null ? "        release {\n$release        }\n" : ""}${debug != null ? "        debug {\n$debug        }\n" : ""}    }\n";
  }
}

/// Configuration class for the contents of [GradleAndroidBuildTypes].
///
/// Only `signingConfig`, `minifyEnabled` and `shrinkResources` are managed.
/// Other settings in the build type, such as `proguardFile`, are kept.
///
/// [GradleAndroidBuildTypes]の中身の設定クラス。
///
/// `signingConfig`、`minifyEnabled`、`shrinkResources`のみを扱い、
/// `proguardFile`などそれ以外の設定は保持します。
class GradleAndroidBuildType {
  /// Configuration class for the contents of [GradleAndroidBuildTypes].
  ///
  /// [GradleAndroidBuildTypes]の中身の設定クラス。
  GradleAndroidBuildType({
    required this.signingConfig,
    this.minifyEnabled,
    this.shrinkResources,
  });

  factory GradleAndroidBuildType._load(String content, List<String> path) {
    return GradleAndroidBuildType(
      signingConfig: _GradleText.value(content, path, ["signingConfig"]) ?? "",
      minifyEnabled: _GradleText.value(content, path, ["minifyEnabled"]),
      shrinkResources: _GradleText.value(content, path, ["shrinkResources"]),
    );
  }

  static String _save(
    String content,
    String head,
    String header,
    GradleAndroidBuildType? data,
    GradleAndroidBuildType? original,
  ) {
    if (data == null) {
      return content;
    }
    final changes = <String, String?>{
      "signingConfig": data.signingConfig == original?.signingConfig
          ? null
          : data.signingConfig,
      "minifyEnabled": data.minifyEnabled == original?.minifyEnabled
          ? null
          : data.minifyEnabled,
      "shrinkResources": data.shrinkResources == original?.shrinkResources
          ? null
          : data.shrinkResources,
    }..removeWhere((key, value) => value.isEmpty);
    if (changes.isEmpty) {
      return content;
    }
    content = _GradleText.ensureBlock(
      content,
      _androidPath,
      r"buildTypes",
      "buildTypes",
    );
    content = _GradleText.ensureBlock(
      content,
      _buildTypesPath,
      head,
      header,
    );
    for (final entry in changes.entries) {
      content = _GradleText.setValue(
        content,
        [..._buildTypesPath, head],
        [entry.key],
        entry.value!,
      );
    }
    return content;
  }

  /// Signature Method.
  ///
  /// 署名方法。
  String signingConfig;

  /// Set `minifyEnabled`.
  ///
  /// `minifyEnabled`の設定。
  String? minifyEnabled;

  /// Set `shrinkResources`.
  ///
  /// `shrinkResources`の設定。
  String? shrinkResources;

  @override
  String toString() {
    return "            signingConfig = $signingConfig\n${minifyEnabled != null ? "            minifyEnabled = $minifyEnabled\n" : ""}${shrinkResources != null ? "            shrinkResources = $shrinkResources\n" : ""}";
  }
}

/// Signature settings.
///
/// The whole `signingConfigs` block is managed by Katana and is rewritten
/// when its settings are changed.
///
/// 署名の設定。
///
/// `signingConfigs`ブロック全体をKatanaが管理し、設定変更時に書き換えます。
class GradleAndroidSigningConfigs {
  /// Signature settings.
  ///
  /// 署名の設定。
  GradleAndroidSigningConfigs({this.release, this.debug, bool isKotlin = true})
      : _isKotlin = isKotlin;

  static GradleAndroidSigningConfigs? _load(String content) {
    if (_GradleText.path(content, _signingConfigsPath) == null) {
      return null;
    }
    final region = _GradleText.body(content, _signingConfigsPath);
    GradleAndroidSigningConfig? load(String head) {
      final path = [..._signingConfigsPath, head];
      if (_GradleText.path(content, path) == null) {
        return null;
      }
      return GradleAndroidSigningConfig._load(_GradleText.body(content, path));
    }

    return GradleAndroidSigningConfigs(
      release: load(r'release|create\("release"\)|getByName\("release"\)'),
      debug: load(_debugHead),
      isKotlin: region.contains("create(") || region.contains("getByName("),
    );
  }

  static String _save(
    String content,
    GradleAndroidSigningConfigs? data,
    GradleAndroidSigningConfigs? original,
  ) {
    if (data == null || data.toString() == original?.toString()) {
      return content;
    }
    if (_GradleText.path(content, _signingConfigsPath) != null) {
      return _GradleText.replaceBlock(
        content,
        _signingConfigsPath,
        data.toString(),
      );
    }
    final code = data.toString();
    if (code.isEmpty) {
      return content;
    }
    final buildTypes = _GradleText.path(content, _buildTypesPath);
    if (buildTypes != null) {
      return content.replaceRange(
        buildTypes.start,
        buildTypes.start,
        "$code\n",
      );
    }
    final android = _GradleText.path(content, _androidPath)!;
    final closeLineStart = content.lastIndexOf("\n", android.close - 1) + 1;
    return content.replaceRange(closeLineStart, closeLineStart, "\n$code");
  }

  /// Settings at the time of release.
  ///
  /// リリース時の設定。
  GradleAndroidSigningConfig? release;

  /// Settings during debugging.
  ///
  /// デバッグ時の設定。
  GradleAndroidSigningConfig? debug;

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  final bool _isKotlin;

  @override
  String toString() {
    if (release == null && debug == null) {
      return "";
    }
    if (isKotlin) {
      return "    signingConfigs {\n${release != null ? "        create(\"release\") {\n$release        }\n" : ""}${debug != null ? "        getByName(\"debug\") {\n$debug        }\n" : ""}    }\n";
    } else {
      return "    signingConfigs {\n${release != null ? "        release {\n$release        }\n" : ""}${debug != null ? "        debug {\n$debug        }\n" : ""}    }\n";
    }
  }
}

/// Configuration class for the contents of [GradleAndroidSigningConfigs].
///
/// [GradleAndroidSigningConfigs]の中身の設定クラス。
class GradleAndroidSigningConfig {
  /// Configuration class for the contents of [GradleAndroidSigningConfigs].
  ///
  /// [GradleAndroidSigningConfigs]の中身の設定クラス。
  GradleAndroidSigningConfig({
    required this.keyAlias,
    required this.keyPassword,
    required this.storeFile,
    required this.storePassword,
    bool isKotlin = false,
  }) : _isKotlin = isKotlin;

  factory GradleAndroidSigningConfig._load(String content) {
    final keyAlias =
        RegExp("keyAlias = (.+)").firstMatch(content)?.group(1) ?? "";
    final keyPassword =
        RegExp("keyPassword = (.+)").firstMatch(content)?.group(1) ?? "";
    final storeFile =
        RegExp("storeFile = (.+)").firstMatch(content)?.group(1) ?? "";
    final storePassword =
        RegExp("storePassword = (.+)").firstMatch(content)?.group(1) ?? "";
    return GradleAndroidSigningConfig(
      keyAlias: keyAlias,
      keyPassword: keyPassword,
      storeFile: storeFile,
      storePassword: storePassword,
      isKotlin: content.contains("as String?"),
    );
  }

  /// Keystore alias.
  ///
  /// Keystoreのエイリアス。
  String keyAlias;

  /// Keystore alias password.
  ///
  /// Keystoreのエイリアスパスワード。
  String keyPassword;

  /// Keystore file path.
  ///
  /// Keystoreのファイルパス。
  String storeFile;

  /// Keystore password.
  ///
  /// Keystoreのパスワード。
  String storePassword;

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  final bool _isKotlin;

  @override
  String toString() {
    return "            keyAlias = $keyAlias\n            keyPassword = $keyPassword\n            storeFile = $storeFile\n            storePassword = $storePassword\n";
  }
}

/// Data in the `dependencies` section.
///
/// `dependencies`セクションのデータ。
class GradleDependencies {
  /// Data in the `android` section.
  ///
  /// `dependencies`セクションのデータ。
  GradleDependencies({
    required this.group,
    required this.packageName,
    bool isKotlin = false,
  }) : _isKotlin = isKotlin;

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  final bool _isKotlin;

  String get _key => "$group:$packageName";

  static List<GradleDependencies> _load(String content) {
    final region = _GradleText.body(content, [r"dependencies"]);
    final isKotlin = content.contains('("');
    if (isKotlin) {
      final implmentations = RegExp(
        r'(?<group>[a-zA-Z]+)\("(?<packageName>[^"]+)"\)',
      ).allMatches(region);
      return implmentations
          .map(
            (e) => GradleDependencies(
              group: e.namedGroup("group") ?? "",
              packageName: e.namedGroup("packageName") ?? "",
              isKotlin: true,
            ),
          )
          .toList();
    } else {
      final implmentations = RegExp(
        "(?<group>[a-zA-Z]+) \"(?<packageName>[^\"]+)\"",
      ).allMatches(region);
      return implmentations
          .map(
            (e) => GradleDependencies(
              group: e.namedGroup("group") ?? "",
              packageName: e.namedGroup("packageName") ?? "",
            ),
          )
          .toList();
    }
  }

  static String _save(
    String content,
    List<GradleDependencies> data,
    List<String> original,
  ) {
    final keys = data.map((e) => e._key).toSet();
    final removed = original.where((e) => !keys.contains(e)).toList();
    final added = data.where((e) => !original.contains(e._key)).toList();
    if (removed.isEmpty && added.isEmpty) {
      return content;
    }
    if (_GradleText.find(content, r"dependencies") == null) {
      if (added.isEmpty) {
        return content;
      }
      final separator = content.endsWith("\n") ? "\n" : "\n\n";
      return "$content${separator}dependencies {\n${added.join("\n")}\n}\n";
    }
    content = _GradleText.removeLines(content, [r"dependencies"], (line) {
      return removed.any((key) {
        final separator = key.indexOf(":");
        final group = key.substring(0, separator);
        final packageName = key.substring(separator + 1);
        return line.startsWith(group) &&
            (line.contains('"$packageName"') ||
                line.contains("'$packageName'"));
      });
    });
    return _GradleText.addLines(
        content,
        [
          r"dependencies",
        ],
        added.map((e) => e.toString().trim()).toList());
  }

  /// Group.
  ///
  /// グループ。
  String group;

  /// Dependency package name.
  ///
  /// 依存関係のパッケージ名。
  String packageName;

  @override
  String toString() {
    if (isKotlin) {
      return "    $group(\"$packageName\")";
    } else {
      return "    $group \"$packageName\"";
    }
  }
}

/// Class for retrieving and saving files in `android/build.gradle`.
///
/// `android/build.gradle`のファイルを取得して保存するためのクラス。
class BuildGradle {
  /// Class for retrieving and saving files in `android/build.gradle`.
  ///
  /// `android/build.gradle`のファイルを取得して保存するためのクラス。
  BuildGradle();

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  bool _isKotlin = false;

  /// Original text data.
  ///
  /// 元のテキストデータ。
  String get rawData => _rawData;
  late String _rawData;

  /// Data in the `buildScript` section.
  ///
  /// `buildScript`セクションのデータ。
  GradleBuildScript get buildScript => _buildScript;
  late GradleBuildScript _buildScript;

  /// Data in the `allprojects` section.
  ///
  /// `allprojects`セクションのデータ。
  GradleAllprojects get allProjects => _allProjects;
  late GradleAllprojects _allProjects;

  /// Data loading.
  ///
  /// データの読み込み。
  Future<void> load() async {
    if (File("android/build.gradle").existsSync()) {
      final gradle = File("android/build.gradle");
      _rawData = await gradle.readAsString();
    } else if (File("android/build.gradle.kts").existsSync()) {
      _isKotlin = true;
      final gradle = File("android/build.gradle.kts");
      _rawData = await gradle.readAsString();
    }
    _buildScript = GradleBuildScript._load(_rawData);
    _allProjects = GradleAllprojects._load(_rawData);
  }

  /// Data storage.
  ///
  /// データの保存。
  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    _rawData = GradleBuildScript._save(_rawData, _buildScript);
    _rawData = GradleAllprojects._save(_rawData, _allProjects);
    if (File("android/build.gradle").existsSync()) {
      final gradle = File("android/build.gradle");
      await gradle.writeAsString(_rawData);
    } else if (File("android/build.gradle.kts").existsSync()) {
      final gradle = File("android/build.gradle.kts");
      await gradle.writeAsString(_rawData);
    }
  }
}

/// Data in the `buildscript` section.
///
/// `buildscript`セクションのデータ。
class GradleBuildScript {
  /// Data in the `buildscript` section.
  ///
  /// `buildscript`セクションのデータ。
  GradleBuildScript({
    required this.kotlinVersion,
    required List<GradleBuildscriptDependencies> dependencies,
  }) : _dependencies = dependencies;

  factory GradleBuildScript._load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final kotlinVersion =
        (RegExp("ext.kotlin_version()[\\s\\S]+?=[\\s\\S]+?([a-zA-Z0-9_\"'.-]+)")
                    .firstMatch(region)
                    ?.group(1) ??
                Config.androidKotlinVersion)
            .trimString("'")
            .trimString('"');
    final dependencies = GradleBuildscriptDependencies._load(content);
    return GradleBuildScript(
      kotlinVersion: kotlinVersion,
      dependencies: dependencies,
    );
  }

  static final _regExp = RegExp(r"buildscript {([\s\S]+?)\n}");

  static String _save(String content, GradleBuildScript data) {
    var region = _regExp.firstMatch(content)?.group(1) ?? "";
    region = region.replaceAll(
      RegExp("ext.kotlin_version()[\\s\\S]+?=[\\s\\S]+?([a-zA-Z0-9_\"'.-]+)"),
      "ext.kotlin_version = '${data.kotlinVersion}'",
    );
    region = GradleBuildscriptDependencies._save(region, data.dependencies);
    return content.replaceAll(
        _regExp, "buildscript {\n${region.trimString("\n")}\n}");
  }

  /// Kotlin version.
  ///
  /// Kotlinバージョン。
  String? kotlinVersion;

  /// Data in the `dependencies` section.
  ///
  /// `dependencies`セクションのデータ。
  List<GradleBuildscriptDependencies> get dependencies => _dependencies;
  final List<GradleBuildscriptDependencies> _dependencies;

  @override
  String toString() {
    return "    ext.kotlin_version = '$kotlinVersion'\n";
  }
}

/// Configuration class for the contents of [GradleBuildscriptDependencies].
///
/// [GradleBuildscriptDependencies]の中身の設定クラス。
class GradleBuildscriptDependencies {
  /// Configuration class for the contents of [GradleBuildscriptDependencies].
  ///
  /// [GradleBuildscriptDependencies]の中身の設定クラス。
  GradleBuildscriptDependencies({
    required this.classpath,
  });

  static final _regExp = RegExp(r"dependencies {([\s\S]+?)}");

  /// Keystore alias.
  ///
  /// Keystoreのエイリアス。
  final String classpath;

  static List<GradleBuildscriptDependencies> _load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final classpaths = RegExp("classpath (?<classpath>.+)").allMatches(region);
    return classpaths
        .map(
          (e) => GradleBuildscriptDependencies(
            classpath: e
                    .namedGroup("classpath")
                    ?.replaceAll("\n", "")
                    .trimString("'")
                    .trimString('"') ??
                "",
          ),
        )
        .toList();
  }

  static String _save(
      String content, List<GradleBuildscriptDependencies> data) {
    return content.replaceAll(
        _regExp, "dependencies {\n${data.join("\n")}\n    }");
  }

  @override
  String toString() {
    return "        classpath \"$classpath\"";
  }
}

/// Data in the `allprojects` section.
///
/// `allprojects`セクションのデータ。
class GradleAllprojects {
  /// Data in the `allprojects` section.
  ///
  /// `allprojects`セクションのデータ。
  GradleAllprojects({
    required List<GradleAllprojectsConfigurations> configurations,
  }) : _configurations = configurations;

  factory GradleAllprojects._load(String content) {
    final configurations = GradleAllprojectsConfigurations._load(content);
    return GradleAllprojects(
      configurations: configurations,
    );
  }

  static final _regExp = RegExp(r"allprojects {([\s\S]+?)\n}");

  static String _save(String content, GradleAllprojects data) {
    var region = _regExp.firstMatch(content)?.group(1) ?? "";
    region = GradleAllprojectsConfigurations._save(region, data.configurations);
    return content.replaceAll(
        _regExp, "allprojects {\n${region.trimString("\n")}\n}");
  }

  /// Data in the `configurations.all` section.
  ///
  /// `configurations.all`セクションのデータ。
  List<GradleAllprojectsConfigurations> get configurations => _configurations;
  final List<GradleAllprojectsConfigurations> _configurations;

  @override
  String toString() {
    return "";
  }
}

/// Configuration class for the contents of [GradleAllprojectsConfigurations].
///
/// [GradleAllprojectsConfigurations]の中身の設定クラス。
class GradleAllprojectsConfigurations {
  /// Configuration class for the contents of [GradleAllprojectsConfigurations].
  ///
  /// [GradleAllprojectsConfigurations]の中身の設定クラス。
  GradleAllprojectsConfigurations({
    required this.command,
  });

  static final _regExp = RegExp(r"configurations\.all {([\s\S]+?)}");

  /// Command.
  ///
  /// コマンド。
  final String command;

  static List<GradleAllprojectsConfigurations> _load(String content) {
    final region = _regExp.firstMatch(content)?.group(1) ?? "";
    final commands = region
        .replaceAll("\r\n", "\n")
        .replaceAll("\r", "\n")
        .split("\n")
        .map((e) => e.trim())
        .toList();
    return commands
        .map(
          (e) => GradleAllprojectsConfigurations(
            command: e,
          ),
        )
        .toList();
  }

  static String _save(
      String content, List<GradleAllprojectsConfigurations> data) {
    return content.replaceAll(
        _regExp, "configurations.all {\n${data.join("\n")}\n    }");
  }

  @override
  String toString() {
    return "        $command";
  }
}

/// Class for retrieving and saving files in `android/settings.gradle`.
///
/// `android/settings.gradle`のファイルを取得して保存するためのクラス。
class SettingsGradle {
  /// Class for retrieving and saving files in `android/settings.gradle`.
  ///
  /// `android/settings.gradle`のファイルを取得して保存するためのクラス。
  SettingsGradle();

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  bool get isKotlin => _isKotlin;
  bool _isKotlin = false;

  /// Original text data.
  ///
  /// 元のテキストデータ。
  String get rawData => _rawData;
  late String _rawData;

  /// Data in the `plugins` section.
  ///
  /// `plugins`セクションのデータ。
  List<SettingsGradlePlugins> get plugins => _plugins;
  late List<SettingsGradlePlugins> _plugins;

  /// Data loading.
  ///
  /// データの読み込み。
  Future<void> load() async {
    if (File("android/settings.gradle").existsSync()) {
      final gradle = File("android/settings.gradle");
      _rawData = await gradle.readAsString();
    } else if (File("android/settings.gradle.kts").existsSync()) {
      _isKotlin = true;
      final gradle = File("android/settings.gradle.kts");
      _rawData = await gradle.readAsString();
    }
    _plugins = SettingsGradlePlugins._load(_rawData);
  }

  /// Data storage.
  ///
  /// データの保存。
  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    _rawData = SettingsGradlePlugins._save(_rawData, _plugins);

    if (File("android/settings.gradle").existsSync()) {
      final gradle = File("android/settings.gradle");
      await gradle.writeAsString(_rawData);
    } else if (File("android/settings.gradle.kts").existsSync()) {
      final gradle = File("android/settings.gradle.kts");
      await gradle.writeAsString(_rawData);
    }
  }
}

/// Configuration class for the contents of [SettingsGradlePlugins].
///
/// [GradleAllprojectsConfigurations]の中身の設定クラス。
class SettingsGradlePlugins {
  /// Configuration class for the contents of [SettingsGradlePlugins].
  ///
  /// [SettingsGradlePlugins]の中身の設定クラス。
  SettingsGradlePlugins({
    required this.package,
    required this.version,
    this.apply,
    this.isKotlin = false,
  });

  static final _regExp = RegExp(
    "id\\(?['\"](?<package>[a-zA-Z0-9._-]+)['\"]\\)? version ['\"](?<version>[a-zA-Z0-9._-]+)['\"]( apply (?<apply>[a-zA-Z]+))?",
  );

  /// Whether the file is written in Kotlin.
  ///
  /// ファイルがKotlinで書かれているかどうか。
  final bool isKotlin;

  /// Package Name.
  ///
  /// パッケージ名。
  final String package;

  /// Version.
  ///
  /// バージョン。
  final String version;

  /// Apply or not.
  ///
  /// 適用するかどうか。
  final bool? apply;

  static List<SettingsGradlePlugins> _load(String content) {
    final newRegion =
        RegExp(r"plugins[^{]*?\{([\s\S]*?)\}").firstMatch(content);
    if (newRegion == null) {
      return [];
    }
    final regionText = newRegion.group(1) ?? "";
    final packages = _regExp.allMatches(regionText);
    return packages
        .map(
          (e) => SettingsGradlePlugins(
            package: e.namedGroup("package") ?? "",
            version: e.namedGroup("version") ?? "",
            apply: e.namedGroup("apply") == null
                ? null
                : e.namedGroup("apply") == "true",
            isKotlin: regionText.contains('id("'),
          ),
        )
        .toList();
  }

  static String _save(String content, List<SettingsGradlePlugins> data) {
    final newRegion =
        RegExp(r"plugins[^{]*?\{([\s\S]*?)\}").firstMatch(content);
    if (newRegion == null) {
      return content;
    }
    final code = data.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"plugins[^{]*?\{([\s\S]*?)\}",
      ),
      "plugins {\n$code\n}",
    );
  }

  @override
  String toString() {
    if (isKotlin) {
      return "    id(\"$package\") version \"$version\"${apply != null ? " apply ${apply! ? "true" : "false"}" : ""}";
    } else {
      return "    id \"$package\" version \"$version\"${apply != null ? " apply ${apply! ? "true" : "false"}" : ""}";
    }
  }
}
