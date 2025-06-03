part of "server.dart";

/// Create server code for FunctionCall.
///
/// FunctionCall用のサーバーコードを作成します。
class CodeServerCallCliCommand extends CliTestableCodeCommand {
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
  String get testDirectory => "firebase/functions/test";

  @override
  String get description =>
      "Create server code for FunctionCall in `$directory/(filepath).ts`. FunctionCall用のサーバーコードを`$directory/(filepath).ts`に作成します。";

  @override
  String? get example => "katana code server call [function_name]";

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
    label("Create server code for FunctionCall in `$directory/$path.ts`.");
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
     * @param {m.CallableRequest<any>} query
     * Query passed to Functions.
     *
     * Functionsに渡されたクエリ。
     *
     * @return {Promise<Record<string, any>>}
     * Return the result of the process.
     *
     * 処理の結果を返します。
     */
    async process(
      query: m.CallableRequest<any>,
    ): Promise<{[key: string]: any}> {
        // TODO: Implement the process to be executed.
        return {};
    }
}

""";
  }

  @override
  String test(
      String path, String sourcePath, String baseName, String className) {
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
import { ${className.toPascalCase()}Call } from '../src/functions/$baseName';

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
describe(`Test: ${className.toPascalCase()}Call`, () => {
  let functions: any;

  // Performs initial setup for testing.
  beforeAll(() => {
    admin.initializeApp();
    process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
    functions = new ${className.toPascalCase()}Call().build(regions);
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
