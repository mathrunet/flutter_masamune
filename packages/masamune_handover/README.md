<big>**^ Please click here for description of Masamune framework ^**</big>

# Masamune Handover

Plug-in for Masamune that remotely controls maintenance mode, announcements, feature flags and endpoint switching for application handover (buyout) scenarios.

## Overview

When an application is sold or transferred to another company (buyout), backend keys, store accounts and third-party services must be switched over. This plug-in embeds a remote control plane into the application **at release time**, so that during the transfer the application can be:

- **Announced** (`announce`): show a dismissible banner before the maintenance window.
- **Made read-only** (`readonly`): disable write-type features (purchases, posts, etc.) via feature flags while data is being migrated.
- **Put into maintenance** (`maintenance`): show a full-screen maintenance page with an estimated end time.
- **Re-pointed** (`endpoints`): switch API base URLs, ad unit IDs, and other identifiers to the new owner's resources without an app update.
- **Force-updated** (`force_update`): distribute the minimum required version for integration with `masamune_force_updater`.

## Configuration source

The configuration is retrieved from a public static JSON file:

```
https://api.mathru.net/apps/{app_id}.json
```

**Absence of the file (404) and all network failures are normal conditions.** The application silently falls back to the last cached configuration, or runs in normal mode. No errors are ever surfaced to the user.

### File format

The handover configuration lives in the `handover` section of the per-app configuration file, so it can coexist with other application settings:

```jsonc
{
  "handover": {
    "mode": "normal",                      // normal | announce | readonly | maintenance
    "message": { "ja": "...", "en": "..." },
    "scheduled_at": "2026-10-01T00:00:00Z",
    "estimated_end_at": "2026-10-01T06:00:00Z",
    "endpoints": { "api_base_url": "https://api.example.com" },
    "features": { "purchase": true },
    "force_update": {
      "min_version": "2.0.0",
      "store_url_ios": "...",
      "store_url_android": "..."
    }
  }
}
```

### Delegation (handover of the control plane itself)

Because `api.mathru.net` is not transferred with the application, the configuration supports delegation. After the buyout completes, place:

```json
{ "handover": { "delegate_url": "https://config.new-owner.example/handover.json" } }
```

The application will then follow the delegate URL (up to 3 hops) so the new owner gains full control of the control plane **without an app update**. Deleting the file entirely is also safe — the application simply runs in normal mode.

## Usage

Register the adapter in `main.dart`:

```dart
final handoverAdapter = HandoverMasamuneAdapter(
  appId: "myapp",
);
```

Check feature flags and endpoints from anywhere:

```dart
final handover = ref.app.controller(Handover.query());
if (handover.isFeatureEnabled("purchase")) {
  // ...
}
final apiBaseUrl = handover.endpoint(
  "api_base_url",
  defaultValue: "https://api.default.example",
);
```

### Signature verification (optional)

To protect against a compromised distribution origin, pass a `verify` callback that validates the retrieved JSON (e.g. JWS):

```dart
HandoverMasamuneAdapter(
  appId: "myapp",
  verify: (json) async => myJwsVerify(json),
);
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
