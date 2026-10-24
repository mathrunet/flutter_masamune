<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana CLI</h1>
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

Command line interface used in the [Masamune framework](https://pub.dev/packages/masamune).

The following features are available

- Project creation and optimization against the Masamune framework
- Code template generation
- Automatic code generation with [build_runner](https://pub.dev/packages/build_runner)
- Other settings

# Installation

Install with the following command.

```bash
flutter pub global activate katana_cli
```

Check the dependencies of the commands used internally. If these do not all pass, it may not work properly.

```bash
katana doctor
```

# How to use

The following commands are available

```bash
katana [command] [subcommand] [optional parameters]
```

Help for the command is available at

```bash
katana help
```

## Project Creation

Execute the following command in the folder where the project was created.

The `Application ID` should include the ID in the reverse domain (com.test.myapplication).

```bash
katana create [Application ID(e.g. com.test.myapplication)]
```

## Code generation

The following commands can be used to generate each code template.

```bash
katana code [Code ID] [Optional Parameters]
```

### Page

Create page templates under `lib/pages`.

```bash
katana code page [PageName]
```

### Collection Model

Create a collection model under `lib/models`.

```bash
katana code collection [ModelName]
```

### Document Model

Create a document model under `lib/models`.

```bash
katana code document [ModelName]
```

### Controller

Create controllers under `lib/controllers`.

```bash
katana code controller [ControllerName]
```

For other codes, please see Help.

### Masamune AI Debugger

Add the AI Debugger dependency, configure all flavor dart-defines, and register
one adapter instance in a standard Masamune project.

```bash
katana code debuggable
```

`MASAMUNE_AI_DEBUGGER_API_KEY` and `MASAMUNE_AI_DEBUGGER_ACCOUNTS` are written
as `${MASAMUNE_AI_DEBUGGER_API_KEY:-}` and `${MASAMUNE_AI_DEBUGGER_ACCOUNTS:-}`
references instead of their values, so these variables must be set when the app
is built or launched. Existing values in `dart_defines/*.env` are kept.

## Automatic code generation with build_runner

You must have build_runner installed in your project in order to run it.

```bash
flutter pub add --dev build_runner
```

## Development and production environments

New projects use `dart_defines/dev.env` and `dart_defines/prod.env`. Run Flutter
with `--dart-define-from-file`; Flutter's native `--flavor` option and the
legacy `katana flavor` pre-copy workflow are not required.

```bash
flutter run --dart-define-from-file=dart_defines/dev.env
flutter build appbundle --dart-define-from-file=dart_defines/prod.env
katana apply --flavor dev
katana deploy --flavor prod
```

`FLAVOR` must be `dev` or `prod`. Android may optionally set
`ANDROID_APPLICATION_ID`; otherwise Android, iOS, and macOS keep the common ID
created by `katana compose`. Firebase configuration and Wrangler bindings are
selected with the same `FLAVOR`. Worker endpoints remain explicit Dart adapter
parameters and are never written to dart-defines.

Run `katana apply --flavor dev` and `katana apply --flavor prod` once for each
environment. The order does not matter and reapplying one environment preserves
the other environment. Cloudflare keeps both projects in one `wrangler.jsonc`
under `env.dev` and `env.prod`. Firebase shares the deploy configuration in
`firebase/firebase.json` and stores both project mappings as `dev` and `prod`
aliases in `firebase/.firebaserc`. Katana commands also pass the resolved project
or environment explicitly, so they do not depend on the Firebase `default`
alias or Wrangler's top-level environment. Wrangler's top-level Worker name is
kept fixed to the production/base project so applying dev does not rewrite it.
When running Wrangler directly, always pass `--env dev` or `--env prod`; use
`katana deploy --flavor <flavor>` for the guarded deployment flow.

Existing projects can be inspected without changes and migrated explicitly:

```bash
katana fix
katana fix --dry-run
katana fix --apply
```

Create Firebase and Cloudflare projects before running apply. Katana does not
create those projects automatically.

## Environment variables in katana.yaml

String values in `katana.yaml` and `katana_secrets.yaml` can reference
environment variables with `${NAME}`. References are expanded when the files are
loaded, so secrets can be supplied by CI or a shell instead of being written to
the files.

```yaml
cloudflare:
  api_token: ${CLOUDFLARE_API_TOKEN}
  endpoint: https://${API_HOST:-api.example.com}/v1
  literal: $${NOT_EXPANDED}
```

- `${NAME}` is replaced with the value of `NAME`. Katana stops with an error if
  `NAME` is not defined.
- `${NAME:-default}` uses `default` when `NAME` is undefined or empty.
- `$${NAME}` is kept as the literal `${NAME}`.
- Only `${...}` is expanded; `$NAME` without braces is left as is. Map keys are
  not expanded.
- Commands that update `katana.yaml` keep the `${NAME}` references and never
  write expanded values back.

## Firebase Functions secrets without dotenv files

Opt into Secret Manager for v2 Firebase Functions:

```yaml
firebase:
  project_id:
    dev: my-app-dev
    prod: my-app-prod
  functions:
    enable: true
    secret_manager: true
    secrets:
      CUSTOM_API_KEY: ${CUSTOM_API_KEY}
sendgrid:
  enable: true
  api_key: ${SENDGRID_API_KEY}
```

Supply the environment variables through Samurai Passwords or CI secrets, then
run `katana apply --flavor dev` to configure plugins and deploy. Subsequent
`katana deploy --flavor dev` calls register the additional `functions.secrets`
values and deploy the existing Functions code. Reapply after changing plugin
settings so their new values are registered.

- Plugin settings that previously went into `firebase/functions/.env` stay in
  memory and are registered through the installed `firebase-tools` Node API with stdin
  immediately before the consolidated deployment. No secret values are placed in
  process arguments or dotenv files. Secret-registration subprocess output is
  discarded to prevent accidental disclosure, including on errors. Using the Node
  API avoids the CLI entrypoint's `firebase-debug.log`, which can include request
  payloads. An npm-installed Firebase CLI and Node.js are required; standalone
  Firebase executables are rejected. Override `bin.node` if needed.
- Only secret names are written to a managed block in
  `firebase/functions/src/index.ts`. The block calls v2 `setGlobalOptions` before
  function registration; all v2 functions in that codebase receive these secrets
  through their existing `process.env` names. Functions with explicit `secrets`
  options must include the needed names themselves. Legacy v1 functions require
  their own bindings. Secret names are tracked separately for dev and prod.
- Each non-empty value registered during apply or deploy creates a new Secret
  Manager version. Registration failure stops deployment; previously registered
  versions are not rolled back automatically. Firebase authentication, Secret
  Manager permissions, and applicable Google Cloud billing are required.
- Existing `.env` and `.env.*` files cause this mode to stop without reading or
  deleting them. Migrate their settings into Passwords and configuration, and
  remove legacy files once the migration is confirmed. Existing custom
  `setGlobalOptions(...)` calls must be reconciled before using the managed block.
- `--local` never uploads secrets or deploys. With Secret Manager disabled or
  omitted, the existing dotenv behavior remains available. When switching back,
  remove the managed secret block from `index.ts` as part of that migration.
- This configures runtime settings. The Firebase CLI still uses its existing
  Google login or Application Default Credentials for deployment authentication.

## Android signing with environment variables

When `app.keystore.enable` is `true`, the Android signing configuration can be
supplied entirely by environment variables instead of keystore files.

| Variable | Description |
| --- | --- |
| `ANDROID_KEYSTORE_B64` | Base64 encoded keystore. |
| `ANDROID_KEYSTORE_PASSWORD` | Password for both the store and the key. |
| `ANDROID_KEYSTORE_ALIAS` | Optional. Overrides `app.keystore.alias`. |
| `GPC_SERVICE_ACCOUNT_KEY_B64` | Optional. Base64 encoded Google Play service account key used by GitHub Actions. |

- If `ANDROID_KEYSTORE_B64` and `ANDROID_KEYSTORE_PASSWORD` are set, `katana apply`
  does not create `appkey.keystore`, `key.properties`, or the password file. It
  only configures Gradle.
- At build time, Gradle decodes the keystore into
  `build/app/signing/upload.keystore`. Release and debug builds use it, so the
  signature stays the same between local builds and CI.
- If the variables are not set, Gradle falls back to `android/key.properties`.
  Debug builds without either use the default debug key.
- With `github.action` enabled, `katana apply` registers the values as
  `ANDROID_KEYSTORE_B64_<APP>`, `ANDROID_KEYSTORE_PASSWORD_<APP>`,
  `ANDROID_KEYSTORE_ALIAS_<APP>` (when set), and
  `ANDROID_SERVICE_ACCOUNT_KEY_JSON_<APP>`. The generated workflow passes them to
  Gradle as environment variables. Secret values are passed to `gh` through
  standard input.

## iOS signing with environment variables

With `github.action` enabled for iOS, the signing files under `ios/` can be
replaced by environment variables. Files take precedence, so existing projects
keep working unchanged.

| Variable | Replaces | GitHub Secret |
| --- | --- | --- |
| `ASC_KEY_ID` | Key ID in `ios/AuthKey_<KEY_ID>.p8` | `IOS_API_KEY_ID_<APP>` |
| `ASC_PRIVATE_KEY_B64` | Base64 encoded `ios/AuthKey_<KEY_ID>.p8` | `IOS_API_AUTHKEY_P8_<APP>` |
| `ASC_ISSUER_ID` | `github.action.ios.issuer_id` when it is empty | `IOS_API_ISSUER_ID_<APP>` |
| `IOS_DEVELOPMENT_CERTIFICATE_B64` | Base64 encoded `development.cer` (DER or PEM) | `IOS_CERTIFICATES_P12_<APP>` (p12) |
| `IOS_CERTIFICATE_SIGNING_REQUEST_KEY_B64` | Base64 encoded `ios/ios_enterprise.key` (PEM) | `IOS_CERTIFICATES_P12_<APP>` (p12) |

- The App Store Connect API key is read from `ios/AuthKey_<KEY_ID>.p8` if it
  exists, otherwise from `ASC_KEY_ID` and `ASC_PRIVATE_KEY_B64`.
- The certificate is read from `ios/*.p12` with
  `ios/ios_certificate_password.key` if both exist. Otherwise `katana apply`
  creates the p12 with `openssl` from `IOS_DEVELOPMENT_CERTIFICATE_B64` and
  `IOS_CERTIFICATE_SIGNING_REQUEST_KEY_B64` in an owner-only temporary
  directory that is deleted afterwards. A random password is generated each
  time and registered as `IOS_CERTIFICATE_PASSWORD_<APP>`. With OpenSSL 3 the p12
  uses SHA1-3DES encryption and a SHA1 MAC so that the macOS keychain can import
  it.
- When the variables are set, `katana app csr` and `katana app p12` do not
  create `ios_enterprise.key`, the CSR, or p12 files.
- If neither files nor variables are available, the error message lists the
  variables to set. Secret values are passed to `gh` through standard input and
  are never printed.

## Expanding dart_defines for VSCode

`dart_defines/<flavor>.env` can reference environment variables with `${NAME}`
using the same syntax as `katana.yaml`. Expand them with:

```bash
katana code dart_defines dev   # one flavor
katana code dart_defines       # every dart_defines/*.env
```

The result is written to `build/katana/dart_defines/<flavor>.env` with
owner-only permissions. Files without `${` are copied as they are, so the same
path always works.

The `.vscode/launch.json` generated by `katana create` and `katana compose`
runs this command as a `preLaunchTask` defined in `.vscode/tasks.json` and
passes `--dart-define-from-file=build/katana/dart_defines/<flavor>.env`.
Environment variables are read from the environment VSCode was started with.
`katana apply` does not rewrite `.vscode`; to update an existing project, add
the following to `.vscode/tasks.json` and set `preLaunchTask` and the
`--dart-define-from-file` path in `.vscode/launch.json`:

```json
{
  "label": "katana: dart_defines dev",
  "type": "shell",
  "command": "katana",
  "args": ["code", "dart_defines", "dev"],
  "presentation": { "reveal": "silent" },
  "problemMatcher": []
}
```

```json
{
  "name": "Development",
  "request": "launch",
  "type": "dart",
  "preLaunchTask": "katana: dart_defines dev",
  "args": ["--dart-define-from-file=build/katana/dart_defines/dev.env", "--web-port=5555"]
}
```

### Automatic code generation

If you want to perform automatic code generation as a one-shot, execute the following command.

```bash
katana code generate
```

### Code generation monitoring

If you want to monitor code changes and automatically generate code when changes are made, execute the following command.

```bash
katana code watch
```

For other commands, please see Help.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)

### Location during an active session

`location.enable_background` controls the native background location capability.
`location.require_always_permission` defaults to `true` for compatibility. Set
it to `false` to keep that capability with WhenInUse authorization only:

```yaml
location:
  enable: true
  enable_background: true
  require_always_permission: false
  permission:
    en: Location is used during playback to adapt your soundtrack.
```

Apply the setting with `katana apply --local --only location --flavor dev` when
location dependencies and backend initialization already exist. The action
removes obsolete Always usage messages and Android background location
permission, preserves iOS background modes, enables Android location foreground
service permissions, and synchronizes the permission_handler/geolocator iOS
compilation flags. Reapplying or switching back to Always access is supported.
The application must start location updates while visible, stop them when its
active session ends, and handle denied permissions independently.

### Migrating deep links to a custom scheme

Use `app.deeplink.remove_hosts` to remove dedicated Android VIEW filters and iOS
`applinks` entries for explicitly listed HTTP(S) origins. Other URL handlers and
entitlements remain unchanged. Mixed Android filters are preserved; separate
unrelated origins before using this migration.

```yaml
app:
  deeplink:
    enable: true
    host: segue://track
    remove_hosts:
      - https://segue.day
```

Run `katana apply --only deeplink` to apply only the deep link settings. Existing
custom-scheme handlers remain available. Update the hosted association documents
separately when public HTTPS links should open a web page first.
