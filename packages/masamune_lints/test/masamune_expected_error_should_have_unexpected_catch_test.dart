// Dart imports:
import "dart:io";

// Package imports:
import "package:custom_lint_builder/custom_lint_builder.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_lints/masamune_lints.dart";

const _ruleName = "masamune_expected_error_should_have_unexpected_catch";

DartLintRule _rule() {
  final plugin = createPlugin();
  // ignore: invalid_use_of_internal_member
  return plugin.getLintRules(CustomLintConfigs.empty).firstWhere(
        (rule) => rule.code.name == _ruleName,
      ) as DartLintRule;
}

Future<Directory> _projectFor(String source) async {
  final dir = await Directory.systemTemp.createTemp("masamune_lints_test");
  File("${dir.path}/pubspec.yaml").writeAsStringSync("""
name: lint_fixture
environment:
  sdk: ^3.6.0
""");
  File("${dir.path}/lib.dart").writeAsStringSync(source);
  return dir;
}

void main() {
  group("$_ruleName lint", () {
    Future<List<String>> lintedFunctionsOf(String source) async {
      final dir = await _projectFor(source);
      addTearDown(() => dir.deleteSync(recursive: true));
      final errors =
          await _rule().testAnalyzeAndRun(File("${dir.path}/lib.dart"));
      return errors.map((e) => e.diagnosticCode.name).toList();
    }

    test("reports a typed catch without a final untyped catch", () async {
      expect(
        await lintedFunctionsOf("""
class ExpectedException implements Exception {}
void f() {
  try {
    g();
  } on ExpectedException catch (e) {
    handle(e);
  }
}
void g() {}
void handle(Object error) {}
"""),
        hasLength(1),
      );
    });

    test("does not report typed catches followed by an untyped catch",
        () async {
      expect(
        await lintedFunctionsOf("""
class FirstExpectedException implements Exception {}
class SecondExpectedException implements Exception {}
void f() {
  try {
    g();
  } on FirstExpectedException catch (e) {
    handle(e);
  } on SecondExpectedException catch (e) {
    handle(e);
  } catch (e, stackTrace) {
    report(e, stackTrace);
  }
}
void g() {}
void handle(Object error) {}
void report(Object error, StackTrace stackTrace) {}
"""),
        isEmpty,
      );
    });

    test("does not report an untyped catch without typed catches", () async {
      expect(
        await lintedFunctionsOf("""
void f() {
  try {
    g();
  } catch (e) {
    rethrow;
  }
}
void g() {}
"""),
        isEmpty,
      );
    });

    test("does not report a try-finally without catches", () async {
      expect(
        await lintedFunctionsOf("""
void f() {
  try {
    g();
  } finally {
    cleanup();
  }
}
void g() {}
void cleanup() {}
"""),
        isEmpty,
      );
    });
  });
}
