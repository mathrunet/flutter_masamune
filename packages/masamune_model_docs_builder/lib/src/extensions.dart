part of '/masamune_model_docs_builder.dart';

extension on ParamaterValue {
  String _name({bool app = false}) {
    final name = app ? (jsonKey ?? this.name) : this.name;
    if (this.deprecated.isNotEmpty) {
      return "~~$name~~";
    }
    return "**$name**";
  }

  String? get _comment {
    var comment = this.comment;
    if (this.deprecated.isNotEmpty) {
      if (comment.isNotEmpty) {
        comment = "$comment<br />**Deprecated**: ${this.deprecated}";
      } else {
        comment = "**Deprecated**: ${this.deprecated}";
      }
    }
    return comment;
  }

  StringBuffer applyAppSchema(StringBuffer buffer) {
    if (type.isModelRef && reference != null) {
      buffer.writeln(
        "| ${required ? "✅" : ""} | ${_name(app: true)} | ${reference?.toAppTypeCode()} | ${isSearchable ? "✅" : ""} | ${_comment?.replaceBr() ?? ""} |",
      );
    } else {
      buffer.writeln(
        "| ${required ? "✅" : ""} | ${_name(app: true)} | ${type.toAppType()} | ${isSearchable ? "✅" : ""} | ${_comment?.replaceBr() ?? ""} |",
      );
    }
    return buffer;
  }

  StringBuffer applyNosqlSchema(StringBuffer buffer) {
    if (reference != null) {
      buffer.writeln(
        "| ${required ? "✅" : ""} | ${_name(app: false)} | ${reference?.toNosqlTypeCode()} | ${isSearchable ? "✅" : ""} | ${comment?.replaceBr() ?? ""} |",
      );
    } else if (isJsonSerializable) {
      if (type.isDartCoreList ||
          type.isDartCoreSet ||
          type.isDartCoreIterable) {
        buffer.writeln(
          "| ${required ? "✅" : ""} | ${_name(app: false)} | ${DocsType.list.nosql} | ${isSearchable ? "✅" : ""} | ${_comment?.replaceBr() ?? ""} |",
        );
      } else {
        buffer.writeln(
          "| ${required ? "✅" : ""} | ${_name(app: false)} | ${DocsType.map.nosql} | ${isSearchable ? "✅" : ""} | ${_comment?.replaceBr() ?? ""} |",
        );
      }
    } else {
      final subType = type.toNosqlSubType();
      buffer.writeln(
        "| ${required ? "✅" : ""} | ${_name(app: false)} | ${type.toNosqlType()} | ${isSearchable ? "✅" : ""} | ${_comment?.replaceBr() ?? ""} |",
      );
      if (subType != null) {
        buffer.writeln(
          "| ${required ? "✅" : ""} | ${_name(app: false)} | $subType | ${isSearchable ? "✅" : ""} | ${_comment?.replaceBr() ?? ""} |",
        );
      }
    }
    return buffer;
  }

  StringBuffer applyRDBSchema(StringBuffer buffer) {
    if (reference != null) {
      buffer.writeln(
        "| ${required ? "✅" : ""} | ${_name(app: false)} | ${reference?.toRDBTypeCode()} | ${isSearchable ? "✅" : ""} | ${_comment?.replaceBr() ?? ""} |",
      );
    } else if (isJsonSerializable) {
      buffer.writeln(
        "| ${required ? "✅" : ""} | ${_name(app: false)} | json | ${isSearchable ? "✅" : ""} | ${_comment?.replaceBr() ?? ""} |",
      );
    } else {
      buffer.writeln(
        "| ${required ? "✅" : ""} | ${_name(app: false)} | ${type.toRDBType()} | ${isSearchable ? "✅" : ""} | ${_comment?.replaceBr() ?? ""} |",
      );
    }
    return buffer;
  }
}

extension on ReferenceValue {
  String toAppTypeCode() {
    final typeString = valueType.trimString("?");
    switch (type) {
      case ReferenceValueType.single:
        return "[$typeString](#$typeString)";
      case ReferenceValueType.list:
        return "List<[$typeString](#$typeString)>";
      case ReferenceValueType.map:
        return "Map<String, [$typeString](#$typeString)>";
    }
  }

  String toNosqlTypeCode() {
    final typeString = valueType.trimString("?");
    switch (type) {
      case ReferenceValueType.single:
        return "[reference](#$typeString)";
      case ReferenceValueType.list:
        return "Array<[reference](#$typeString)>";
      case ReferenceValueType.map:
        return "Map<[reference](#$typeString)>";
    }
  }

  String toRDBTypeCode() {
    final typeString = valueType.trimString("?");
    return "[json](#$typeString)";
  }
}

extension _InterfaceTypeExtensions on InterfaceType {
  String toAppType() {
    final nullable = isNullable ? "?" : "";
    if (isDartCoreString) {
      return "${DocsType.string.app}$nullable";
    } else if (isDartCoreBool) {
      return "${DocsType.bool.app}$nullable";
    } else if (isDartCoreInt) {
      return "${DocsType.int.app}$nullable";
    } else if (isDartCoreDouble) {
      return "${DocsType.double.app}$nullable";
    } else if (isDartCoreList) {
      return "${DocsType.list.app}$nullable";
    } else if (isDartCoreSet) {
      return "${DocsType.list.app}$nullable";
    } else if (isDartCoreMap) {
      return "${DocsType.map.app}$nullable";
    } else if (isDartCoreEnum) {
      return "${toString().trimString("?")}$nullable";
    } else if (isModelRef) {
      return "${DocsModelFieldValueType.modelRef.app}$nullable";
    } else if (isModelCounter) {
      return "${DocsModelFieldValueType.modelCounter.app}$nullable";
    } else if (isModelTimestamp) {
      return "${DocsModelFieldValueType.modelTimestamp.app}$nullable";
    } else if (isModelDate) {
      return "${DocsModelFieldValueType.modelDate.app}$nullable";
    } else if (isModelSearch) {
      return "${DocsModelFieldValueType.modelSearch.app}$nullable";
    } else if (isModelToken) {
      return "${DocsModelFieldValueType.modelToken.app}$nullable";
    } else if (isModelUri) {
      return "${DocsModelFieldValueType.modelUri.app}$nullable";
    } else if (isModelImageUri) {
      return "${DocsModelFieldValueType.modelImageUri.app}$nullable";
    } else if (isModelVideoUri) {
      return "${DocsModelFieldValueType.modelVideoUri.app}$nullable";
    } else if (isModelGeoValue) {
      return "${DocsModelFieldValueType.modelGeoValue.app}$nullable";
    } else if (isModelLocale) {
      return "${DocsModelFieldValueType.modelLocale.app}$nullable";
    } else if (isModelLocalizedValue) {
      return "${DocsModelFieldValueType.modelLocalizedValue.app}$nullable";
    } else if (isModelCommand) {
      return "${DocsModelFieldValueType.modelCommand.app}$nullable";
    }
    return "";
  }

  String toNosqlType() {
    if (isDartCoreString) {
      return DocsType.string.nosql;
    } else if (isDartCoreBool) {
      return DocsType.bool.nosql;
    } else if (isDartCoreInt) {
      return DocsType.int.nosql;
    } else if (isDartCoreDouble) {
      return DocsType.double.nosql;
    } else if (isDartCoreList) {
      return DocsType.list.nosql;
    } else if (isDartCoreSet) {
      return DocsType.list.nosql;
    } else if (isDartCoreMap) {
      return DocsType.map.nosql;
    } else if (isDartCoreEnum) {
      return toString().trimString("?");
    } else if (isModelRef) {
      return DocsModelFieldValueType.modelRef.nosql;
    } else if (isModelCounter) {
      return DocsModelFieldValueType.modelCounter.nosql;
    } else if (isModelTimestamp) {
      return DocsModelFieldValueType.modelTimestamp.nosql;
    } else if (isModelDate) {
      return DocsModelFieldValueType.modelDate.nosql;
    } else if (isModelSearch) {
      return DocsModelFieldValueType.modelSearch.nosql;
    } else if (isModelToken) {
      return DocsModelFieldValueType.modelToken.nosql;
    } else if (isModelUri) {
      return DocsModelFieldValueType.modelUri.nosql;
    } else if (isModelImageUri) {
      return DocsModelFieldValueType.modelImageUri.nosql;
    } else if (isModelVideoUri) {
      return DocsModelFieldValueType.modelVideoUri.nosql;
    } else if (isModelGeoValue) {
      return DocsModelFieldValueType.modelGeoValue.nosql;
    } else if (isModelLocale) {
      return DocsModelFieldValueType.modelLocale.nosql;
    } else if (isModelLocalizedValue) {
      return DocsModelFieldValueType.modelLocalizedValue.nosql;
    } else if (isModelCommand) {
      return DocsModelFieldValueType.modelCommand.nosql;
    }
    return "";
  }

  String? toNosqlSubType() {
    if (isDartCoreString) {
      return null;
    } else if (isDartCoreBool) {
      return null;
    } else if (isDartCoreInt) {
      return null;
    } else if (isDartCoreDouble) {
      return null;
    } else if (isDartCoreList) {
      return null;
    } else if (isDartCoreSet) {
      return null;
    } else if (isDartCoreMap) {
      return null;
    } else if (isDartCoreEnum) {
      return null;
    } else if (isModelRef) {
      return DocsModelFieldValueType.modelRef.subNosql;
    } else if (isModelCounter) {
      return DocsModelFieldValueType.modelCounter.subNosql;
    } else if (isModelTimestamp) {
      return DocsModelFieldValueType.modelTimestamp.subNosql;
    } else if (isModelDate) {
      return DocsModelFieldValueType.modelDate.subNosql;
    } else if (isModelSearch) {
      return DocsModelFieldValueType.modelSearch.subNosql;
    } else if (isModelToken) {
      return DocsModelFieldValueType.modelToken.subNosql;
    } else if (isModelUri) {
      return DocsModelFieldValueType.modelUri.subNosql;
    } else if (isModelImageUri) {
      return DocsModelFieldValueType.modelImageUri.subNosql;
    } else if (isModelVideoUri) {
      return DocsModelFieldValueType.modelVideoUri.subNosql;
    } else if (isModelGeoValue) {
      return DocsModelFieldValueType.modelGeoValue.subNosql;
    } else if (isModelLocale) {
      return DocsModelFieldValueType.modelLocale.subNosql;
    } else if (isModelLocalizedValue) {
      return DocsModelFieldValueType.modelLocalizedValue.subNosql;
    } else if (isModelCommand) {
      return DocsModelFieldValueType.modelCommand.subNosql;
    }
    return "";
  }

  String toRDBType() {
    if (isDartCoreString) {
      return DocsType.string.rdb;
    } else if (isDartCoreBool) {
      return DocsType.bool.rdb;
    } else if (isDartCoreInt) {
      return DocsType.int.rdb;
    } else if (isDartCoreDouble) {
      return DocsType.double.rdb;
    } else if (isDartCoreList) {
      return DocsType.list.rdb;
    } else if (isDartCoreSet) {
      return DocsType.list.rdb;
    } else if (isDartCoreMap) {
      return DocsType.map.rdb;
    } else if (isDartCoreEnum) {
      return toString().trimString("?");
    } else if (isModelRef) {
      return DocsModelFieldValueType.modelRef.rdb;
    } else if (isModelCounter) {
      return DocsModelFieldValueType.modelCounter.rdb;
    } else if (isModelTimestamp) {
      return DocsModelFieldValueType.modelTimestamp.rdb;
    } else if (isModelDate) {
      return DocsModelFieldValueType.modelDate.rdb;
    } else if (isModelSearch) {
      return DocsModelFieldValueType.modelSearch.rdb;
    } else if (isModelToken) {
      return DocsModelFieldValueType.modelToken.rdb;
    } else if (isModelUri) {
      return DocsModelFieldValueType.modelUri.rdb;
    } else if (isModelImageUri) {
      return DocsModelFieldValueType.modelImageUri.rdb;
    } else if (isModelVideoUri) {
      return DocsModelFieldValueType.modelVideoUri.rdb;
    } else if (isModelGeoValue) {
      return DocsModelFieldValueType.modelGeoValue.rdb;
    } else if (isModelLocale) {
      return DocsModelFieldValueType.modelLocale.rdb;
    } else if (isModelLocalizedValue) {
      return DocsModelFieldValueType.modelLocalizedValue.rdb;
    } else if (isModelCommand) {
      return DocsModelFieldValueType.modelCommand.rdb;
    }
    return "";
  }
}

extension on String {
  String replaceBr() {
    return replaceAll("\r\n", "\n")
        .replaceAll("\r", "\n")
        .replaceAll("\n", "<br />");
  }
}
