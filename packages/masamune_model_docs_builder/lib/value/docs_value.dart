part of "/masamune_model_docs_builder.dart";

/// Class for storing document values.
///
/// ドキュメントの値を格納するためのクラス。
class DocsValue {
  /// Class for storing document values.
  ///
  /// ドキュメントの値を格納するためのクラス。
  const DocsValue({
    required this.classValue,
    required this.pathValue,
    required this.annotationValue,
  });

  /// The parsed value of the class.
  ///
  /// クラスのパースされた値。
  final ClassValue classValue;

  /// The parsed value of the path.
  ///
  /// パスのパースされた値。
  final PathValue pathValue;

  /// The parsed value of the annotation.
  ///
  /// アノテーションのパースされた値。
  final ModelAnnotationValue annotationValue;

  ///　Generate documentation.
  ///
  /// ドキュメントを生成する。
  StringBuffer apply(StringBuffer buffer) {
    var path = pathValue.path.trimQuery().trimString("/");
    if (path.splitLength() % 2 != 0) {
      path = "$path/:doc_id";
    }
    if (classValue.deprecated.isNotEmpty) {
      buffer.writeln("## ~~${classValue.name}~~");
    } else {
      buffer.writeln("## ${classValue.name}");
    }
    buffer.writeln("`/$path`");
    if (classValue.deprecated.isNotEmpty) {
      buffer.writeln("");
      buffer.writeln("**(Deprecated)**: ${classValue.deprecated}");
    }
    buffer.writeln("");
    if (annotationValue.comment.isNotEmpty) {
      buffer.writeln(annotationValue.comment);
      buffer.writeln("");
    }
    buffer.writeln("### App schama");
    buffer.writeln("| Required | Name | Type | Searchable | Description |");
    buffer.writeln("|:--------:|:---- |:---- |:----------:|:----------- |");
    for (final param in classValue.parameters) {
      buffer = param.applyAppSchema(buffer);
    }
    buffer.writeln("");
    buffer.writeln("### NoSQL(Firestore) schama");
    buffer.writeln("| Required | Name | Type | Searchable | Description |");
    buffer.writeln("|:--------:|:---- |:---- |:----------:|:----------- |");
    for (final param in classValue.parameters) {
      buffer = param.applyNosqlSchema(buffer);
    }
    buffer.writeln("");
    buffer.writeln("### RDB schama");
    buffer.writeln("| Required | Name | Type | Searchable | Description |");
    buffer.writeln("|:--------:|:---- |:---- |:----------:|:----------- |");
    for (final param in classValue.parameters) {
      buffer = param.applyRDBSchema(buffer);
    }
    buffer.writeln("");
    buffer.writeln("");
    return buffer;
  }
}
