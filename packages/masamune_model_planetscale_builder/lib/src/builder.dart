part of '/masamune_model_planetscale_builder.dart';

/// Builder to generate code for Planetscale.
///
/// Planetscale用のコードをジェネレートするためのビルダー。
Builder masamuneModelPlanetscaleBuilderFactory(BuilderOptions options) {
  return _PlanetscaleBuilder();
}

class _PlanetscaleBuilder extends Builder {
  _PlanetscaleBuilder();

  static const TypeChecker _planetScaleTypeChecker =
      TypeChecker.fromRuntime(PlanetScale);
  static const _freezedChecker = TypeChecker.fromRuntime(Freezed);
  static const _collectionModelPathChecker =
      TypeChecker.fromRuntime(CollectionModelPath);
  static const _documentModelPathChecker =
      TypeChecker.fromRuntime(DocumentModelPath);
  static final _pathRegExp = RegExp(r"^[a-zA-Z0-9_/-]+$");

  Future<void> _buildForTypescriptModel(
    String pathValue,
    ClassValue classValue,
    PlanetScaleAnnotationValue annotationValue,
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final fileName = "${classValue.name.toSnakeCase()}.model.ts";
    final outputDir = Directory(
      "${_path(buildStep.inputId)}${annotationValue.modelDirPath}",
    );
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    final outputFile = File("${outputDir.path}/$fileName");
    final buffer = StringBuffer();
    buffer.writeln("import * as m from \"@mathrunet/masamune\";");
    buffer.writeln("import {Prisma} from \"@prisma/client\";");
    buffer.writeln();
    buffer.writeln(
        "export class ${classValue.name.toPascalCase()} extends m.SqlApiModelBase {");
    buffer.writeln("    constructor(");
    for (final param in classValue.parameters) {
      buffer.writeln("        ${param.jsonKey}: ${param.toTypescriptType()},");
    }
    buffer.writeln("    ) {");
    for (final param in classValue.parameters) {
      buffer.writeln("        this.${param.jsonKey} = ${param.jsonKey};");
    }
    buffer.writeln("    }");
    buffer.writeln();
    buffer.writeln("    public static fromJson = (json: any) => {");
    buffer.writeln("        const {");
    for (final param in classValue.parameters) {
      buffer.writeln("            ${param.jsonKey},");
    }
    buffer.writeln("        } = Object.assign({}, json);");
    buffer.writeln();
    buffer.writeln("        return new ${classValue.name.toPascalCase()}(");
    for (final param in classValue.parameters) {
      buffer.writeln("            ${param.jsonKey},");
    }
    buffer.writeln("        );");
    buffer.writeln("    }");
    buffer.writeln();
    for (final param in classValue.parameters) {
      buffer.writeln(
          "    public readonly ${param.jsonKey}: ${param.toTypescriptType()};");
    }
    buffer.writeln();
    buffer.writeln("    toJson(): { [key: string]: any; } {");
    buffer.writeln("        return {");
    for (final param in classValue.parameters) {
      buffer.writeln("    ${param.jsonKey}: this.${param.jsonKey},");
    }
    buffer.writeln("        };");
    buffer.writeln("    }");
    buffer.writeln("}");

    await outputFile.writeAsString(buffer.toString());
  }

  Future<void> _buildForTypescriptApi(
    String pathValue,
    ClassValue classValue,
    PlanetScaleAnnotationValue annotationValue,
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final fileName = "${classValue.name.toSnakeCase()}.api.ts";
    final outputDir = Directory(
      "${_path(buildStep.inputId)}${annotationValue.modelDirPath}",
    );
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    final outputFile = File("${outputDir.path}/$fileName");
    final buffer = StringBuffer();
    buffer.writeln("import * as m from \"@mathrunet/masamune\";");
    buffer.writeln("import {Prisma,PrismaClient} from \"@prisma/client\";");
    buffer.writeln(
        "import {${classValue.name.toPascalCase()}Model} from \"./${classValue.name.toSnakeCase()}.model\";");
    buffer.writeln();
    buffer.writeln(
        "export class ${classValue.name.toPascalCase()}Api extends m.SqlApiBase<${classValue.name.toPascalCase()}> {");
    buffer.writeln("    table: string = \"${pathValue.toSnakeCase()}\"");
    buffer.writeln(
        "    get(where: { [key: string]: any; }[]): Promise<${classValue.name.toPascalCase()}[]> {");
    buffer.writeln("    }");
    buffer.writeln(
        "    count(where: { [key: string]: any; }[]): Promise<number> {");
    buffer.writeln("    }");

    buffer.writeln(
        "    post(value: { [key: string]: any; }, where: { [key: string]: any; }[]): Promise<${classValue.name.toPascalCase()}> {");
    buffer.writeln("    }");
    buffer.writeln(
        "    put(value: { [key: string]: any; }, where: { [key: string]: any; }[]): Promise<${classValue.name.toPascalCase()}> {");
    buffer.writeln("    }");
    buffer.writeln(
        "    delete(where: { [key: string]: any; }[]): Promise<void> {");
    buffer.writeln("    }");
    buffer.writeln("}");

    await outputFile.writeAsString(buffer.toString());
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final resolver = buildStep.resolver;

    if (!await resolver.isLibrary(buildStep.inputId)) {
      return;
    }

    final library = await buildStep.resolver.libraryFor(buildStep.inputId);
    final libraryReader = LibraryReader(library);
    for (final annotatedElement
        in libraryReader.annotatedWith(_planetScaleTypeChecker)) {
      final element = annotatedElement.element;
      if (!element.library!.isNonNullableByDefault) {
        throw InvalidGenerationSourceError(
          "Generator cannot target libraries that have not been migrated to "
          "null-safety.",
          element: element,
        );
      }

      if (element is! ClassElement) {
        throw InvalidGenerationSourceError(
          "`@PlanetScale()` can only be used on classes.",
          element: element,
        );
      }
      if (!_freezedChecker.hasAnnotationOfExact(element)) {
        throw InvalidGenerationSourceError(
          "The `@freezed` annotation is required to use `@CollectionModelPath()` or `@DocumentModelPath()`.",
          element: element,
        );
      }

      if (!_collectionModelPathChecker.hasAnnotationOfExact(element) &&
          !_documentModelPathChecker.hasAnnotationOfExact(element)) {
        throw InvalidGenerationSourceError(
          "The `@CollectionModelPath` or `@DocumentModelPath` annotation is required to use `@PlanetScale()`.",
          element: element,
        );
      }
      final classValue = ClassValue(element);
      final annotationValue = PlanetScaleAnnotationValue(element, PlanetScale);
      final pathValue = annotatedElement.annotation
          .read("path")
          .stringValue
          .trimString("/")
          .replaceAll("/", "_");
      if (!_pathRegExp.hasMatch(pathValue)) {
        throw InvalidGenerationSourceError(
          "Paths cannot contain variables or special characters.: $pathValue",
          element: element,
        );
      }
      await _buildForTypescriptModel(
        pathValue,
        classValue,
        annotationValue,
        element,
        annotatedElement.annotation,
        buildStep,
      );
      await _buildForTypescriptApi(
        pathValue,
        classValue,
        annotationValue,
        element,
        annotatedElement.annotation,
        buildStep,
      );
    }
  }

  String _path(AssetId from) {
    final regExp = RegExp("^(.*)lib");
    final match = regExp.firstMatch(from.path);
    if (match == null) {
      return "";
    }
    return match.group(1) ?? "";
  }

  @override
  final Map<String, List<String>> buildExtensions = {
    ".dart": [".scheme", ".ts"]
  };
}
