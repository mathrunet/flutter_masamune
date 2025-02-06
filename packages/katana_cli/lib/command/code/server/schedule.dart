part of "server.dart";

/// Create a server code for the scheduler.
///
/// スケジューラー用のサーバーコードを作成します。
class CodeServerScheduleCliCommand extends CliTestableCodeCommand {
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
  String get testDirectory => "firebase/functions/test";

  @override
  String get description =>
      "Create a server code for the scheduler in `$directory/(filepath).ts`. スケジューラー用のサーバーコードを`$directory/(filepath).ts`に作成します。";

  @override
  String? get example => "katana code server schedule [function_name]";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code cache [path]\r\n",
      );
      return;
    }
    label("Retrieve firebase project ID");
    final firebasercFile = File("firebase/.firebaserc");
    if (!firebasercFile.existsSync()) {
      error("Firebase project ID is not found.");
      return;
    }
    final firebaserc = await firebasercFile.readAsString();
    final json = jsonDecodeAsMap(firebaserc);
    final projectId = json.getAsMap("projects").get("default", "");
    label("Create a server code for the scheduler in `$directory/$path.ts`.");
    final parentPath = path.parentPath();
    if (parentPath.isNotEmpty) {
      final parentDir = Directory("$directory/$parentPath");
      if (!parentDir.existsSync()) {
        await parentDir.create(recursive: true);
      }
    }
    await generateDartCode("$directory/$path", path, ext: "ts");
    await generateDartTestCode(
      "$testDirectory/$path",
      path,
      ext: "test.ts",
      filter: (text) {
        return text.replaceAll(r"${testProjectId}", projectId);
      },
    );
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
     */
    async process(): Promise<void> {
        // TODO: Implement the process to be executed.
    }
}

""";
  }

  @override
  String test(String path, String baseName, String className) {
    return """
/**
 * Test for ${className.toPascalCase()} functions.
 */
import * as admin from 'firebase-admin';

/**
 * File path of Functions for testing (omit extensions).
 */
import { ${className.toPascalCase()}Schedule } from '../src/functions/$baseName';

/**
 * Firebase project ID for testing.
 */
const testProjectId = "\${testProjectId}";

/**
 * Regions to deploy Functions.
 */
const regions = ["asia-northeast1"];

// Create tests for Functions.
const tester = require("firebase-functions-test")({
  projectId: testProjectId,
});
describe(`Test: ${className.toPascalCase()}Schedule`, () => {
  let functions: any;

  // Performs initial setup for testing.
  beforeAll(() => {
    admin.initializeApp();
    process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
    functions = new ${className.toPascalCase()}Schedule().build(regions);
  });
  afterEach(async () => {
    await fetch(
      `http://\${process.env.FIRESTORE_EMULATOR_HOST}/emulator/v1/projects/\${testProjectId}/databases/(default)/documents`,
      { method: "DELETE" },
    );
  });
  afterAll(() => {
    tester.cleanup()
  })

  // The actual test is written from here.
  it("Test Item 1", async () => {
    const firestoreInstance = admin.firestore();
    const parameters: { [key: string]: any } = {
    };

    const functionsWrapped = tester.wrap(functions);
    await functionsWrapped({
      params: parameters,
    });
  });
});
""";
  }
}
