import 'dart:io';
import 'package:katana/katana.dart';

/// Utility to edit XCode's project.pbxproj.
///
/// XCodeのproject.pbxprojを編集するためのユーティリティ。
class XCode {
  XCode();

  String get rawData => _rawData;
  late String _rawData;

  List<PBXBuildFile> get pbxBuildFile => _pbxBuildFile;
  late List<PBXBuildFile> _pbxBuildFile;

  List<PBXFileReference> get pbxFileReference => _pbxFileReference;
  late List<PBXFileReference> _pbxFileReference;

  Future<void> load() async {
    final pbx = File("ios/Runner.xcodeproj/project.pbxproj");
    _rawData = await pbx.readAsString();
    _pbxBuildFile = PBXBuildFile._load(_rawData);
    _pbxFileReference = PBXFileReference._load(_rawData);
  }

  Future<void> save() async {
    if (_rawData.isEmpty) {
      throw Exception("No value. Please load data with [load].");
    }
    _rawData = PBXFileReference._save(_rawData, _pbxFileReference);
    _rawData = PBXBuildFile._save(_rawData, _pbxBuildFile);
    _rawData = _rawData.replaceFirstMapped(
      RegExp(r"objectVersion = ([0-9]+);"),
      (m) => "objectVersion = ${(int.tryParse(m.group(1) ?? "") ?? 0) + 1};",
    );
    final pbx = File("ios/Runner.xcodeproj/project.pbxproj");
    await pbx.writeAsString(_rawData);
  }

  static String generateId() {
    return generateCode(24, charSet: "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ");
  }
}

class PBXBuildFile {
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

  final String isa = "PBXBuildFile";
  final String id;
  final String fileRef;
  final String fileName;
  final String fileDir;

  @override
  String toString() {
    return "\t\t$id /* $fileName in $fileDir */ = {isa = PBXBuildFile; fileRef = $fileRef /* $fileName */; };";
  }
}

class PBXFileReference {
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

  final String isa = "PBXFileReference";
  final String id;
  final String? lastKnownFileType;
  final String path;
  final String? name;
  final String comment;
  final String sourceTree;
  final int? fileEncoding;
  final String? explicitFileType;
  final int? includeInIndex;

  @override
  String toString() {
    return '\t\t$id /* $comment */ = {isa = PBXFileReference; ${fileEncoding != null ? "fileEncoding = $fileEncoding; " : ""}${explicitFileType != null ? "explicitFileType = $explicitFileType; " : ""}${includeInIndex != null ? "includeInIndex = $includeInIndex; " : ""}${lastKnownFileType != null ? "lastKnownFileType = $lastKnownFileType; " : ""}${name != null ? "name = $name; " : ""}path = $path; sourceTree = $sourceTree; };';
  }
}
