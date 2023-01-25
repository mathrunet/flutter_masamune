// ignore_for_file: avoid_print

part of katana_model_openapi_builder;

/// Builder factory for automatic OpenAPI generation.
///
/// OpenAPIの自動生成を行うためのビルダーファクトリー。
Builder katanaModelOpenAPIBuilderFactory(BuilderOptions options) {
  return OpenApiCodeBuilder();
}

/// Builder for automatic OpenAPI generation.
///
/// OpenAPIの自動生成を行うためのビルダー。
class OpenApiCodeBuilder extends Builder {
  /// Builder for automatic OpenAPI generation.
  ///
  /// OpenAPIの自動生成を行うためのビルダー。
  OpenApiCodeBuilder();

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    try {
      final inputId = buildStep.inputId;
      final outputId = inputId.changeExtension(".dart");
      final source = await buildStep.readAsString(inputId);
      if (!inputId.pathSegments.last.endsWith(".openapi.yaml")) {
        return;
      }
      final inputIdBasename =
          inputId.pathSegments.last.replaceAll(".openapi.yaml", "");
      final api = _additionalComponentSchemas(
        _loadApiFromYaml(source),
      );

      final baseName = api.info!.extensions["x-dart-name"] as String? ??
          inputIdBasename.toPascalCase();
      final freezedPartFileName = AssetId(outputId.package, outputId.path)
          .changeExtension(".freezed.dart")
          .pathSegments
          .last;
      final partFileName = AssetId(outputId.package, outputId.path)
          .changeExtension(".g.dart")
          .pathSegments
          .last;

      final library = await OpenAPIGenerator(
        api,
        baseName,
        partFileName,
        freezedPartFileName,
      ).generate();

      final libraryOutput = _formatLibrary(
        library,
      );
      await buildStep.writeAsString(outputId, libraryOutput);
    } catch (e, stackTrace) {
      print(e.toString());
      print(stackTrace.toString());
    }
  }

  static String _formatLibrary(Library library) {
    final emitter = DartEmitter(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );
    final libraryOutput = DartFormatter().format(
      "// GENERATED CODE - DO NOT MODIFY BY HAND\n\n\n"
      "// ignore_for_file: prefer_initializing_formals, unnecessary_brace_in_string_interps, invalid_annotation_target, require_trailing_commas\n\n"
      "${library.accept(emitter)}\n\n",
    );
    return libraryOutput;
  }

  APIDocument _loadApiFromYaml(String yamlSource) {
    final tmp = loadYaml(yamlSource);
    final decoded = jsonDecode(jsonEncode(tmp)) as DynamicMap?;
    return APIDocument.fromMap(
      _filter(
        null,
        Map<String, dynamic>.from(decoded?.cast<String, dynamic>() ?? {}),
      ),
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".openapi.yaml": [".openapi.dart"]
      };
}
