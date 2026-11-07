<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Experiment</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)


# Masamune Experiment

Define A/B tests and feature switches in a single synchronous function based on Firebase Remote Config values.

- Values are loaded through [masamune_model_firebase_remote_config](https://pub.dev/packages/masamune_model_firebase_remote_config) and kept in memory, so branches are evaluated synchronously.
- Every branch has a label, and the first branch whose condition matches is executed.
- Branches can be fixed with `overrides` for debugging and tests, or with `fixed` after an A/B test is finished.
- The exposed branch can be recorded as an analytics user property with `ExperimentExposure`.
- A/B tests are performed only on the client. See [Server Side](#server-side).

## Usage

### Installation

1. Add the package to your project.

```bash
flutter pub add masamune_experiment
```

Or enable `firebase.experiment.enable` in `katana.yaml` and run `katana apply`.

```yaml
firebase:
  experiment:
    enable: true
```

### Setup

2. Register `ExperimentMasamuneAdapter`. Pass `FirebaseOptions` or a `FirebaseRemoteConfig` instance to `FirebaseRemoteConfigModelAdapter`. `initialValue` is used before loading and when values cannot be fetched, so set the control values there.

```dart
// lib/main.dart

import 'package:masamune_experiment/masamune_experiment.dart';

final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  ExperimentMasamuneAdapter(
    modelAdapter: FirebaseRemoteConfigModelAdapter(
      options: DefaultFirebaseOptions.currentPlatform,
      initialValue: {
        "new_button": "control",
      },
    ),
  ),
];
```

### Load Values

3. Get the `Experiment` controller and call `load()` at the beginning of the page. When loading is complete, the page is rebuilt.

```dart
class HomePage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final experiment = ref.app.controller(Experiment.query())..load();

    // ...
  }
}
```

### Define Branches

4. Define all branches inside `Experiment.run`.

- The first argument receives `ExperimentConfig` (same getters as `FirebaseRemoteConfig`) and returns the value used for the conditions. It is evaluated only once.
- The second argument is the list of `ExperimentCase`. Each case has a `label`, a condition `when`, and a process `run`. Cases are evaluated from the top, and only the first matching `run` is executed.
- The return value of `run` becomes the return value of `Experiment.run`, so you can return widgets or data. If `run` returns a `Future`, `Experiment.run` returns the `Future`.
- `fixed` executes the case with the same label regardless of the conditions. Use it to fix the winner after an A/B test.

```dart
final button = experiment.run(
  (config) => config.getString("new_button"),
  [
    ExperimentCase.equals(
      "treatment",
      label: "treatment",
      run: () => const NewButton(),
    ),
    ExperimentCase(
      label: "treatment_large",
      when: (value) => value.startsWith("large"),
      run: () => const LargeButton(),
    ),
    ExperimentCase.otherwise(
      label: "control",
      run: () => const OldButton(),
    ),
  ],
  // fixed: "treatment",
);
```

`Experiment.run` is synchronous. Load values in advance with `Experiment.load`. Before loading, `initialValue` is used.

If the return types of the cases differ, specify type arguments explicitly, such as `run<String, Widget>(...)`.

### Record Exposures

Pass `ExperimentExposure` to `Experiment.run` to record which branch the user actually saw. The `ExperimentLoggerEvent.exposure` event is sent to `LoggerAdapter.primary` and `ExperimentMasamuneAdapter.loggerAdapters` with the following parameters.

| Parameter | Value |
| --- | --- |
| `user_property` | `ExperimentExposure.userProperty` |
| `value` | `<experimentId>:<label>` |
| `experiment_id` | `ExperimentExposure.experimentId` |
| `label` | Label of the selected `ExperimentCase` |

With [masamune_logger_firebase](https://pub.dev/packages/masamune_logger_firebase), the event is stored as the Firebase Analytics user property `user_property` with the value `value`.

```dart
final button = experiment.run(
  (config) => config.getString("new_button"),
  [
    ExperimentCase.equals("treatment", label: "treatment", run: () => const NewButton()),
    ExperimentCase.otherwise(label: "control", run: () => const OldButton()),
  ],
  exposure: const ExperimentExposure(
    userProperty: "ab_slot_1",
    experimentId: "F-20261107-01",
  ),
);
```

- `userProperty` must start with a letter, contain only letters, digits and underscores, be at most 24 characters and must not start with `firebase_`, `google_` or `ga_`.
- `<experimentId>:<label>` must be at most 36 characters.
- The exposure is not sent before loading, when `fixed` is specified, when the first callback reads a key in `overrides`, or when no case matches.
- The same pair of `userProperty` and value is sent only once per process.

**Await `load()` at startup.** Exposures are not sent before loading, so the first screen would otherwise show the default branch without recording it. Load the values before the first `run`, for example in a boot process:

```dart
await appRef.controller(Experiment.query()).load();
```

Logger adapters passed to `ExperimentMasamuneAdapter.loggerAdapters` are also added to the logger adapters of the app, like other Masamune adapters.

### Fix Branches for Debugging and Tests

`overrides` always take precedence over the loaded values. Pass them only in debug or test flavors.

```dart
ExperimentMasamuneAdapter(
  modelAdapter: FirebaseRemoteConfigModelAdapter(
    options: DefaultFirebaseOptions.currentPlatform,
    initialValue: {"new_button": "control"},
  ),
  overrides: {
    if (const String.fromEnvironment("EXPERIMENT_NEW_BUTTON").isNotEmpty)
      "new_button": const String.fromEnvironment("EXPERIMENT_NEW_BUTTON"),
  },
);
```

## Testing

Write at least one test for every `ExperimentCase` label. `ExperimentMasamuneAdapter.test` does not use Firebase, and `Experiment.selectedLabels` returns the labels selected by `run`.

```dart
for (final label in ["treatment", "control"]) {
  test("selects $label", () {
    final experiment = Experiment(
      adapter: ExperimentMasamuneAdapter.test(
        overrides: {"new_button": label},
      ),
    );
    buildButton(experiment);
    expect(experiment.selectedLabels, [label]);
  });
}
```

For widget tests and golden tests, pass `ExperimentMasamuneAdapter.test(overrides: {...})` to the adapters of the app under test and capture each branch.

## Server Side

A/B tests are not performed on the server. The client and the server may evaluate conditions differently, so branching on both sides is risky.

When a branch on the client needs server changes, the server must support the requests of all branches (backward compatible) and test all of them.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
