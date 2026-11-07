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

class _RecordingLoggerAdapter extends LoggerAdapter {
  _RecordingLoggerAdapter();

  final List<({String name, DynamicMap? parameters})> logs = [];

  @override
  Future<List<LogValue>> logList() async => [];

  @override
  Future<void> send(String name, {DynamicMap? parameters}) async {
    logs.add((name: name, parameters: parameters));
  }

  @override
  LoggerTraceValue trace(String name) => throw UnimplementedError();
}

const _exposure = ExperimentExposure(
  userProperty: "ab_slot_2",
  experimentId: "F-20261107-01",
);

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

  group("ExperimentExposure", () {
    late _RecordingLoggerAdapter logger;

    setUp(() {
      logger = _RecordingLoggerAdapter();
      Experiment.clearSentExposures();
    });

    Future<Experiment> loaded(
      Map<String, Object?> values, {
      Map<String, Object?> overrides = const {},
    }) async {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(
          values: values,
          overrides: overrides,
          loggerAdapters: [logger],
        ),
      );
      await experiment.load();
      return experiment;
    }

    test("sends the exposure of the selected case after loading", () async {
      final experiment = await loaded({_key: "b"});
      final result = experiment.run(
        (config) => config.getString(_key),
        _cases(),
        exposure: _exposure,
      );
      expect(result, "B");
      expect(logger.logs, hasLength(1));
      expect(logger.logs.single.name, "ExperimentLoggerEvent.exposure");
      expect(logger.logs.single.parameters, {
        "user_property": "ab_slot_2",
        "value": "F-20261107-01:treatment_b",
        "experiment_id": "F-20261107-01",
        "label": "treatment_b",
      });
    });

    test("does not send without exposure", () async {
      final experiment = await loaded({_key: "b"});
      experiment.run((config) => config.getString(_key), _cases());
      expect(logger.logs, isEmpty);
    });

    test("does not send before loading", () {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(
          values: {_key: "a"},
          loggerAdapters: [logger],
        ),
      );
      expect(
        experiment.run(
          (config) => config.getString(_key),
          _cases(),
          exposure: _exposure,
        ),
        "A",
      );
      expect(logger.logs, isEmpty);
    });

    test("does not send when fixed is specified", () async {
      final experiment = await loaded({_key: "a"});
      experiment.run(
        (config) => config.getString(_key),
        _cases(),
        fixed: "control",
        exposure: _exposure,
      );
      expect(logger.logs, isEmpty);
    });

    test("does not send when the value is fixed by overrides", () async {
      final experiment = await loaded({_key: "a"}, overrides: {_key: "b"});
      expect(
        experiment.run(
          (config) => config.getString(_key),
          _cases(),
          exposure: _exposure,
        ),
        "B",
      );
      expect(logger.logs, isEmpty);
    });

    test("sends when overrides contain only unrelated keys", () async {
      final experiment =
          await loaded({_key: "a"}, overrides: {"other_key": "x"});
      experiment.run(
        (config) => config.getString(_key),
        _cases(),
        exposure: _exposure,
      );
      expect(logger.logs, hasLength(1));
    });

    test("does not send when getAll is read with overrides", () async {
      final experiment =
          await loaded({_key: "a"}, overrides: {"other_key": "x"});
      experiment.run(
        (config) => config.getAll()[_key]?.toString() ?? "",
        _cases(),
        exposure: _exposure,
      );
      expect(logger.logs, isEmpty);
    });

    test("does not send when no case matches", () async {
      final experiment = await loaded({});
      experiment.run(
        (config) => config.getBool(_key),
        [ExperimentCase.equals(true, label: "treatment", run: () => 1)],
        exposure: _exposure,
      );
      expect(logger.logs, isEmpty);
    });

    test("sends the same user property and value only once per process",
        () async {
      final first = await loaded({_key: "a"});
      final second = await loaded({_key: "a"});
      for (var i = 0; i < 3; i++) {
        first.run(
          (config) => config.getString(_key),
          _cases(),
          exposure: _exposure,
        );
      }
      second.run(
        (config) => config.getString(_key),
        _cases(),
        exposure: _exposure,
      );
      expect(logger.logs, hasLength(1));
      // A different value or user property is sent again.
      first.run((config) => "b", _cases(), exposure: _exposure);
      first.run(
        (config) => "b",
        _cases(),
        exposure: const ExperimentExposure(
          userProperty: "ab_slot_3",
          experimentId: "F-20261107-01",
        ),
      );
      expect(
        logger.logs.map((e) =>
            "${e.parameters?["user_property"]}=${e.parameters?["value"]}"),
        [
          "ab_slot_2=F-20261107-01:treatment_a",
          "ab_slot_2=F-20261107-01:treatment_b",
          "ab_slot_3=F-20261107-01:treatment_b",
        ],
      );
    });

    test("errors of the logger do not break the branch", () async {
      final experiment = Experiment(
        adapter: ExperimentMasamuneAdapter.test(
          values: {_key: "a"},
          loggerAdapters: [const _ThrowingLoggerAdapter(), logger],
        ),
      );
      await experiment.load();
      expect(
        experiment.run(
          (config) => config.getString(_key),
          _cases(),
          exposure: _exposure,
        ),
        "A",
      );
      await Future<void>.delayed(Duration.zero);
      expect(logger.logs, hasLength(1));
    });

    for (final name in [
      "1slot",
      "ab-slot",
      "ab slot",
      "firebase_slot",
      "google_slot",
      "ga_slot",
    ]) {
      test("asserts an invalid user property: $name", () async {
        final experiment = await loaded({_key: "a"});
        expect(
          () => experiment.run(
            (config) => config.getString(_key),
            _cases(),
            exposure: ExperimentExposure(
              userProperty: name,
              experimentId: "F-20261107-01",
            ),
          ),
          throwsA(isA<AssertionError>()),
        );
        expect(logger.logs, isEmpty);
      });
    }

    test("asserts a user property longer than 24 characters", () {
      expect(
        () => ExperimentExposure(
          userProperty: "a" * 25,
          experimentId: "F-20261107-01",
        ),
        throwsA(isA<AssertionError>()),
      );
      expect(
        ExperimentExposure(userProperty: "a" * 24, experimentId: "x")
            .isValidUserProperty,
        isTrue,
      );
    });

    test("asserts a value longer than 36 characters", () async {
      final experiment = await loaded({_key: "a"});
      expect(
        () => experiment.run(
          (config) => config.getString(_key),
          _cases(),
          exposure: ExperimentExposure(
            userProperty: "ab_slot_2",
            experimentId: "x" * 25,
          ),
        ),
        throwsA(isA<AssertionError>()),
      );
      expect(logger.logs, isEmpty);
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

class _ThrowingLoggerAdapter extends LoggerAdapter {
  const _ThrowingLoggerAdapter();

  @override
  Future<List<LogValue>> logList() async => [];

  @override
  Future<void> send(String name, {DynamicMap? parameters}) {
    throw StateError("failed");
  }

  @override
  LoggerTraceValue trace(String name) => throw UnimplementedError();
}
