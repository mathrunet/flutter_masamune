// Copyright (c) 2025 mathru. All rights reserved.

// ignore_for_file: non_constant_identifier_names

import "package:analyzer/analysis_rule/analysis_rule.dart";
import "package:analyzer/dart/analysis/results.dart";
import "package:analyzer/error/error.dart";
import "package:analysis_server_plugin/edit/dart/correction_producer.dart";
import "package:analysis_server_plugin/registry.dart";
// ignore: implementation_imports
import "package:analysis_server_plugin/src/correction/fix_generators.dart"
    show ProducerGenerator;
import "package:analyzer_plugin/protocol/protocol_common.dart" show SourceEdit;
// ignore: implementation_imports
import "package:analyzer_plugin/src/utilities/change_builder/change_builder_core.dart"
    show ChangeBuilderImpl;
import "package:analyzer_testing/analysis_rule/analysis_rule.dart";
// ignore: implementation_imports
import "package:analyzer_testing/src/analysis_rule/pub_package_resolution.dart"
    show ExpectedDiagnostic;
import "package:masamune_lints/masamune_lints.dart";
import "package:test/test.dart";
import "package:test_reflective_loader/test_reflective_loader.dart";

AnalysisRule _rule(String name) =>
    createMasamuneLintRules().singleWhere((rule) => rule.name == name);

abstract class _MasamuneRuleTest extends AnalysisRuleTest {
  String get ruleName;

  @override
  void setUp() {
    rule = _rule(ruleName);
    super.setUp();
  }

  ExpectedDiagnostic lintOn(
    String source,
    String highlighted, {
    List<Pattern> messageContainsAll = const [],
  }) {
    final offset = source.lastIndexOf(highlighted);
    expect(offset, isNonNegative, reason: "Missing highlight: $highlighted");
    return lint(
      offset,
      highlighted.length,
      messageContainsAll: messageContainsAll,
    );
  }
}

@reflectiveTest
class CaughtErrorShouldReportTest extends _MasamuneRuleTest {
  @override
  String get ruleName => "masamune_caught_error_should_report";

  Future<void> test_reports_untyped_catch_without_reporting() async {
    const source = """
void f() {
  try {
    g();
  } catch (error) {}
}
void g() {}
""";
    await assertDiagnostics(source, [lintOn(source, "catch (error) {}")]);
  }

  Future<void> test_ignores_rethrow_and_typed_catch() async {
    await assertNoDiagnostics("""
class ExpectedException implements Exception {}
void f() {
  try {
    g();
  } on ExpectedException catch (_) {
    return;
  } catch (error) {
    rethrow;
  }
}
void g() {}
""");
  }

  Future<void> test_ignores_new_exception_throw() async {
    await assertNoDiagnostics("""
void f() {
  try {
    g();
  } catch (error) {
    throw Exception("wrapped: \$error");
  }
}
void g() {}
""");
  }

  Future<void> test_ignores_typed_expected_catch() async {
    await assertNoDiagnostics("""
class ExpectedException implements Exception {}
void f() {
  try {
    g();
  } on ExpectedException catch (error) {
    consume(error);
  }
}
void g() {}
void consume(Object value) {}
""");
  }

  Future<void> test_accepts_exact_app_logger_call() async {
    await assertNoDiagnostics("""
class Logger {
  Future<void> error(Object error, StackTrace stackTrace) async {}
}
final appLogger = Logger();
void f() {
  try {
    g();
  } catch (error, stackTrace) {
    appLogger.error(error, stackTrace);
  }
}
void g() {}
""");
  }

  Future<void> test_reports_error_called_on_another_logger() async {
    const source = """
class Logger {
  Future<void> error(Object error, StackTrace stackTrace) async {}
}
final otherLogger = Logger();
void f() {
  try {
    g();
  } catch (error, stackTrace) {
    otherLogger.error(error, stackTrace);
  }
}
void g() {}
""";
    await assertDiagnostics(source, [
      lintOn(
        source,
        "catch (error, stackTrace) {\n"
        "    otherLogger.error(error, stackTrace);\n  }",
      ),
    ]);
  }

  Future<void> test_reports_app_logger_with_different_arguments() async {
    const source = """
class Logger {
  Future<void> error(Object error, StackTrace stackTrace) async {}
}
final appLogger = Logger();
void f(Object otherError, StackTrace otherStackTrace) {
  try {
    g();
  } catch (error, stackTrace) {
    consume(error, stackTrace);
    appLogger.error(otherError, otherStackTrace);
  }
}
void g() {}
void consume(Object error, StackTrace stackTrace) {}
""";
    await assertDiagnostics(source, [
      lintOn(
        source,
        "catch (error, stackTrace) {\n"
        "    consume(error, stackTrace);\n"
        "    appLogger.error(otherError, otherStackTrace);\n  }",
      ),
    ]);
  }

  Future<void> test_reports_unrelated_app_logger_type() async {
    const source = """
class Unrelated {
  void error(Object error, StackTrace stackTrace) {}
}
final appLogger = Unrelated();
void f() {
  try {
    g();
  } catch (error, stackTrace) {
    appLogger.error(error, stackTrace);
  }
}
void g() {}
""";
    await assertDiagnostics(source, [
      lintOn(
        source,
        "catch (error, stackTrace) {\n"
        "    appLogger.error(error, stackTrace);\n  }",
      ),
    ]);
  }

  Future<void> test_reports_another_reporting_function() async {
    const source = """
void reportError(Object error, StackTrace stackTrace) {}
void f() {
  try {
    g();
  } catch (error, stackTrace) {
    reportError(error, stackTrace);
  }
}
void g() {}
""";
    await assertDiagnostics(source, [
      lintOn(
        source,
        "catch (error, stackTrace) {\n"
        "    reportError(error, stackTrace);\n  }",
      ),
    ]);
  }
}

@reflectiveTest
class ExpectedErrorShouldHaveUnexpectedCatchTest extends _MasamuneRuleTest {
  @override
  String get ruleName => "masamune_expected_error_should_have_unexpected_catch";

  Future<void> test_reports_when_final_catch_is_typed() async {
    const source = """
class ExpectedException implements Exception {}
void f() {
  try {
    g();
  } on ExpectedException catch (error) {
    consume(error);
  }
}
void g() {}
void consume(Object value) {}
""";
    await assertDiagnostics(source, [
      lintOn(
        source,
        "on ExpectedException catch (error) {\n    consume(error);\n  }",
      ),
    ]);
  }

  Future<void> test_accepts_final_untyped_catch() async {
    await assertNoDiagnostics("""
class ExpectedException implements Exception {}
class AnotherExpectedException implements Exception {}
void f() {
  try {
    g();
  } on ExpectedException catch (_) {
    return;
  } on AnotherExpectedException catch (_) {
    return;
  } catch (_) {
    rethrow;
  }
}
void g() {}
""");
  }

  Future<void> test_accepts_untyped_catch_without_typed_catches() async {
    await assertNoDiagnostics("""
void f() {
  try {
    g();
  } catch (_) {
    rethrow;
  }
}
void g() {}
""");
  }

  Future<void> test_accepts_try_finally_without_catches() async {
    await assertNoDiagnostics("""
void f() {
  try {
    g();
  } finally {
    cleanup();
  }
}
void g() {}
void cleanup() {}
""");
  }
}

@reflectiveTest
class LimitIfNestingTest extends _MasamuneRuleTest {
  @override
  String get ruleName => "masamune_if_nesting_should_limit";

  Future<void> test_reports_fourth_if_level() async {
    const source = """
void f(bool a, bool b, bool c, bool d) {
  if (a) {
    if (b) {
      if (c) {
        if (d) {}
      }
    }
  }
}
""";
    await assertDiagnostics(source, [lintOn(source, "if (d) {}")]);
  }

  Future<void> test_accepts_three_levels() async {
    await assertNoDiagnostics("""
void f(bool a, bool b, bool c) {
  if (a) {
    if (b) {
      if (c) {}
    }
  }
}
""");
  }
}

@reflectiveTest
class UnwrapNullableTest extends _MasamuneRuleTest {
  @override
  String get ruleName => "masamune_nullable_should_not_unwrap";

  Future<void> test_reports_null_assertion_on_nullable() async {
    const source = """
int f(int? value) => value!;
""";
    await assertDiagnostics(source, [lintOn(source, "value!")]);
  }

  Future<void> test_accepts_non_nullable_value() async {
    await assertNoDiagnostics("int f(int value) => value;\n");
  }
}

@reflectiveTest
class ModelShouldLoadTest extends _MasamuneRuleTest {
  @override
  String get ruleName => "masamune_model_should_load";

  static const _support = """
class Model {
  void load() {}
}
class PageRef {
  Model model() => Model();
}
""";

  Future<void> test_reports_unloaded_model_in_build() async {
    const source =
        """
$_support
class Page {
  void build(PageRef ref) {
    final model = ref.model();
    print(model);
  }
}
""";
    await assertDiagnostics(source, [lintOn(source, "ref.model()")]);
  }

  Future<void> test_accepts_loaded_model() async {
    await assertNoDiagnostics("""
$_support
class Page {
  void build(PageRef ref) {
    final model = ref.model();
    model.load();
  }
}
""");
  }
}

@reflectiveTest
class ModelShouldShowIndicatorTest extends _MasamuneRuleTest {
  @override
  String get ruleName => "masamune_model_should_show_indicator_while_loading";

  static const _support = """
class Model {
  Future<void> get loading => Future.value();
  void load() {}
}
class PageRef {
  Model model() => Model();
}
class LoadingBuilder {
  LoadingBuilder({required List<Future<void>> futures});
}
""";

  Future<void> test_reports_loaded_model_without_indicator() async {
    const source =
        """
$_support
class Page {
  void build(PageRef ref) {
    final model = ref.model();
    model.load();
  }
}
""";
    await assertDiagnostics(source, [lintOn(source, "ref.model()")]);
  }

  Future<void> test_accepts_loading_builder() async {
    await assertNoDiagnostics("""
$_support
class Page {
  void build(PageRef ref) {
    final model = ref.model();
    model.load();
    LoadingBuilder(futures: [model.loading]);
  }
}
""");
  }
}

@reflectiveTest
class CollectionModelShouldLimitTest extends _MasamuneRuleTest {
  @override
  String get ruleName => "masamune_model_should_add_limit_query";

  static const _support = """
class ModelCollectionQuery {
  void call() {}
  ModelCollectionQuery limitTo(int count) => this;
  ModelCollectionQuery aggregate() => this;
}
class Model {
  ModelCollectionQuery get collection => ModelCollectionQuery();
}
class PageRef {
  Model model() => Model();
}
""";

  Future<void> test_reports_collection_query_without_limit() async {
    const source =
        """
$_support
class Page {
  void build(PageRef ref) {
    final query = ref.model().collection;
    query();
  }
}
""";
    await assertDiagnostics(source, [lintOn(source, "query()")]);
  }

  Future<void> test_accepts_limit_to() async {
    await assertNoDiagnostics("""
$_support
class Page {
  void build(PageRef ref) {
    ref.model().collection.limitTo(10)();
  }
}
""");
  }

  Future<void> test_accepts_aggregate_without_limit() async {
    await assertNoDiagnostics("""
$_support
class Page {
  void build(PageRef ref) {
    ref.model().collection.aggregate()();
  }
}
""");
  }

  Future<void> test_reports_aggregate_with_limit() async {
    const source =
        """
$_support
class Page {
  void build(PageRef ref) {
    ref.model().collection.aggregate().limitTo(10)();
  }
}
""";
    await assertDiagnostics(source, [
      lintOn(source, "ref.model().collection.aggregate().limitTo(10)()"),
    ]);
  }
}

@reflectiveTest
class ScopedQueryMustMatchRefTest extends _MasamuneRuleTest {
  @override
  String get ruleName => "masamune_scoped_query_must_pass_to_appropriate_ref";

  Future<void> test_reports_mismatched_ref_with_message_arguments() async {
    const source = """
class PageScopedQuery<T> {}
class AppRef {
  void query(Object query) {}
}
class Page {
  void build(AppRef ref, PageScopedQuery<int> query) {
    ref.query(query);
  }
}
""";
    final expected = lintOn(
      source,
      "ref.query(query)",
      messageContainsAll: ["Ref/App", "ScopedQuery/Page"],
    );
    await assertDiagnostics(source, [expected]);
  }

  Future<void> test_accepts_matching_ref() async {
    await assertNoDiagnostics("""
class AppScopedQuery<T> {}
class AppRef {
  void query(Object query) {}
}
class Page {
  void build(AppRef ref, AppScopedQuery<int> query) {
    ref.query(query);
  }
}
""");
  }
}

@reflectiveTest
class ShouldUseFormWidgetTest extends _MasamuneRuleTest {
  @override
  String get ruleName => "masamune_should_use_form_widget";

  Future<void> test_reports_text_field_with_suggestion_arguments() async {
    const source = """
class TextField {
  TextField();
}
void f() {
  TextField();
}
""";
    final expected = lintOn(
      source,
      "TextField()",
      messageContainsAll: ["FormTextField", "TextField"],
    );
    await assertDiagnostics(source, [expected]);
  }

  Future<void> test_accepts_unlisted_widget() async {
    await assertNoDiagnostics("""
class FormTextField {
  FormTextField();
}
void f() {
  FormTextField();
}
""");
  }

  Future<void> test_reports_all_widget_suggestions_with_arguments() async {
    const source = """
class TextField { TextField(); }
class TextFormField { TextFormField(); }
class DropdownButton { DropdownButton(); }
class DropdownButtonFormField { DropdownButtonFormField(); }
class Checkbox { Checkbox(); }
class Switch { Switch(); }
class Slider { Slider(); }
void f() {
  TextField();
  TextFormField();
  DropdownButton();
  DropdownButtonFormField();
  Checkbox();
  Switch();
  Slider();
}
""";
    await assertDiagnostics(source, [
      lintOn(
        source,
        "TextField()",
        messageContainsAll: ["FormTextField", "TextField"],
      ),
      lintOn(
        source,
        "TextFormField()",
        messageContainsAll: ["FormTextField", "TextFormField"],
      ),
      lintOn(
        source,
        "DropdownButton()",
        messageContainsAll: ["FormMapDropdownField", "DropdownButton"],
      ),
      lintOn(
        source,
        "DropdownButtonFormField()",
        messageContainsAll: ["FormMapDropdownField", "DropdownButtonFormField"],
      ),
      lintOn(
        source,
        "Checkbox()",
        messageContainsAll: ["FormCheckbox", "Checkbox"],
      ),
      lintOn(source, "Switch()", messageContainsAll: ["FormSwitch", "Switch"]),
      lintOn(source, "Slider()", messageContainsAll: ["FormSlider", "Slider"]),
    ]);
  }
}

@reflectiveTest
class ShouldUseUniversalWidgetTest extends _MasamuneRuleTest {
  @override
  String get ruleName => "masamune_should_use_universal_widget";

  Future<void> test_reports_scaffold_with_suggestion_arguments() async {
    const source = """
class Scaffold {
  Scaffold();
}
void f() {
  Scaffold();
}
""";
    final expected = lintOn(
      source,
      "Scaffold()",
      messageContainsAll: ["UniversalScaffold", "Scaffold"],
    );
    await assertDiagnostics(source, [expected]);
  }

  Future<void> test_accepts_universal_scaffold() async {
    await assertNoDiagnostics("""
class UniversalScaffold {
  UniversalScaffold();
}
void f() {
  UniversalScaffold();
}
""");
  }

  Future<void> test_reports_top_level_container_only() async {
    const source = """
class PageScopedWidget {}
class Container { Container(); }
class Page extends PageScopedWidget {
  Object build() {
    return Container();
  }
  Object helper() {
    return Container();
  }
}
""";
    await assertDiagnostics(source, [
      lintOn(
        source.substring(0, source.indexOf("Object helper")),
        "Container()",
        messageContainsAll: ["UniversalContainer", "Container"],
      ),
    ]);
  }
}

class _CapturingPluginRegistry implements PluginRegistry {
  final assists = <ProducerGenerator>[];
  final fixes = <String, List<ProducerGenerator>>{};

  @override
  void registerAssist(ProducerGenerator generator) => assists.add(generator);

  @override
  void registerFixForRule(DiagnosticCode code, ProducerGenerator generator) {
    fixes.putIfAbsent(code.lowerCaseName, () => []).add(generator);
  }

  @override
  void registerWarningRule(AbstractAnalysisRule rule) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

@reflectiveTest
class CorrectionEditsTest extends _MasamuneRuleTest {
  static const _buttonDeclarations = """
class Widget {
  const Widget();
}
class Icon extends Widget {
  const Icon(Object value);
}
class Icons {
  static const add = Object();
}
class ElevatedButton extends Widget {
  const ElevatedButton({required Widget child});
  const ElevatedButton.icon({required Widget icon, required Widget label});
}
class OutlinedButton extends Widget {
  const OutlinedButton({required Widget child});
  const OutlinedButton.icon({required Widget icon, required Widget label});
}
class FilledButton extends Widget {
  const FilledButton({required Widget child});
  const FilledButton.icon({required Widget icon, required Widget label});
  const FilledButton.tonal({required Widget child});
  const FilledButton.tonalIcon({required Widget icon, required Widget label});
}
class TextButton extends Widget {
  const TextButton({required Widget child});
  const TextButton.icon({required Widget icon, required Widget label});
}
""";

  @override
  String get ruleName => "masamune_caught_error_should_report";

  Future<String> _applyCorrection({
    required String source,
    required String selection,
    required String correctionId,
    List<String> correctionArguments = const [],
    bool isFix = false,
  }) async {
    testFile.writeAsStringSync(source);
    final unitResult = await resolveFile(testFile.path);
    final libraryResult =
        await unitResult.session.getResolvedLibrary(testFile.path)
            as ResolvedLibraryResult;
    final diagnostic = isFix
        ? unitResult.diagnostics.singleWhere(
            (diagnostic) => diagnostic.diagnosticCode.lowerCaseName == ruleName,
          )
        : null;
    final selectionOffset = source.lastIndexOf(selection);
    expect(selectionOffset, isNonNegative);
    final context = CorrectionProducerContext.createResolved(
      libraryResult: libraryResult,
      unitResult: unitResult,
      diagnostic: diagnostic,
      selectionOffset: isFix ? diagnostic!.offset : selectionOffset,
      selectionLength: isFix ? diagnostic!.length : selection.length,
    );
    final registry = _CapturingPluginRegistry();
    MasamuneLintsPlugin().register(registry);
    final generators = isFix ? registry.fixes[ruleName]! : registry.assists;
    final producer = generators
        .map((generator) => generator(context: context))
        .singleWhere(
          (producer) =>
              (isFix ? producer.fixKind?.id : producer.assistKind?.id) ==
                  correctionId &&
              (!isFix
                  ? (producer.assistArguments ?? const [])
                            .map((value) => value.toString())
                            .toList()
                            .join() ==
                        correctionArguments.join()
                  : true),
        );
    final builder = ChangeBuilderImpl(session: unitResult.session);
    await producer.compute(builder);
    final fileEdit = builder.sourceChange.edits.single;
    return SourceEdit.applySequence(source, fileEdit.edits);
  }

  Future<void> test_fix_async_catch_exact_edit() async {
    const source = """
Future<void> f() async {
  try {
    g();
  } catch (e) {}
}
void g() {}
""";
    expect(
      await _applyCorrection(
        source: source,
        selection: "catch (e) {}",
        correctionId: "masamune_lints.fix.report_caught_error",
        isFix: true,
      ),
      """
Future<void> f() async {
  try {
    g();
  } catch (e, stackTrace) {
    await appLogger.error(e, stackTrace);}
}
void g() {}
""",
    );
  }

  Future<void> test_fix_sync_catch_exact_edit() async {
    const source = """
void f() {
  try {
    g();
  } catch (e) {}
}
void g() {}
""";
    expect(
      await _applyCorrection(
        source: source,
        selection: "catch (e) {}",
        correctionId: "masamune_lints.fix.report_caught_error",
        isFix: true,
      ),
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
  }

  Future<void> test_assist_add_icon_exact_edit() async {
    const source =
        """
$_buttonDeclarations
Widget f() => ElevatedButton(child: const Widget());
""";
    expect(
      await _applyCorrection(
        source: source,
        selection: "ElevatedButton(child: const Widget())",
        correctionId: "masamune_lints.assist.add_button_icon",
      ),
      """
$_buttonDeclarations
Widget f() => ElevatedButton.icon(label: const Widget(), icon: const Icon(Icons.add));
""",
    );
  }

  Future<void> test_assist_remove_icon_exact_edit() async {
    const source =
        """
$_buttonDeclarations
Widget f() => ElevatedButton.icon(
  icon: const Icon(Icons.add),
  label: const Widget(),
);
""";
    expect(
      await _applyCorrection(
        source: source,
        selection: "ElevatedButton.icon",
        correctionId: "masamune_lints.assist.remove_button_icon",
      ),
      """
$_buttonDeclarations
Widget f() => ElevatedButton(
  child: const Widget(),
);
""",
    );
  }

  Future<void> test_assist_convert_button_exact_edit() async {
    const source =
        """
$_buttonDeclarations
Widget f() => ElevatedButton(child: const Widget());
""";
    expect(
      await _applyCorrection(
        source: source,
        selection: "ElevatedButton(child: const Widget())",
        correctionId: "masamune_lints.assist.convert_button",
        correctionArguments: ["OutlinedButton"],
      ),
      """
$_buttonDeclarations
Widget f() => OutlinedButton(child: const Widget());
""",
    );
  }
}

void main() {
  group("plugin contract", () {
    test("exports ten unique rules with preserved severity", () {
      final rules = createMasamuneLintRules();
      expect(rules, hasLength(10));
      expect(rules.map((rule) => rule.name).toSet(), hasLength(10));
      final severities = {
        for (final rule in rules) rule.name: rule.diagnosticCode.severity,
      };
      expect(
        severities["masamune_scoped_query_must_pass_to_appropriate_ref"],
        DiagnosticSeverity.ERROR,
      );
      expect(
        severities.entries
            .where(
              (entry) =>
                  entry.key !=
                  "masamune_scoped_query_must_pass_to_appropriate_ref",
            )
            .map((entry) => entry.value),
        everyElement(DiagnosticSeverity.WARNING),
      );
    });
  });

  defineReflectiveSuite(() {
    defineReflectiveTests(CaughtErrorShouldReportTest);
    defineReflectiveTests(ExpectedErrorShouldHaveUnexpectedCatchTest);
    defineReflectiveTests(LimitIfNestingTest);
    defineReflectiveTests(UnwrapNullableTest);
    defineReflectiveTests(ModelShouldLoadTest);
    defineReflectiveTests(ModelShouldShowIndicatorTest);
    defineReflectiveTests(CollectionModelShouldLimitTest);
    defineReflectiveTests(ScopedQueryMustMatchRefTest);
    defineReflectiveTests(ShouldUseFormWidgetTest);
    defineReflectiveTests(ShouldUseUniversalWidgetTest);
    defineReflectiveTests(CorrectionEditsTest);
  });
}
