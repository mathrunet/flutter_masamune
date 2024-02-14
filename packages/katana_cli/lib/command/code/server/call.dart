part of "server.dart";

/// Create server code for FunctionCall.
///
/// FunctionCall用のサーバーコードを作成します。
class CodeServerCallCliCommand extends CliCodeCommand {
  /// Create server code for FunctionCall.
  ///
  /// FunctionCall用のサーバーコードを作成します。
  const CodeServerCallCliCommand();

  @override
  String get name => "call";

  @override
  String get prefix => "call";

  @override
  String get directory => "firebase/functions/src/functions";

  @override
  String get description =>
      "Create server code for FunctionCall in `$directory/(filepath).ts`. FunctionCall用のサーバーコードを`$directory/(filepath).ts`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code cache [path]\r\n",
      );
      return;
    }
    label("Create server code for FunctionCall in `$directory/$path.ts`.");
    final parentPath = path.parentPath();
    if (parentPath.isNotEmpty) {
      final parentDir = Directory("$directory/$parentPath");
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }
    }
    await generateDartCode("$directory/$path", path, ext: "ts");
    final parentDir = Directory("lib/functions");
    if (!parentDir.existsSync()) {
      await parentDir.create(recursive: true);
    }
    await const CodeServerCallFunctionsActionCliCode()
        .generateDartCode("lib/functions/$path", path);
  }

  @override
  String import(String path, String baseName, String className) {
    return """
/* eslint indent: off */
/* eslint max-len: off */
/* eslint @typescript-eslint/no-explicit-any: off */
import * as m from "@mathrunet/masamune";

""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/**
 * ${className.toPascalCase()}Call
 *
 * Create server code for FunctionCall.
 */
export class ${className.toPascalCase()}Call extends m.CallProcessFunctionBase {
    /**
     * @param {string} id
     * Describe the method names used in Functions.
     *
     * Functionsで利用されるメソッド名を記述します。
     */
    id = "${className.toSnakeCase()}_call";
    /**
     * Specify the actual contents of the process.
     *
     * 実際の処理の中身を指定します。
     *
     * @param {any} query
     * Query passed to Functions.
     *
     * Functionsに渡されたクエリ。
     *
     * @param {Record<string, any>} options
     * Options passed to Functions.
     *
     * Functionsに渡されたオプション。
     * 
     * @returns {Promise<Record<string, any>>}
     * Return the result of the process.
     * 
     * 処理の結果を返します。
     */
    async process(
      query: any,
      options: Record<string, any>
    ): Promise<{[key: string]: any}> {
        // TODO: Implement the process to be executed.
        return {};
    }
}

""";
  }
}

/// Generate Dart-side code corresponding to [CodeServerCallCliCommand].
///
/// [CodeServerCallCliCommand]に対応するDart側のコードを生成します。
class CodeServerCallFunctionsActionCliCode extends CliCode {
  /// Generate Dart-side code corresponding to [CodeServerCallCliCommand].
  ///
  /// [CodeServerCallCliCommand]に対応するDart側のコードを生成します。
  const CodeServerCallFunctionsActionCliCode();

  @override
  String get name => "main";

  @override
  String get prefix => "main";

  @override
  String get directory => "lib/functions";

  @override
  String get description => "";

  @override
  String import(String path, String baseName, String className) {
    return """
import 'package:masamune/masamune.dart';
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// [FunctionsAction] for calling `${className.toSnakeCase()}_call` in FirebaseFunctions.
///
/// FirebaseFunctionsの`${className.toSnakeCase()}_call`をコールするための[FunctionsAction]。
///
/// ```dart
/// final response = await appFunction.execute(${className.toPascalCase()}FunctionsAction());
/// ```
class ${className.toPascalCase()}FunctionsAction
    extends FunctionsAction<${className.toPascalCase()}FunctionsActionResponse> {
  /// [FunctionsAction] for calling `${className.toSnakeCase()}_call` in FirebaseFunctions.
  ///
  /// FirebaseFunctionsの`${className.toSnakeCase()}_call`をコールするための[FunctionsAction]。
  ///
  /// ```dart
  /// final response = await appFunction.execute(${className.toPascalCase()}FunctionsAction());
  /// ```
  const ${className.toPascalCase()}FunctionsAction();

  @override
  String get action => "${className.toSnakeCase()}_call";

  @override
  DynamicMap? toMap() {
    return {};
  }

  @override
  ${className.toPascalCase()}FunctionsActionResponse toResponse(DynamicMap map) {
    return const ${className.toPascalCase()}FunctionsActionResponse();
  }
}

/// [FunctionsActionResponse] that defines the response to [${className.toPascalCase()}FunctionsAction].
///
/// [${className.toPascalCase()}FunctionsAction]のレスポンスを定義する[FunctionsActionResponse]。
class ${className.toPascalCase()}FunctionsActionResponse extends FunctionsActionResponse {
  /// [FunctionsActionResponse] that defines the response to [${className.toPascalCase()}FunctionsAction].
  ///
  /// [${className.toPascalCase()}FunctionsAction]のレスポンスを定義する[FunctionsActionResponse]。
  const ${className.toPascalCase()}FunctionsActionResponse();
}
""";
  }
}
