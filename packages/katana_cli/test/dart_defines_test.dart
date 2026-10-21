// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/git/dart_defines.dart";
import "package:katana_cli/katana_cli.dart";

const _environment = {
  "TOKEN": "secret-token",
  "HOST": "api.example.com",
  "EMPTY": "",
  "MULTILINE": "line1\nline2",
};

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void main() {
  final original = Directory.current;
  final temp = Directory.systemTemp.createTempSync("katana_dart_defines_");
  Directory.current = temp;
  try {
    Directory("dart_defines").createSync();

    File("dart_defines/plain.env").writeAsStringSync("FLAVOR=dev\nKEY=value\n");
    _check(
      resolveDartDefinesFile("dart_defines/plain.env") ==
          "dart_defines/plain.env",
      "files without references are passed as is",
    );
    _check(
      !Directory(kResolvedDartDefinesDirectory).existsSync(),
      "no file is written without references",
    );
    _check(
      resolveDartDefinesFile("dart_defines/missing.env") ==
          "dart_defines/missing.env",
      "missing files are passed as is",
    );

    File("dart_defines/dev.env").writeAsStringSync(
      [
        "# Comment with \${UNDEFINED}",
        "FLAVOR=dev",
        "",
        r"API_KEY=${TOKEN}",
        r"URL=https://${HOST}/v1",
        r"FALLBACK=${UNDEFINED:-default}",
        r"EMPTY_FALLBACK=${EMPTY:-default}",
        r"ESCAPED=$${TOKEN}",
        r"PLAIN=$TOKEN",
        "WITH_EQUAL=a=b",
        "",
      ].join("\n"),
    );
    final resolved = resolveDartDefinesFile(
      "dart_defines/dev.env",
      environment: _environment,
    );
    _check(
      resolved == "$kResolvedDartDefinesDirectory/dev.env",
      "expanded file path",
    );
    _check(
      File(resolved).readAsStringSync() ==
          [
            "# Comment with \${UNDEFINED}",
            "FLAVOR=dev",
            "",
            "API_KEY=secret-token",
            "URL=https://api.example.com/v1",
            "FALLBACK=default",
            "EMPTY_FALLBACK=default",
            r"ESCAPED=${TOKEN}",
            r"PLAIN=$TOKEN",
            "WITH_EQUAL=a=b",
            "",
          ].join("\n"),
      "expanded content",
    );
    if (!Platform.isWindows) {
      final mode = File(resolved).statSync().mode & 0x1FF;
      _check(mode == 0x180, "expanded file is owner-only");
    }
    _check(
      File("dart_defines/dev.env").readAsStringSync().contains(r"${TOKEN}"),
      "source file is not modified",
    );

    _check(
      dartDefinesEnvironmentNames("dart_defines/dev.env").length == 4 &&
          dartDefinesEnvironmentNames("dart_defines/dev.env")
              .containsAll(["TOKEN", "HOST", "UNDEFINED", "EMPTY"]),
      "referenced names",
    );
    final required = dartDefinesEnvironmentNames(
      "dart_defines/dev.env",
      requiredOnly: true,
    );
    _check(
      required.length == 2 && required.containsAll(["TOKEN", "HOST"]),
      "required names",
    );

    File("dart_defines/prod.env").writeAsStringSync(
      "A=\${MISSING_A}\nB=\${MISSING_B}\nC=\${TOKEN}\n",
    );
    try {
      resolveDartDefinesFile(
        "dart_defines/prod.env",
        environment: _environment,
      );
      throw StateError("undefined variables must throw");
    } on KatanaEnvironmentVariableException catch (e) {
      _check(
        e.names.length == 2 && e.names.containsAll(["MISSING_A", "MISSING_B"]),
        "all undefined names are reported",
      );
      _check(!e.toString().contains("secret-token"), "values are hidden");
    }

    File("dart_defines/stg.env").writeAsStringSync("A=\${MULTILINE}\n");
    try {
      resolveDartDefinesFile(
        "dart_defines/stg.env",
        environment: _environment,
      );
      throw StateError("line breaks must throw");
    } on KatanaDartDefinesException catch (e) {
      _check(e.keys.single == "A", "key with line break is reported");
      _check(!e.toString().contains("line1"), "values are hidden");
    }

    const workflow = """
      - name: Flutter status check
        timeout-minutes: 30
        uses: ./.github/actions/status_check

      # Build.
      # ビルド。
      - name: Build
        run: flutter build web --dart-define-from-file=dart_defines/prod.env
""";
    _check(
      applyDartDefinesToWorkflow(workflow) == workflow,
      "workflow without references is unchanged",
    );
    final applied = applyDartDefinesToWorkflow(
      workflow,
      buildNames: {"TOKEN"},
      statusCheckNames: {"HOST"},
      suffix: "APP",
    );
    _check(
      applied.contains(
        "        uses: ./.github/actions/status_check\n        env:\n          HOST: \${{ secrets.HOST }}\n",
      ),
      "status check receives secrets",
    );
    _check(
      applied.contains("          TOKEN: \${{ secrets.TOKEN_APP }}"),
      "build receives app secrets",
    );
    _check(
      applied.indexOf("- name: Resolve dart defines") <
          applied.indexOf("# Build."),
      "resolve step is inserted before the build step comments",
    );
    _check(
      applied.contains(
        "--dart-define-from-file=$kResolvedDartDefinesDirectory/prod.env",
      ),
      "build uses the expanded file",
    );
  } finally {
    Directory.current = original;
    temp.deleteSync(recursive: true);
  }

  // ignore: avoid_print
  print("dart_defines_test: OK");
}
