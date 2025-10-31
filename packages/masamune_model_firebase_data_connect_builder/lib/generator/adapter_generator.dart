part of "/masamune_model_firebase_data_connect_builder.dart";

/// Automatic generation of ModelAdapter for FirebaseDataConnect.
///
/// FirebaseDataConnect用のModelAdapterの自動生成を行います。
class AdapterGenerator
    extends GeneratorForAnnotation<FirebaseDataConnectAdapter> {
  /// Automatic generation of ModelAdapter for FirebaseDataConnect.
  ///
  /// FirebaseDataConnect用のModelAdapterの自動生成を行います。
  AdapterGenerator();

  static const _typeChecker = TypeChecker.typeNamed(FirebaseDataConnect);

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    try {
      if (element is! ClassElement2) {
        throw InvalidGenerationSourceError(
          "`@FirebaseDataConnectAdapter()` can only be used on classes.",
          element: element,
        );
      }

      final classValue = ClassValue(element);
      final schemas = <SchemaValue>[];
      final assets = buildStep.findAssets(Glob("**.dart"));
      await for (final asset in assets) {
        if (!await buildStep.resolver.isLibrary(asset)) {
          continue;
        }
        final lib = LibraryReader(
          await buildStep.resolver.libraryFor(
            asset,
            allowSyntaxErrors: false,
          ),
        );
        for (final annotatedElement in lib.annotatedWith(_typeChecker)) {
          final element = annotatedElement.element;
          if (element is! ClassElement2) {
            continue;
          }
          final modelAnnotationValue =
              ModelAnnotationValue.hasMatch(element, DocumentModelPath)
                  ? ModelAnnotationValue(element, DocumentModelPath)
                  : (ModelAnnotationValue.hasMatch(element, CollectionModelPath)
                      ? ModelAnnotationValue(element, CollectionModelPath)
                      : null);
          if (modelAnnotationValue == null) {
            continue;
          }
          schemas.add(
            SchemaValue(
              classValue: ClassValue(element),
              firebaseDataConnectAnnotationValue:
                  FirebaseDataConnectAnnotationValue(
                      element, FirebaseDataConnect),
              modelAnnotationValue: modelAnnotationValue,
            ),
          );
        }
      }
      schemas.sort((a, b) => a.classValue.name.compareTo(b.classValue.name));

      final generated = Library(
        (l) => l
          ..body.addAll(
            [
              ...adapterClass(classValue, schemas),
            ],
          ),
      );
      final emitter = DartEmitter();
      final code = generated.accept(emitter).toString();
      await _buildDartGenerator(schemas, buildStep);
      return DartFormatter(
        languageVersion: DartFormatter.latestLanguageVersion,
      ).format(
        code.isEmpty ? "// no code." : code,
      );
    } catch (e, stack) {
      // ignore: avoid_print
      print("${e.toString()}: ${stack.toString()}");
    }
    return "";
  }

  Future<void> _buildDartGenerator(
    List<SchemaValue> schemas,
    BuildStep buildStep,
  ) async {
    const command = "firebase";
    if (!await _isCommandAvailable(command)) {
      throw Exception(
        "The `firebase` command is not available. Please install with `npm install -g firebase-tools`.",
      );
    }
    final firebaseDir = Directory("${Directory.current.path}/firebase");
    if (!firebaseDir.existsSync()) {
      throw Exception(
        "There is no `firebase` directory. Create a `firebase` directory and run `firebase init` or edit `katana.yaml` and run `katana apply`.",
      );
    }
    final generateProcess = await Process.start(
      command,
      [
        "dataconnect:sdk:generate",
      ],
      runInShell: true,
      workingDirectory: "${Directory.current.path}/firebase",
      mode: ProcessStartMode.normal,
    );
    unawaited(
      // ignore: avoid_print
      generateProcess.stdout.transform(utf8.decoder).forEach(print),
    );
    await generateProcess.exitCode;
  }

  Future<bool> _isCommandAvailable(String command) async {
    try {
      final result = await Process.run("which", [command]);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }
}
