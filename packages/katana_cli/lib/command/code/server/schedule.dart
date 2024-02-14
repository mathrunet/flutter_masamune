part of "server.dart";

/// Create a server code for the scheduler.
///
/// スケジューラー用のサーバーコードを作成します。
class CodeServerScheduleCliCommand extends CliCodeCommand {
  /// Create a server code for the scheduler.
  ///
  /// スケジューラー用のサーバーコードを作成します。
  const CodeServerScheduleCliCommand();

  @override
  String get name => "schedule";

  @override
  String get prefix => "schedule";

  @override
  String get directory => "firebase/functions/src/functions";

  @override
  String get description =>
      "Create a server code for the scheduler in `$directory/(filepath).ts`. スケジューラー用のサーバーコードを`$directory/(filepath).ts`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code cache [path]\r\n",
      );
      return;
    }
    label("Create a server code for the scheduler in `$directory/$path.ts`.");
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
 * ${className.toPascalCase()}Schedule
 *
 * Create a server code for the scheduler.
 */
export class ${className.toPascalCase()}Schedule extends m.ScheduleProcessFunctionBase {
    /**
     * @param {string} id
     * Describe the method names used in Functions.
     *
     * Functionsで利用されるメソッド名を記述します。
     */
    id = "${className.toSnakeCase()}_schedule";
    /**
     * @param {string} schedule
     * Specify the schedule to execute the process in cron format.
     *
     * 処理を実行するスケジュールをcron形式で指定します。
     *
     * https://firebase.google.com/docs/functions/schedule-functions
     */
    schedule = "every 60 minutes";
    /**
     * Specify the actual contents of the process.
     *
     * 実際の処理の中身を指定します。
     *
     * @param {Record<string, any>} options
     * Options passed to Functions.
     *
     * Functionsに渡されたオプション。
     */
    async process(options: Record<string, any>): Promise<void> {
        // TODO: Implement the process to be executed.
    }
}

""";
  }
}
