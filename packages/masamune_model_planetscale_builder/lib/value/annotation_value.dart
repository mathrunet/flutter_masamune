part of '/masamune_model_planetscale_builder.dart';

const _kDefaultModelDirPath = "firebase/functions/src/models";
const _kDefaultPrismaSchemaFilePath = "firebase/functions/prisma/schema.prisma";

/// Class for storing annotation values.
///
/// Specify the class element in [element] and the annotation type in [annotationType].
///
/// アノテーションの値を保存するためのクラス。
///
/// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
class PlanetScaleAnnotationValue {
  /// Class for storing annotation values.
  ///
  /// Specify the class element in [element] and the annotation type in [annotationType].
  ///
  /// アノテーションの値を保存するためのクラス。
  ///
  /// [element]にクラスエレメント、[annotationType]にアノテーションのタイプを指定します。
  PlanetScaleAnnotationValue(this.element, this.annotationType) {
    final matcher = TypeChecker.fromRuntime(annotationType);

    for (final meta in element.metadata) {
      final obj = meta.computeConstantValue()!;
      if (matcher.isExactlyType(obj.type!)) {
        modelDirPath = obj.getField("modelDirPath")?.toStringValue() ??
            _kDefaultModelDirPath;
        prismaSchemaFilePath =
            obj.getField("prismaSchemaFilePath")?.toStringValue() ??
                _kDefaultPrismaSchemaFilePath;
        return;
      }
    }
    modelDirPath = _kDefaultModelDirPath;
    prismaSchemaFilePath = _kDefaultPrismaSchemaFilePath;
  }

  /// Class Element.
  ///
  /// クラスエレメント。
  final ClassElement element;

  /// Annotation Type
  ///
  /// アノテーションのタイプ
  final Type annotationType;

  /// Path of the model directory.
  ///
  /// モデルディレクトリのパス。
  late final String modelDirPath;

  /// Path of the Prisma schema file.
  ///
  /// prismaスキーマファイルのパス。
  late final String prismaSchemaFilePath;

  @override
  String toString() {
    return "$runtimeType()";
  }
}
