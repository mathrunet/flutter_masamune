part of katana_cli.code.server;

/// Create server code for HTTP requests.
///
/// HTTPリクエスト用のサーバーコードを作成します。
class CodeServerRequestCliCommand extends CliCodeCommand {
  /// Create server code for HTTP requests.
  ///
  /// HTTPリクエスト用のサーバーコードを作成します。
  const CodeServerRequestCliCommand();

  @override
  String get name => "request";

  @override
  String get prefix => "request";

  @override
  String get directory => "firebase/functions/src/functions";

  @override
  String get description =>
      "Create server code for HTTP requests in `$directory/(filepath).ts`. HTTPリクエスト用のサーバーコードを`$directory/(filepath).ts`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code cache [path]\r\n",
      );
      return;
    }
    label("Create server code for HTTP requests in `$directory/$path.ts`.");
    final parentPath = path.parentPath();
    if (parentPath.isNotEmpty) {
      final parentDir = Directory("$directory/$parentPath");
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }
    }
    await generateDartCode("$directory/$path", path, ext: "ts");
  }

  @override
  String import(String path, String baseName, String className) {
    return """
/* eslint indent: off */
import * as m from "@mathrunet/masamune";
import {Response, Request} from "firebase-functions";

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
 * ${className.toPascalCase()}Request
 *
 * Create server code for HTTP requests.
 */
export class ${className.toPascalCase()}Request extends m.RequestProcessFunctionBase {
    /**
     * @param {string} id
     * Describe the method names used in Functions.
     *
     * Functionsで利用されるメソッド名を記述します。
     */
    id = "${className.toSnakeCase()}_request";
    /**
     * Specify the actual contents of the process.
     *
     * 実際の処理の中身を指定します。
     *
     * @param {Request} reqest
     * Request passed to Functions.
     *
     * Functionsに渡されたRequest。
     *
     * @param {Response<any>} response
     * Response passed to Functions.
     *
     * Functionsに渡されたResponse。
     *
     * @param {Record<string, any>} options
     * Options passed to Functions.
     *
     * Functionsに渡されたオプション。
     */
    async process(reqest: Request, response: Response<any>, options: Record<string, any>): Promise<void> {
        // TODO: Implement the process to be executed.
    }
}

""";
  }
}
