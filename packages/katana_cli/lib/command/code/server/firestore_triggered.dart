part of "server.dart";

/// Create server code for Firestore triggers.
///
/// Firestoreのトリガー用のサーバーコードを作成します。
class CodeServerFirestoreTriggeredCliCommand extends CliCodeCommand {
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
  String get description =>
      "Create a server code for Firestore triggers in `$directory/(filepath).ts`. Firestoreトリガー用のサーバーコードを`$directory/(filepath).ts`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      error(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code cache [path]\r\n",
      );
      return;
    }
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
}
