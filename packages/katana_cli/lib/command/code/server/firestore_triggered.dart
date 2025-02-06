part of "server.dart";

/// Create server code for Firestore triggers.
///
/// Firestoreのトリガー用のサーバーコードを作成します。
class CodeServerFirestoreTriggeredCliCommand extends CliTestableCodeCommand {
  /// Create server code for Firestore triggers.
  ///
  /// Firestoreのトリガー用のサーバーコードを作成します。
  const CodeServerFirestoreTriggeredCliCommand();

  @override
  String get name => "firestore";

  @override
  String get prefix => "firestore";

  @override
  String get directory => "firebase/functions/src/functions";

  @override
  String get testDirectory => "firebase/functions/test";

  @override
  String get description =>
      "Create a server code for Firestore triggers in `$directory/(filepath).ts`. Firestoreトリガー用のサーバーコードを`$directory/(filepath).ts`に作成します。";

  @override
  String? get example => "katana code server firestore [function_name]";

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
    label(
        "Create a server code for Firestore triggers in `$directory/$path.ts`.");
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
import * as functions from "firebase-functions/v2";

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
 * ${className.toPascalCase()}FirestoreTriggered
 *
 * Create a server code for Firestore triggers.
 */
export class ${className.toPascalCase()}FirestoreTriggered extends m.FirestoreTriggeredProcessFunctionBase {
    /**
     * @param {string} id
     * Describe the method names used in Functions.
     *
     * Functionsで利用されるメソッド名を記述します。
     */
    id = "${className.toSnakeCase()}_firestore_triggered";
    /**
     * @param {string} schedule
     * Specifies the path to be processed.
     *
     * 処理を実行する対象のパスを指定します。
     *
     * https://firebase.google.com/docs/functions/firestore-events
     */
    path = "";
    /**
     * @param {string} database
     * Specifies the database. [null] is the default.
     *
     * データベースを指定します。[null]の場合デフォルトが利用されます。
     */
    database = null;
    /**
     * Specify the actual contents of the process.
     *
     * 実際の処理の中身を指定します。
     *
     * @param {functions.firestore.FirestoreEvent<functions.firestore.Change<functions.firestore.DocumentSnapshot> | undefined, Record<string, string>>} event
     * Event Description.
     *
     * イベントの内容。
     */
    async process(event: functions.firestore.FirestoreEvent<functions.firestore.Change<functions.firestore.DocumentSnapshot> | undefined, Record<string, string>>): Promise<void> {
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
import {
  describe,
  expect,
  it,
  beforeAll,
  afterAll,
  afterEach,
} from '@jest/globals';
import * as admin from 'firebase-admin';

/**
 * File path of Functions for testing (omit extensions).
 */
import { ${className.toPascalCase()}FirestoreTriggered } from '../src/functions/$baseName';

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
describe(`Test: ${className.toPascalCase()}FirestoreTriggerred`, () => {
  let functions: any;

  // Performs initial setup for testing.
  beforeAll(() => {
    admin.initializeApp();
    process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
    functions = new ${className.toPascalCase()}FirestoreTriggered().build(regions);
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
    const path = "collection/documentId";
    const beforeData: { [key: string]: any } = {
    };
    const afterData: { [key: string]: any } = {
    };
    await firestoreInstance.doc(path).set(
      beforeData, { merge: true },
    );

    const beforeSnap = tester.firestore.makeDocumentSnapshot(
      beforeData, path,
    );

    const afterSnap = tester.firestore.makeDocumentSnapshot(
      afterData, path,
    );
    const change = await tester.makeChange(
      beforeSnap,
      afterSnap,
    );

    const functionsWrapped = tester.wrap(functions);
    await functionsWrapped({
      data: change,
      params: parameters,
    });
  });
});
""";
  }
}
