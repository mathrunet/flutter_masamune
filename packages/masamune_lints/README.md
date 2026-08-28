<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Lints</h1>
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

---

Plug-in packages that add functionality to the Masamune Framework.

For more information about Masamune Framework, please click here.

[https://pub.dev/packages/masamune](https://pub.dev/packages/masamune)

## Requirements

- Dart 3.10 or later
- An editor or analysis command that supports the official Dart analyzer plug-in API

## Setup

Add `masamune_lints` to `dev_dependencies`, then enable the plug-in at the top
level of `analysis_options.yaml`:

```yaml
plugins:
  masamune_lints: ^4.0.0
```

For local development, the official path plug-in form is also supported:

```yaml
plugins:
  masamune_lints:
    path: ../masamune_lints
```

Version 4.0.0 is a breaking migration from `custom_lint`. Remove
`custom_lint` and `custom_lint_builder` from the consuming package, remove the
old `analyzer.plugins: [custom_lint]` configuration, and do not run
`dart run custom_lint`. Diagnostics, quick fixes, and assists are now provided
directly by the Dart analysis server.

The official `analysis_server_plugin` API requires a fixed `lib/main.dart`
entry point containing the top-level `plugin` object. That file was created as
the explicitly approved exception to the repository's Katana-template
requirement; no other manually created source entry point is introduced by this
migration.

## Diagnostics

The plug-in provides ten diagnostics with the same conditions and severity as
the 3.x implementation:

| Diagnostic | Severity |
| --- | --- |
| `masamune_model_should_load` | warning |
| `masamune_model_should_show_indicator_while_loading` | warning |
| `masamune_collection_model_should_add_limit_query` | warning |
| `masamune_scoped_query_must_pass_to_appropriate_ref` | error |
| `masamune_should_use_universal_widget` | warning |
| `masamune_should_use_form_widget` | warning |
| `masamune_limit_if_nesting` | warning |
| `masamune_unwrap_nullable` | warning |
| `masamune_caught_error_should_report` | warning |
| `masamune_expected_error_should_have_unexpected_catch` | warning |

It also provides one quick fix for reporting an unexpected caught error and
three kinds of button assists: add an icon, remove an icon, and convert the
Material button type.

### `flutter analyze` note

Some Flutter SDK releases can finish one-shot `flutter analyze` before an
official analyzer plug-in reports its diagnostics. The command still loads the
local path plug-in successfully, but use `dart analyze` or editor analysis when
you need deterministic plug-in diagnostics until the upstream Flutter/Dart
analysis-server timing issue is resolved.

## Error handling rules

Masamune distinguishes expected and unexpected errors by catch syntax.

```dart
try {
  await operation();
} on ValidationException catch (e) {
  handleValidationError(e);
} catch (e, stackTrace) {
  await appLogger.error(e, stackTrace);
  handleUnexpectedError();
}
```

- `masamune_expected_error_should_have_unexpected_catch` requires a final untyped catch when a try statement has typed catches for expected errors.
- `masamune_caught_error_should_report` requires an untyped catch to report the same caught error and stack trace with `appLogger.error`, unless it propagates the error with `rethrow` or `throw`.
- Typed `on XxxException catch` clauses declare expected errors and do not require incident reporting.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
