part of "code.dart";

/// Create server code for Functions.
///
/// Functions用のサーバーコードを作成します。
class CodeFunctionCliCommand extends CliCodeCommand {
  /// Create server code for Functions.
  ///
  /// Functions用のサーバーコードを作成します。
  const CodeFunctionCliCommand();

  @override
  String get name => "function";

  @override
  String get prefix => "function";

  @override
  String get directory => "lib/functions";

  @override
  String get description =>
      "Create a FunctionsAction to execute a Rest API in `$directory/(filepath).dart`. RestApiを実行するためのFunctionsActionを`$directory/(filepath).dart`に作成します。";

  @override
  String? get example => "katana code function [function_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code cache [path]\r\n",
      );
      return;
    }
    await generateDartCode("$directory/$path", path, ext: "dart");
  }

  @override
  String import(String path, String baseName, String className) {
    return """
import "package:masamune/masamune.dart";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
/// [FunctionsAction] for executing RestApi.
///
/// RestApiを実行するための[FunctionsAction]。
///
/// ```dart
/// final response = await appFunction.execute(${className.toPascalCase()}FunctionsAction());
/// ```
class ${className.toPascalCase()}FunctionsAction
    extends RestApiFunctionsAction<${className.toPascalCase()}FunctionsActionResponse> {
  /// [FunctionsAction] for executing RestApi.
  ///
  /// RestApiを実行するための[FunctionsAction]。[FunctionsAction]。
  ///
  /// ```dart
  /// final response = await appFunction.execute(${className.toPascalCase()}FunctionsAction());
  /// ```
  const ${className.toPascalCase()}FunctionsAction();

  @override
  String get description => "Execute ${className.toPascalCase()}.";

  @override
  ApiMethod get method => ApiMethod.post;

  @override
  String get path => "${className.toSnakeCase()}";

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
class ${className.toPascalCase()}FunctionsActionResponse extends RestApiFunctionsActionResponse {
  /// [FunctionsActionResponse] that defines the response to [${className.toPascalCase()}FunctionsAction].
  ///
  /// [${className.toPascalCase()}FunctionsAction]のレスポンスを定義する[FunctionsActionResponse]。
  const ${className.toPascalCase()}FunctionsActionResponse();
}
""";
  }
}
