<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model Turso</h1>
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

# Usage

`TursoModelAdapter` supports Cloudflare Workers access and direct Turso access
with a scoped short-lived token.

```dart
final adapter = TursoModelAdapter(
  functionsAdapter: CloudflareFunctionsAdapter(
    endpoint: "https://example.workers.dev",
  ),
  database: "main",
);
```

Use the following path format:

```text
database/<database_id>/<table_id>/<document_id>
database/<database_id>/<table_id>
```

Simple Masamune paths are also accepted and resolved with `database`.

```text
users/user_1
users
```

## Direct Turso access

Set `useDirectClient`. The adapter requests a token through
`/turso/token/database/{database}`, then connects to Turso with `libsql_dart`.

```dart
final adapter = TursoModelAdapter(
  functionsAdapter: CloudflareFunctionsAdapter(
    endpoint: "https://example.workers.dev",
  ),
  useDirectClient: true,
);
```

The adapter always uses the URL resolved by the Workers token endpoint. This
supports direct access to dynamically created databases and prevents clients
from pinning a fixed database URL.

When direct access is enabled, client-side rules checks are not performed. The
short-lived database token is resolved by the Workers backend. The adapter sends
table `targets` only when it needs table-level Masamune rules to decide whether
reads or writes must fall back to FunctionsActions.

If the token response includes `readMode: "functions"`, reads are sent through
`TursoGetModelFunctionsAction` instead of direct `libsql_dart` access. If it
includes `writeMode: "functions"`, saves, deletes, batches, and transactions are
sent through the Turso FunctionsActions.

When both read and write are functions-only, the backend can omit `token`,
`expiresAt`, and `url`. The adapter follows the returned modes and uses the
FunctionsActions without opening a direct libSQL connection.

Workers fallback requests use path-based Turso endpoints:

```text
/turso/database/main/users/user_1
/turso/database/main/users?where=[{"type":"equalTo","key":"name","value":"Alice"}]
/turso/token/database/main
```

## Supported queries

Collection load converts supported `ModelQueryFilter` values to Turso SQL or
Workers request conditions.

- `equalTo`
- `notEqualTo`
- `lessThan`
- `lessThanOrEqualTo`
- `greaterThan`
- `greaterThanOrEqualTo`
- `whereIn`
- `whereNotIn`
- `isNull`
- `isNotNull`
- `like`
- `orderByAsc`
- `orderByDesc`
- `limit`

`geoHash`, `nearest`, `and`, `or`, and `raw` are not supported in the first
implementation. `arrayContains` and `arrayContainsAny` are rejected by direct
SQL and Workers SQL until JSON1 behavior is fixed across both paths.

## Schema migration

On direct save, the adapter creates the table if needed and adds missing
columns. Existing column type changes, field renames, field deletions, primary
key changes, unique constraints, and foreign keys are not automatically
migrated.

Workers access delegates database/table creation and additive migration to
`@mathrunet/masamune_cloudflare_turso`.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
