// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_experiment/masamune_experiment.dart";

const _key = "new_button";

List<ExperimentCase<String, String>> _cases({
  List<String>? calls,
}) {
  return [
    ExperimentCase(
      label: "treatment_a",
      when: (value) {
        calls?.add("when:treatment_a");
        return value == "a";
      },
      run: () {
        calls?.add("run:treatment_a");
        return "A";
      },
    ),
    ExperimentCase(
      label: "treatment_b",
      when: (value) {
        calls?.add("when:treatment_b");
        return value == "b";
      },
      run: () {
        calls?.add("run:treatment_b");
        return "B";
      },
    ),
    ExperimentCase.otherwise(
      label: "control",
      run: () {
        calls?.add("run:control");
        return "control";
      },
    ),
  ];
}

void main() {
  group("Experiment.run", () {
    test("stops at the first matching case", () {
      final calls = <String>[];
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(values: {_key: "a"}),
      );
      final result = experiment.run(
        (config) => config.getString(_key),
        _cases(calls: calls),
      );
      expect(result, "A");
      expect(calls, ["when:treatment_a", "run:treatment_a"]);
      expect(experiment.selectedLabels, ["treatment_a"]);
    });

    test("evaluates later cases in order", () {
      final calls = <String>[];
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(values: {_key: "b"}),
      );
      final result = experiment.run(
        (config) => config.getString(_key),
        _cases(calls: calls),
      );
      expect(result, "B");
      expect(calls, [
        "when:treatment_a",
        "when:treatment_b",
        "run:treatment_b",
      ]);
    });

    test("evaluates the value only once", () {
      var count = 0;
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(values: {_key: "x"}),
      );
      experiment.run(
        (config) {
          count++;
          return config.getString(_key);
        },
        _cases(),
      );
      expect(count, 1);
    });

    test("falls back to otherwise", () {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(values: {_key: "unknown"}),
      );
      expect(
        experiment.run((config) => config.getString(_key), _cases()),
        "control",
      );
      expect(experiment.selectedLabels, ["control"]);
    });

    test("returns null when nothing matches", () {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(),
      );
      final result = experiment.run(
        (config) => config.getBool(_key),
        [
          ExperimentCase.equals(true, label: "treatment", run: () => 1),
        ],
      );
      expect(result, isNull);
      expect(experiment.selectedLabels, isEmpty);
    });

    test("mixes equals and otherwise with inferred types", () {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(values: {_key: "treatment"}),
      );
      final Widget? widget = experiment.run(
        (config) => config.getString(_key),
        [
          ExperimentCase.equals(
            "treatment",
            label: "treatment",
            run: () => const Text("treatment"),
          ),
          ExperimentCase.otherwise(
            label: "control",
            run: () => const SizedBox(),
          ),
        ],
      );
      expect(widget, isA<Text>());
    });

    test("executes the fixed case regardless of the conditions", () {
      final calls = <String>[];
      var evaluated = false;
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(values: {_key: "a"}),
      );
      final result = experiment.run(
        (config) {
          evaluated = true;
          return config.getString(_key);
        },
        _cases(calls: calls),
        fixed: "treatment_b",
      );
      expect(result, "B");
      expect(calls, ["run:treatment_b"]);
      expect(evaluated, isFalse);
      expect(experiment.selectedLabels, ["treatment_b"]);
    });

    test("asserts when the fixed label does not exist", () {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(),
      );
      expect(
        () => experiment.run(
          (config) => config.getString(_key),
          _cases(),
          fixed: "unknown",
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test("asserts when labels are duplicated", () {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(),
      );
      expect(
        () => experiment.run(
          (config) => config.getString(_key),
          [
            ExperimentCase.otherwise(label: "control", run: () => 1),
            ExperimentCase.otherwise(label: "control", run: () => 2),
          ],
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test("returns Future when the case returns Future", () async {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(values: {_key: true}),
      );
      final Future<int>? result = experiment.run(
        (config) => config.getBool(_key),
        [
          ExperimentCase.equals(
            true,
            label: "treatment",
            run: () async => 1,
          ),
          ExperimentCase.otherwise(
            label: "control",
            run: () async => 0,
          ),
        ],
      );
      expect(await result, 1);
    });

    test("supports cases without return values", () {
      var executed = false;
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(),
      );
      experiment.run<bool, void>(
        (config) => config.getBool(_key),
        [
          ExperimentCase.otherwise(
            label: "control",
            run: () {
              executed = true;
            },
          ),
        ],
      );
      expect(executed, isTrue);
    });

    test("records and clears selected labels", () {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(values: {_key: "a"}),
      );
      experiment.run((config) => config.getString(_key), _cases());
      experiment.run((config) => "b", _cases());
      expect(experiment.selectedLabels, ["treatment_a", "treatment_b"]);
      experiment.clearSelectedLabels();
      expect(experiment.selectedLabels, isEmpty);
      for (var i = 0; i < Experiment.maxSelectedLabels + 5; i++) {
        experiment.run((config) => "x", _cases());
      }
      expect(experiment.selectedLabels.length, Experiment.maxSelectedLabels);
    });
  });

  group("ExperimentMasamuneAdapter.overrides", () {
    test("overrides take precedence before loading", () {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(
          values: {_key: "a"},
          overrides: {_key: "b"},
        ),
      );
      expect(
        experiment.run((config) => config.getString(_key), _cases()),
        "B",
      );
    });

    test("overrides take precedence after loading", () async {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter(
          modelAdapter: RuntimeModelAdapter(
            database: NoSqlDatabase(),
            initialValue: const [
              DynamicModelInitialDocument(
                ExperimentMasamuneAdapter.documentPath,
                {_key: "a"},
              ),
            ],
          ),
          overrides: const {_key: "b"},
        ),
      );
      await experiment.load();
      expect(experiment.config.getString(_key), "b");
      expect(
        experiment.run((config) => config.getString(_key), _cases()),
        "B",
      );
    });

    test("every case can be fixed by overrides", () {
      const expected = {
        "a": "treatment_a",
        "b": "treatment_b",
        "other": "control",
      };
      for (final entry in expected.entries) {
        final experiment = Experiment(
          adapter: ExperimentMasamuneAdapter.test(
            overrides: {_key: entry.key},
          ),
        );
        experiment.run((config) => config.getString(_key), _cases());
        expect(experiment.selectedLabels, [entry.value]);
      }
    });
  });

  group("Experiment.load", () {
    late ExperimentMasamuneAdapter adapter;

    setUp(() {
      adapter = ExperimentMasamuneAdapter(
        modelAdapter: RuntimeModelAdapter(
          database: NoSqlDatabase(),
          initialValue: const [
            DynamicModelInitialDocument(
              ExperimentMasamuneAdapter.documentPath,
              {_key: "a"},
            ),
          ],
        ),
        defaults: const {_key: "default"},
      );
    });

    test("uses defaults before loading", () {
      final experiment = Experiment(adapter: adapter);
      expect(experiment.loaded, isFalse);
      expect(experiment.config.getString(_key), "default");
      expect(
        experiment.run((config) => config.getString(_key), _cases()),
        "control",
      );
    });

    test("notifies listeners once after loading", () async {
      final experiment = Experiment(adapter: adapter);
      var notified = 0;
      experiment.addListener(() => notified++);
      final future = experiment.load();
      expect(experiment.loading, isNotNull);
      await future;
      expect(experiment.loaded, isTrue);
      expect(experiment.loading, isNull);
      expect(notified, 1);
      expect(experiment.config.getString(_key), "a");
      expect(
        experiment.run((config) => config.getString(_key), _cases()),
        "A",
      );
      await experiment.load();
      expect(notified, 1);
      await experiment.reload();
      expect(notified, 2);
    });

    test("uses the primary adapter", () async {
      adapter.onInitScope(adapter);
      final experiment = Experiment();
      await experiment.load();
      expect(experiment.adapter, adapter);
      expect(experiment.config.getString(_key), "a");
    });

    test("uses initialValue of FirebaseRemoteConfigModelAdapter as defaults",
        () {
      const adapter = ExperimentMasamuneAdapter(
        modelAdapter: FirebaseRemoteConfigModelAdapter(
          initialValue: {_key: "b"},
        ),
      );
      expect(adapter.defaults, {_key: "b"});
      final experiment = Experiment(adapter: adapter);
      expect(
        experiment.run((config) => config.getString(_key), _cases()),
        "B",
      );
    });
  });

  group("ExperimentConfig", () {
    test("converts values like Firebase Remote Config", () {
      const config = ExperimentConfig({
        "bool_string": "true",
        "bool_yes": "Yes",
        "bool_one": 1,
        "bool_false": "false",
        "bool": true,
        "int": 10,
        "int_string": "20",
        "double": 1.5,
        "double_string": "2.5",
        "string": "text",
      });
      expect(config.getBool("bool_string"), isTrue);
      expect(config.getBool("bool_yes"), isTrue);
      expect(config.getBool("bool_one"), isTrue);
      expect(config.getBool("bool_false"), isFalse);
      expect(config.getBool("bool"), isTrue);
      expect(config.getInt("int"), 10);
      expect(config.getInt("int_string"), 20);
      expect(config.getInt("string"), 0);
      expect(config.getDouble("double"), 1.5);
      expect(config.getDouble("double_string"), 2.5);
      expect(config.getDouble("int"), 10.0);
      expect(config.getString("string"), "text");
      expect(config.getString("bool"), "true");
      expect(config.containsKey("string"), isTrue);
      expect(config.containsKey("unknown"), isFalse);
      expect(config.getAll().length, 10);
    });

    test("returns empty values for undefined keys", () {
      const config = ExperimentConfig({});
      expect(config.getString("unknown"), "");
      expect(config.getBool("unknown"), isFalse);
      expect(config.getInt("unknown"), 0);
      expect(config.getDouble("unknown"), 0.0);
    });
  });

  group("Widget", () {
    Widget build(Experiment experiment) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: ListenableBuilder(
          listenable: experiment,
          builder: (context, _) {
            return experiment.run(
                  (config) => config.getString(_key),
                  [
                    ExperimentCase.equals(
                      "treatment",
                      label: "treatment",
                      run: () => const Text("treatment"),
                    ),
                    ExperimentCase.otherwise(
                      label: "control",
                      run: () => const Text("control"),
                    ),
                  ],
                ) ??
                const SizedBox();
          },
        ),
      );
    }

    testWidgets("rebuilds after loading", (tester) async {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter(
          modelAdapter: RuntimeModelAdapter(
            database: NoSqlDatabase(),
            initialValue: const [
              DynamicModelInitialDocument(
                ExperimentMasamuneAdapter.documentPath,
                {_key: "treatment"},
              ),
            ],
          ),
          defaults: const {_key: "control"},
        ),
      );
      await tester.pumpWidget(build(experiment));
      expect(find.text("control"), findsOneWidget);
      await tester.runAsync(experiment.load);
      await tester.pump();
      expect(find.text("treatment"), findsOneWidget);
    });

    for (final label in ["treatment", "control"]) {
      testWidgets("shows the $label branch fixed by overrides", (tester) async {
        final experiment = Experiment(
          adapter: ExperimentMasamuneAdapter.test(
            overrides: {_key: label},
          ),
        );
        await tester.pumpWidget(build(experiment));
        expect(find.text(label), findsOneWidget);
        expect(experiment.selectedLabels, [label]);
      });
    }
  });
}
