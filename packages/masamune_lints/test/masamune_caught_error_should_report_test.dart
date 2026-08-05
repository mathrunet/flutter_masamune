// Package imports:
import "dart:io";

import "package:custom_lint_builder/custom_lint_builder.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_lints/masamune_lints.dart";

const _ruleName = "masamune_caught_error_should_report";

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

    test("reports an empty catch clause", () async {
      expect(
        await lintedFunctionsOf("""
void f() {
  try {
    g();
  } catch (e) {}
}
void g() {}
"""),
        hasLength(1),
      );
    });

    test("does not report when rethrown", () async {
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

    test("does not report when a new exception is thrown", () async {
      expect(
        await lintedFunctionsOf("""
void f() {
  try {
    g();
  } catch (e) {
    throw Exception("wrapped");
  }
}
void g() {}
"""),
        isEmpty,
      );
    });

    test("does not report when reported via a Logger-typed receiver", () async {
      expect(
        await lintedFunctionsOf("""
class Logger {
  Future<void> error(Object exception, StackTrace? stackTrace) async {}
}
final appLogger = Logger();
void f() {
  try {
    g();
  } catch (e, stackTrace) {
    appLogger.error(e, stackTrace);
  }
}
void g() {}
"""),
        isEmpty,
      );
    });

    test("still reports when `error` is called on an unrelated receiver",
        () async {
      expect(
        await lintedFunctionsOf("""
class Unrelated {
  void error(Object exception, StackTrace? stackTrace) {}
}
void f() {
  try {
    g();
  } catch (e, stackTrace) {
    Unrelated().error(e, stackTrace);
  }
}
void g() {}
"""),
        hasLength(1),
      );
    });
  });

  group("$_ruleName fix", () {
    Future<String> fixedSourceOf(String source) async {
      final dir = await _projectFor(source);
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File("${dir.path}/lib.dart");
      final errors = await _rule().testAnalyzeAndRun(file);
      expect(errors, hasLength(1));
      final fix = _rule().getFixes().single as DartFix;
      final changes = await fix.testAnalyzeAndRun(file, errors.single, errors);
      expect(changes, hasLength(1));

      var result = source;
      final edits = changes.single.change.edits.single.edits.toList()
        ..sort((a, b) => b.offset.compareTo(a.offset));
      for (final edit in edits) {
        result = result.replaceRange(
          edit.offset,
          edit.offset + edit.length,
          edit.replacement,
        );
      }
      return result;
    }

    test("adds await in an async body and completes the catch parameters",
        () async {
      expect(
        await fixedSourceOf("""
Future<void> f() async {
  try {
    await g();
  } catch (e) {}
}
Future<void> g() async {}
"""),
        """
Future<void> f() async {
  try {
    await g();
  } catch (e, stackTrace) {
    await appLogger.error(e, stackTrace);}
}
Future<void> g() async {}
""",
      );
    });

    test("omits await in a synchronous body", () async {
      expect(
        await fixedSourceOf("""
void f() {
  try {
    g();
  } catch (e, stackTrace) {}
}
void g() {}
"""),
        """
void f() {
  try {
    g();
  } catch (e, stackTrace) {
    appLogger.error(e, stackTrace);}
}
void g() {}
""",
      );
    });

    test("adds a catch clause to a bare `on` clause", () async {
      expect(
        await fixedSourceOf("""
void f() {
  try {
    g();
  } on Exception {}
}
void g() {}
"""),
        """
void f() {
  try {
    g();
  } on Exception catch (e, stackTrace) {
    appLogger.error(e, stackTrace);}
}
void g() {}
""",
      );
    });
  });
}
