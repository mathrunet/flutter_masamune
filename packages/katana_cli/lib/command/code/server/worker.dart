part of "server.dart";

/// Create server code for Cloudflare Workers.
class CodeServerWorkerCliCommand extends CliCodeCommand {
  /// Create server code for Cloudflare Workers.
  const CodeServerWorkerCliCommand();

  @override
  String get name => "worker";

  @override
  String get prefix => "worker";

  @override
  String get directory => "cloudflare/src/workers";

  @override
  String get description =>
      "Create server code for Cloudflare Workers in `$directory/(filepath).ts` and register it in `cloudflare/src/edge.ts` (or `cloudflare/src/region.ts` with `--region`). Cloudflare Workers用のサーバーコードを`$directory/(filepath).ts`に作成し、`cloudflare/src/edge.ts`（`--region`指定時は`cloudflare/src/region.ts`）に登録します。";

  @override
  String? get example => "katana code server worker [function_name] [--region]";

  @override
  Future<void> exec(ExecContext context) async {
    final args = context.args.where((arg) => !arg.startsWith("--")).toList();
    final region = context.args.contains("--region");
    final path = args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code server worker [path] [--region]\r\n",
      );
      return;
    }
    if (!validateFilePath(path)) {
      error(
        "Invalid path: $path. Please enter a valid path according to the following command.\r\nkatana code server worker [path] [--region]\r\n",
      );
      return;
    }
    if (region && !_checkCloudflareRegionWorker(context)) {
      return;
    }
    label(
        "Create server code for Cloudflare Workers in `$directory/$path.ts`.");
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
    await CodeServerCloudflareFunctionsActionCliCode(region: region)
        .generateDartCode("lib/functions/$path", path);
    await _registerCloudflareWorker(
      path: path,
      className: "${_cloudflareClassName(path)}Worker",
      region: region,
    );
  }

  @override
  String import(String path, String baseName, String className) {
    return """
/* eslint indent: off */
/* eslint max-len: off */
/* eslint @typescript-eslint/no-explicit-any: off */
import * as mc from "@mathrunet/masamune_cloudflare";
import { Hono } from "hono";
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
 * ${className.toPascalCase()}Worker
 *
 * Create a server code for Cloudflare Workers.
 */
export class ${className.toPascalCase()}Worker extends mc.RequestProcessWorkdersBase {
    /**
     * @param {string} path
     * Describe the path names used in Workers.
     *
     * Workersで利用されるパス名を記述します。
     */
    path = "/${className.toSnakeCase()}";

    /**
     * Specify the actual contents of the process.
     *
     * 実際の処理の中身を指定します。
     *
     * @param {Hono} hono
     * Hono object passed to Workers.
     *
     * Workersに渡されたHonoオブジェクト。
     * 
     * @return {Hono}
     * Return the processed Hono object.
     * 
     * 処理後のHonoオブジェクトを返します。
     */
    process(
        hono: Hono,
    ): Hono {

        /// You will comment out and implement the GET process.
        ///
        /// メソッド名をコメントアウトしてGETの処理を記載します。
        // hono.get("/", async (c) => {
        //     return c.json({ success: true });
        // });

        /// You will comment out and implement the POST process.
        ///
        /// メソッド名をコメントアウトしてPOSTの処理を記載します。
        // hono.post("/", async (c) => {
        //     return c.json({ success: true });
        // });

        /// You will comment out and implement the PUT process.
        ///
        /// メソッド名をコメントアウトしてPUTの処理を記載します。
        // hono.put("/", async (c) => {
        //     return c.json({ success: true });
        // });

        /// You will comment out and implement the DELETE process.
        ///
        /// メソッド名をコメントアウトしてDELETEの処理を記載します。
        // hono.delete("/", async (c) => {
        //     return c.json({ success: true });
        // });

        return hono;
    }
}
""";
  }
}

/// Create a FunctionsAction for Cloudflare Workers.
class CodeServerCloudflareFunctionsActionCliCode extends CliCode {
  /// Create a FunctionsAction for Cloudflare Workers.
  ///
  /// If [region] is `true`, the action targets the region Worker.
  const CodeServerCloudflareFunctionsActionCliCode({this.region = false});

  /// Whether the action targets the region Worker.
  final bool region;

  @override
  String get name => "cloudflare_functions_action";

  @override
  String get prefix => "cloudflareFunctionsAction";

  @override
  String get directory => "lib/functions";

  @override
  String get description =>
      "Create a Cloudflare FunctionsAction in `$directory/(filepath).dart`.";

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
/// [FunctionsAction] for calling `${className.toSnakeCase()}` in Cloudflare Workers.
///
/// Cloudflare Workersの`${className.toSnakeCase()}`をコールするための[FunctionsAction]。
///
/// ```dart
/// final response = await appFunction.execute(${className.toPascalCase()}FunctionsAction());
/// ```
class ${className.toPascalCase()}FunctionsAction
    extends FunctionsAction<${className.toPascalCase()}FunctionsActionResponse> {
  /// [FunctionsAction] for calling `${className.toSnakeCase()}` in Cloudflare Workers.
  ///
  /// Cloudflare Workersの`${className.toSnakeCase()}`をコールするための[FunctionsAction]。
  ///
  /// ```dart
  /// final response = await appFunction.execute(${className.toPascalCase()}FunctionsAction());
  /// ```
  const ${className.toPascalCase()}FunctionsAction();

  @override
  String get action => "${className.toSnakeCase()}";
${region ? """
  @override
  String? get target => "region";
""" : ""}
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

/// Returns the class name prefix generated from [path].
String _cloudflareClassName(String path) {
  return path.split("/").distinct().join("_").toPascalCase();
}

/// Checks that the region Worker is enabled and `cloudflare/src/region.ts` exists.
///
/// region Workerが有効で`cloudflare/src/region.ts`が存在するか確認します。
bool _checkCloudflareRegionWorker(ExecContext context) {
  if (!isCloudflareRegionWorkerEnabled(context.yaml)) {
    error(
      "`--region` requires [cloudflare]->[workers]->[region]->[enable] to be `true` in `katana.yaml`. `--region`を利用するには`katana.yaml`の[cloudflare]->[workers]->[region]->[enable]を`true`にしてください。\r\n",
    );
    return false;
  }
  if (!File(cloudflareRegionEntryPath).existsSync()) {
    error(
      "The file `$cloudflareRegionEntryPath` does not exist. Run `katana apply` first. `$cloudflareRegionEntryPath`が存在しません。先に`katana apply`を実行してください。\r\n",
    );
    return false;
  }
  return true;
}

/// Registers the generated Worker in `edge.ts` or `region.ts`.
///
/// 生成したWorkerを`edge.ts`または`region.ts`に登録します。
Future<void> _registerCloudflareWorker({
  required String path,
  required String className,
  required bool region,
}) async {
  final entry = region ? cloudflareRegionEntryPath : cloudflareEdgeEntryPath;
  if (!region && !File(entry).existsSync()) {
    label(
      "WARNING: `$entry` does not exist, so `$className` was not registered. Register it manually after `katana apply`. `$entry`が存在しないため`$className`を登録しませんでした。`katana apply`後に手動で登録してください。",
    );
    return;
  }
  await registerCloudflareWorker(
    entry: entry,
    className: className,
    importPath: "./workers/$path",
  );
}
