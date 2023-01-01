import 'dart:io';
import 'package:katana/katana.dart';

/// Utility to edit XCode's project.pbxproj.
///
/// XCodeのproject.pbxprojを編集するためのユーティリティ。
class XCode {
  /// Utility to edit XCode's project.pbxproj.
  ///
  /// XCodeのproject.pbxprojを編集するためのユーティリティ。
  XCode();

  /// Original text data.
  ///
  /// 元のテキストデータ。
  String get rawData => _rawData;
  late String _rawData;

  /// BuildFile data.
  ///
  /// BuildFileのデータ。
  List<PBXBuildFile> get pbxBuildFile => _pbxBuildFile;
  late List<PBXBuildFile> _pbxBuildFile;

  /// FileReference data.
  ///
  /// FileReferenceのデータ。
  List<PBXFileReference> get pbxFileReference => _pbxFileReference;
  late List<PBXFileReference> _pbxFileReference;

  /// PBXGroup data.
  ///
  /// PBXGroupのデータ。
  List<PBXGroup> get pbxGroup => _pbxGroup;
  late List<PBXGroup> _pbxGroup;

  /// ResourcesBuildPhase data.
  ///
  /// ResourcesBuildPhaseのデータ。
  List<PBXResourcesBuildPhase> get pbxResourcesBuildPhase =>
      _pbxResourcesBuildPhase;
  late List<PBXResourcesBuildPhase> _pbxResourcesBuildPhase;

  /// VariantGroup data.
  ///
  /// VariantGroupのデータ。
  List<PBXVariantGroup> get pbxVariantGroup => _pbxVariantGroup;
  late List<PBXVariantGroup> _pbxVariantGroup;

  /// Data loading.
  ///
  /// データの読み込み。
  Future<void> load() async {
    final pbx = File("ios/Runner.xcodeproj/project.pbxproj");
    _rawData = await pbx.readAsString();
    _pbxBuildFile = PBXBuildFile._load(_rawData);
    _pbxFileReference = PBXFileReference._load(_rawData);
    _pbxGroup = PBXGroup._load(_rawData);
    _pbxResourcesBuildPhase = PBXResourcesBuildPhase._load(_rawData);
    _pbxVariantGroup = PBXVariantGroup._load(_rawData);
  }

  /// Data storage.
  ///
  /// データの保存。
  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    _rawData = PBXVariantGroup._save(_rawData, _pbxVariantGroup);
    _rawData = PBXResourcesBuildPhase._save(_rawData, _pbxResourcesBuildPhase);
    _rawData = PBXGroup._save(_rawData, _pbxGroup);
    _rawData = PBXFileReference._save(_rawData, _pbxFileReference);
    _rawData = PBXBuildFile._save(_rawData, _pbxBuildFile);
    _rawData = _rawData.replaceFirstMapped(
      RegExp(r"objectVersion = ([0-9]+);"),
      (m) => "objectVersion = ${(int.tryParse(m.group(1) ?? "") ?? 0) + 1};",
    );
    final pbx = File("ios/Runner.xcodeproj/project.pbxproj");
    await pbx.writeAsString(_rawData);
  }

  /// Create an ID for XCode.
  ///
  /// XCode用のIDを作成します。
  static String generateId() {
    return generateCode(24, charSet: "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  }
}

/// BuildFile data.
///
/// BuildFileのデータ。
class PBXBuildFile {
  /// BuildFile data.
  ///
  /// BuildFileのデータ。
  factory PBXBuildFile({
    String? id,
    required String fileRef,
    required String fileName,
    required String fileDir,
  }) {
    return PBXBuildFile._(
      fileDir: fileDir,
      fileName: fileName,
      fileRef: fileRef,
      id: id ?? XCode.generateId(),
    );
  }
  PBXBuildFile._({
    required this.id,
    required this.fileRef,
    required this.fileName,
    required this.fileDir,
  });

  static List<PBXBuildFile> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXBuildFile section \*/([\s\S]+)/\* End PBXBuildFile section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r"([0-9A-Z]{24}) /\* ([a-zA-Z_.-]+) in ([a-zA-Z_.-]+) \*/ = {isa = PBXBuildFile; fileRef = ([0-9A-Z]{24}) /\* ([a-zA-Z_.-]+) \*/; };",
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXBuildFile._(
        id: e.group(1) ?? "",
        fileName: e.group(2) ?? "",
        fileDir: e.group(3) ?? "",
        fileRef: e.group(4) ?? "",
      );
    });
  }

  static String _save(String content, List<PBXBuildFile> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXBuildFile section \*/([\s\S]+)/\* End PBXBuildFile section \*/",
      ),
      "/* Begin PBXBuildFile section */\n$code\n/* End PBXBuildFile section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXBuildFile";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// Value of `fileRef`.
  ///
  /// `fileRef`の値。
  final String fileRef;

  /// File name for comments.
  ///
  /// コメント用のファイル名。
  final String fileName;

  /// Name of file folder for comments.
  ///
  /// コメント用のファイルフォルダ名。
  final String fileDir;

  @override
  String toString() {
    return "\t\t$id /* $fileName in $fileDir */ = {isa = PBXBuildFile; fileRef = $fileRef /* $fileName */; };";
  }
}

/// FileReference data.
///
/// FileReferenceのデータ。
class PBXFileReference {
  /// FileReference data.
  ///
  /// FileReferenceのデータ。
  factory PBXFileReference({
    String? id,
    String? lastKnownFileType,
    required String path,
    required String comment,
    String? name,
    String? explicitFileType,
    int? fileEncoding,
    int? includeInIndex,
    required String sourceTree,
  }) {
    return PBXFileReference._(
      name: name,
      path: path,
      sourceTree: sourceTree,
      comment: comment,
      lastKnownFileType: lastKnownFileType,
      explicitFileType: explicitFileType,
      fileEncoding: fileEncoding,
      includeInIndex: includeInIndex,
      id: id ?? XCode.generateId(),
    );
  }
  PBXFileReference._({
    required this.id,
    this.lastKnownFileType,
    required this.path,
    required this.comment,
    this.name,
    this.fileEncoding,
    this.explicitFileType,
    this.includeInIndex,
    required this.sourceTree,
  });

  static List<PBXFileReference> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXFileReference section \*/([\s\S]+)/\* End PBXFileReference section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) /\* (?<comment>[a-zA-Z_.-]+) \*/ = {isa = PBXFileReference; (fileEncoding = (?<fileEncoding>[0-9]+); )?(explicitFileType = (?<explicitFileType>[a-zA-Z_.-]+); )?(includeInIndex = (?<includeInIndex>[0-9]+); )?(lastKnownFileType = (?<lastKnownFileType>[a-zA-Z_.-]+); )?(name = (?<name>[a-zA-Z_."-]+); )?path = (?<path>[a-zA-Z_ ."/-]+); sourceTree = (?<sourceTree>[a-zA-Z_."<>-]+); };',
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXFileReference._(
        id: e.namedGroup("id") ?? "",
        lastKnownFileType: e.namedGroup("lastKnownFileType"),
        name: e.namedGroup("name"),
        comment: e.namedGroup("comment") ?? "",
        path: e.namedGroup("path") ?? "",
        sourceTree: e.namedGroup("sourceTree") ?? "",
        fileEncoding: int.tryParse(e.namedGroup("fileEncoding") ?? ""),
        explicitFileType: e.namedGroup("explicitFileType"),
        includeInIndex: int.tryParse(e.namedGroup("includeInIndex") ?? ""),
      );
    });
  }

  static String _save(String content, List<PBXFileReference> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXFileReference section \*/([\s\S]+)/\* End PBXFileReference section \*/",
      ),
      "/* Begin PBXFileReference section */\n$code\n/* End PBXFileReference section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXFileReference";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// `lastKnownFileType` information.
  ///
  /// `lastKnownFileType`の情報。
  final String? lastKnownFileType;

  /// File Path.
  ///
  /// ファイルパス。
  final String path;

  /// File Name.
  ///
  /// ファイル名。
  final String? name;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String comment;

  /// SourceTree data.
  ///
  /// SourceTreeのデータ。
  final String sourceTree;

  /// File encoding number.
  ///
  /// ファイルエンコーディング番号。
  final int? fileEncoding;

  /// Data of `explicitFileType`.
  ///
  /// `explicitFileType`のデータ。
  final String? explicitFileType;

  /// Data for `includeInIndex`.
  ///
  /// `includeInIndex`のデータ。
  final int? includeInIndex;

  @override
  String toString() {
    return '\t\t$id /* $comment */ = {isa = PBXFileReference; ${fileEncoding != null ? "fileEncoding = $fileEncoding; " : ""}${explicitFileType != null ? "explicitFileType = $explicitFileType; " : ""}${includeInIndex != null ? "includeInIndex = $includeInIndex; " : ""}${lastKnownFileType != null ? "lastKnownFileType = $lastKnownFileType; " : ""}${name != null ? "name = $name; " : ""}path = $path; sourceTree = $sourceTree; };';
  }
}

/// PBXGroup data.
///
/// PBXGroupのデータ。
class PBXGroup {
  /// PBXGroup data.
  ///
  /// PBXGroupのデータ。
  factory PBXGroup({
    String? id,
    String? comment,
    required String sourceTree,
    required List<PBXGroupChild> children,
    String? path,
    String? name,
  }) {
    return PBXGroup._(
      sourceTree: sourceTree,
      comment: comment,
      children: children,
      path: path,
      name: name,
      id: id ?? XCode.generateId(),
    );
  }
  PBXGroup._({
    required this.id,
    this.comment,
    this.path,
    this.name,
    required this.sourceTree,
    required this.children,
  });

  static List<PBXGroup> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXGroup section \*/([\s\S]+)/\* End PBXGroup section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) (/\* (?<comment>[a-zA-Z_.-]+) \*/ )?= {[\s\t\n]+isa = PBXGroup;[\s\t\n]+children = \((?<children>[^\)]+)\);[\s\t\n]+(name = (?<name>[a-zA-Z_."-]+);[\s\t\n]+)?(path = (?<path>[a-zA-Z_ ."-]+);[\s\t\n]+)?sourceTree = (?<sourceTree>[a-zA-Z_."<>-]+);[\s\t\n]+};',
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXGroup._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment"),
        name: e.namedGroup("name"),
        path: e.namedGroup("path"),
        sourceTree: e.namedGroup("sourceTree") ?? "",
        children: PBXGroupChild._parse(e.namedGroup("children") ?? ""),
      );
    });
  }

  static String _save(String content, List<PBXGroup> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXGroup section \*/([\s\S]+)/\* End PBXGroup section \*/",
      ),
      "/* Begin PBXGroup section */\n$code\n/* End PBXGroup section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXGroup";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String? comment;

  /// Data for [PBXGroupChild].
  ///
  /// [PBXGroupChild]のデータ。
  final List<PBXGroupChild> children;

  /// Group Name.
  ///
  /// グループ名。
  final String? name;

  /// Group Pass.
  ///
  /// グループパス。
  final String? path;

  /// `soruceTree` data.
  ///
  /// `soruceTree`のデータ。
  final String sourceTree;

  @override
  String toString() {
    return "\t\t$id ${comment != null ? "/* $comment */ " : ""}= {\n\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n${children.map((e) => e.toString()).join(",\n")},\n\t\t\t);\n${name != null ? "\t\t\tname = $name;\n" : ""}${path != null ? "\t\t\tpath = $path;\n" : ""}\t\t\tsourceTree = $sourceTree;\n\t\t};";
  }
}

/// Class for `children` of [PBXGroup].
///
/// [PBXGroup]の`children`用のクラス。
class PBXGroupChild {
  /// Class for `children` of [PBXGroup].
  ///
  /// [PBXGroup]の`children`用のクラス。
  factory PBXGroupChild({
    String? id,
    required String comment,
  }) {
    return PBXGroupChild._(
      comment: comment,
      id: id ?? XCode.generateId(),
    );
  }
  PBXGroupChild._({
    required this.id,
    required this.comment,
  });

  static List<PBXGroupChild> _parse(String text) {
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) /\* (?<comment>[a-zA-Z_.-]+) \*/,',
    ).allMatches(text).mapAndRemoveEmpty((e) {
      return PBXGroupChild._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment") ?? "",
      );
    });
  }

  /// ID of the element.
  ///
  /// 要素のID。
  final String id;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String comment;

  @override
  String toString() {
    return "\t\t\t\t$id /* $comment */";
  }
}

/// ResourcesBuildPhase data.
///
/// ResourcesBuildPhaseのデータ。
class PBXResourcesBuildPhase {
  /// ResourcesBuildPhase data.
  ///
  /// ResourcesBuildPhaseのデータ。
  factory PBXResourcesBuildPhase({
    String? id,
    String? comment,
    required List<PBXResourcesBuildPhaseFile> files,
    required int buildActionMask,
    required int runOnlyForDeploymentPostprocessing,
  }) {
    return PBXResourcesBuildPhase._(
      buildActionMask: buildActionMask,
      comment: comment,
      files: files,
      runOnlyForDeploymentPostprocessing: runOnlyForDeploymentPostprocessing,
      id: id ?? XCode.generateId(),
    );
  }
  PBXResourcesBuildPhase._({
    required this.id,
    this.comment,
    required this.buildActionMask,
    required this.runOnlyForDeploymentPostprocessing,
    required this.files,
  });

  static List<PBXResourcesBuildPhase> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXResourcesBuildPhase section \*/([\s\S]+)/\* End PBXResourcesBuildPhase section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) (/\* (?<comment>[a-zA-Z_.-]+) \*/ )?= {[\s\t\n]+isa = PBXResourcesBuildPhase;[\s\t\n]+buildActionMask = (?<buildActionMask>[0-9]+);[\s\t\n]+files = \((?<files>[^\)]+)\);[\s\t\n]+runOnlyForDeploymentPostprocessing = (?<runOnlyForDeploymentPostprocessing>[0-9]+);[\s\t\n]+};',
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXResourcesBuildPhase._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment"),
        buildActionMask:
            int.tryParse(e.namedGroup("buildActionMask") ?? "") ?? 0,
        runOnlyForDeploymentPostprocessing: int.tryParse(
              e.namedGroup("runOnlyForDeploymentPostprocessing") ?? "",
            ) ??
            0,
        files: PBXResourcesBuildPhaseFile._parse(e.namedGroup("files") ?? ""),
      );
    });
  }

  static String _save(String content, List<PBXResourcesBuildPhase> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXResourcesBuildPhase section \*/([\s\S]+)/\* End PBXResourcesBuildPhase section \*/",
      ),
      "/* Begin PBXResourcesBuildPhase section */\n$code\n/* End PBXResourcesBuildPhase section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXResourcesBuildPhase";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// Comment file.
  ///
  /// コメントファイル。
  final String? comment;

  /// List of files in [PBXResourcesBuildPhase].
  ///
  /// [PBXResourcesBuildPhase]のファイル一覧。
  final List<PBXResourcesBuildPhaseFile> files;

  /// Data for `buildActionMask`.
  ///
  /// `buildActionMask`のデータ。
  final int buildActionMask;

  /// Data for `runOnlyForDeploymentPostprocessing`.
  ///
  /// `runOnlyForDeploymentPostprocessing`のデータ。
  final int runOnlyForDeploymentPostprocessing;

  @override
  String toString() {
    return "\t\t$id ${comment != null ? "/* $comment */ " : ""}= {\n\t\t\tisa = PBXResourcesBuildPhase;\n\t\t\tbuildActionMask = $buildActionMask;\n\t\t\tfiles = (\n${files.map((e) => e.toString()).join(",\n")},\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = $runOnlyForDeploymentPostprocessing;\n\t\t};";
  }
}

/// Class for [PBXResourcesBuildPhase] files.
///
/// [PBXResourcesBuildPhase]のファイル用のクラス。
class PBXResourcesBuildPhaseFile {
  /// Class for [PBXResourcesBuildPhase] files.
  ///
  /// [PBXResourcesBuildPhase]のファイル用のクラス。
  factory PBXResourcesBuildPhaseFile({
    String? id,
    required String fileName,
    required String fileDir,
  }) {
    return PBXResourcesBuildPhaseFile._(
      fileName: fileName,
      fileDir: fileDir,
      id: id ?? XCode.generateId(),
    );
  }
  PBXResourcesBuildPhaseFile._({
    required this.id,
    required this.fileName,
    required this.fileDir,
  });

  static List<PBXResourcesBuildPhaseFile> _parse(String text) {
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) /\* (?<fileName>[a-zA-Z_.-]+) in (?<fileDir>[a-zA-Z_.-]+) \*/,',
    ).allMatches(text).mapAndRemoveEmpty((e) {
      return PBXResourcesBuildPhaseFile._(
        id: e.namedGroup("id") ?? "",
        fileName: e.namedGroup("fileName") ?? "",
        fileDir: e.namedGroup("fileDir") ?? "",
      );
    });
  }

  /// ID of the element.
  ///
  /// 要素のID。
  final String id;

  /// File name for comments.
  ///
  /// コメント用のファイル名。
  final String fileName;

  /// Name of file folder for comments.
  ///
  /// コメント用のファイルフォルダ名。
  final String fileDir;

  @override
  String toString() {
    return "\t\t\t\t$id /* $fileName in $fileDir */";
  }
}

/// VariantGroup data.
///
/// VariantGroupのデータ。
class PBXVariantGroup {
  /// VariantGroup data.
  ///
  /// VariantGroupのデータ。
  factory PBXVariantGroup({
    String? id,
    String? comment,
    required List<PBXVariantGroupChild> children,
    required String name,
    required String sourceTree,
  }) {
    return PBXVariantGroup._(
      name: name,
      comment: comment,
      children: children,
      sourceTree: sourceTree,
      id: id ?? XCode.generateId(),
    );
  }
  PBXVariantGroup._({
    required this.id,
    this.comment,
    required this.name,
    required this.sourceTree,
    required this.children,
  });

  static List<PBXVariantGroup> _load(String content) {
    final region = RegExp(
      r"/\* Begin PBXVariantGroup section \*/([\s\S]+)/\* End PBXVariantGroup section \*/",
    ).firstMatch(content);
    if (region == null) {
      return [];
    }
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) (/\* (?<comment>[a-zA-Z_.-]+) \*/ )?= {[\s\t\n]+isa = PBXVariantGroup;[\s\t\n]+children = \((?<children>[^\)]+)\);[\s\t\n]+name = (?<name>[a-zA-Z_."-]+);[\s\t\n]+sourceTree = (?<sourceTree>[a-zA-Z_."<>-]+);[\s\t\n]+};',
    ).allMatches(region.group(1) ?? "").mapAndRemoveEmpty((e) {
      return PBXVariantGroup._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment"),
        name: e.namedGroup("name") ?? "",
        sourceTree: e.namedGroup("sourceTree") ?? "",
        children: PBXVariantGroupChild.parse(e.namedGroup("children") ?? ""),
      );
    });
  }

  static String _save(String content, List<PBXVariantGroup> list) {
    final code = list.map((e) => e.toString()).join("\n");
    return content.replaceAll(
      RegExp(
        r"/\* Begin PBXVariantGroup section \*/([\s\S]+)/\* End PBXVariantGroup section \*/",
      ),
      "/* Begin PBXVariantGroup section */\n$code\n/* End PBXVariantGroup section */",
    );
  }

  /// Value of `isa`.
  ///
  /// `isa`の値。
  final String isa = "PBXVariantGroup";

  /// ID of the section.
  ///
  /// セクションのID。
  final String id;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String? comment;

  /// List of data in the group.
  ///
  /// グループ内のデータ一覧。
  final List<PBXVariantGroupChild> children;

  /// Group Name.
  ///
  /// グループ名。
  final String name;

  /// Data from `sourceTree`.
  ///
  /// `sourceTree`のデータ。
  final String sourceTree;

  @override
  String toString() {
    return "\t\t$id ${comment != null ? "/* $comment */ " : ""}= {\n\t\t\tisa = PBXVariantGroup;\n\t\t\tchildren = (\n${children.map((e) => e.toString()).join(",\n")},\n\t\t\t);\n\t\t\tname = $name;\n\t\t\tsourceTree = $sourceTree;\n\t\t};";
  }
}

/// Data for `children` in [PBXVariantGroup].
///
/// [PBXVariantGroup]の`children`のデータ。
class PBXVariantGroupChild {
  /// Data for `children` in [PBXVariantGroup].
  ///
  /// [PBXVariantGroup]の`children`のデータ。
  factory PBXVariantGroupChild({
    String? id,
    required String comment,
  }) {
    return PBXVariantGroupChild._(
      comment: comment,
      id: id ?? XCode.generateId(),
    );
  }
  PBXVariantGroupChild._({
    required this.id,
    required this.comment,
  });

  static List<PBXVariantGroupChild> parse(String text) {
    return RegExp(
      r'(?<id>[0-9A-Z]{24}) /\* (?<comment>[a-zA-Z_.-]+) \*/,',
    ).allMatches(text).mapAndRemoveEmpty((e) {
      return PBXVariantGroupChild._(
        id: e.namedGroup("id") ?? "",
        comment: e.namedGroup("comment") ?? "",
      );
    });
  }

  /// ID of the element.
  ///
  /// 要素のID。
  final String id;

  /// Comment Data.
  ///
  /// コメントデータ。
  final String comment;

  @override
  String toString() {
    return "\t\t\t\t$id /* $comment */";
  }
}
