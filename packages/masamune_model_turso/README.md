<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"><br/>
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
  prefix: null,
  functionsAdapter: CloudflareFunctionsAdapter(
    endpoint: "https://example.workers.dev",
  ),
);
```

Use the following path format:

```text
database/<database_id>/<table_id>/<document_id>
database/<database_id>/<table_id>
```

## Automatic region selection without an explicit group

Configure the available `groups` and their country and continent mappings on the Node side to let Flutter omit the group.

```dart
final adapter = TursoModelAdapter(
  prefix: null,
  functionsAdapter: cloudflareFunctionsAdapter,
);
// The path remains database/user-abc/items/one.
```

For a new database, the Worker chooses a group using the request's region. For an existing database, it resolves the URL of its actual group, so the same database is used even when the user's location changes. Requests without region information use the Node-side default `group`, or the first entry in `groups` when no default is specified.

To request a placement for a new database, specify a group name registered on the server.

```dart
final adapter = CachedTursoModelAdapter(
  prefix: null,
  group: "prod-eu",
  functionsAdapter: cloudflareFunctionsAdapter,
);
```

`group` is a placement preference for new databases; it does not move existing databases or create a different database. The server resolver makes the final decision. `TursoGet/Put/Post/DeleteModelFunctionsAction` and `TursoTokenFunctionsAction` also accept an optional group. GET sends it as a query parameter; other methods send it in the JSON body. Model paths remain unchanged.

`TursoTokenFunctionsActionResponse.group` and `.primaryRegion` expose actual placement information when available. They are null with older servers or responses that do not resolve a database. Update the server before enabling explicit group selection in Flutter.

Connection sessions and caches distinguish endpoints, prefixes, and groups. When a session key is provided, local caches also distinguish authentication sessions. Old cache namespaces are not reused; the first read after upgrading fetches data again. To read stored data from `collectionLoaders`, use `adapter.loadCachedCollection(query)`.

See the [Node README](https://github.com/mathrunet/node_masamune/tree/main/packages/masamune_cloudflare_turso#multiple-groups-and-automatic-region-selection) for Node configuration and Katana YAML examples. Actual data access permissions are still evaluated by rules.

## Persistent local cache

Use `CachedTursoModelAdapter` when loaded data should remain available from a
device-local cache after the app restarts.

```dart
final adapter = CachedTursoModelAdapter(
  prefix: null,
  functionsAdapter: CloudflareFunctionsAdapter(
    endpoint: "https://example.workers.dev",
  ),
);
```

Documents are loaded from the local cache first. Call `reload()` on the
Masamune model when fresh remote data is required. Saves, deletes, batches, and
transactions keep the remote database, runtime cache, and persistent cache in
sync.

Use `cacheFilter` to exclude documents from the persistent cache. Collection
cache loading is opt-in through `collectionLoaders`, which can return cached
rows only or return a modified query to merge additional Turso rows.

```dart
late final CachedTursoModelAdapter adapter;
adapter = CachedTursoModelAdapter(
  prefix: null,
  cacheFilter: (_, value) => value["private"] != true,
  collectionLoaders: [
    (query, _) async {
      final cache = await adapter.loadCachedCollection(query);
      if (cache == null) {
        return null;
      }
      return CachedTursoModelCollectionLoaderResponse(value: cache);
    },
  ],
);
```

Pass a custom `cachedLocalDatabase` for testing or custom persistence behavior.
The default shared database stores native data in the application documents
area and Web data through the storage used by `DatabaseExporter`. Database
prefixes also isolate persistent cache entries.

## Separate development and production databases

Pass `prefix` to separate the physical database without changing model paths.
The adapter trims trailing underscores and adds exactly one underscore.

```dart
final developmentAdapter = TursoModelAdapter(
  prefix: "dev", // Normalized to "dev_".
  functionsAdapter: cloudflareFunctionsAdapter,
);
```

For `database/main/users`, the adapter above uses the physical database
`dev_main`. A null, empty, or underscore-only prefix keeps the existing
database name `main`, so production data does not require migration. Rules are
evaluated against the logical path `main/users`; only database connection and
token issuance use the physical name. Local caches are also separated by
prefix.

## Direct Turso access

Set `useDirectClient`. The adapter requests a token through
`/turso/token/database/{database}`, then connects to Turso with `libsql_dart`.

```dart
final adapter = TursoModelAdapter(
  prefix: null,
  functionsAdapter: CloudflareFunctionsAdapter(
    endpoint: "https://example.workers.dev",
  ),
  useDirectClient: true,
);
```

The adapter always uses the URL resolved by the Workers token endpoint. This
supports direct access to dynamically created databases and prevents clients
from pinning a fixed database URL.

TursoDB direct access is remote-only. The legacy libSQL Embedded Replica path
uses a SQLite-format local database and is not compatible with the TursoDB-only
policy; `TursoDirectClientSession(useEmbeddedReplica: true)` therefore throws
`UnsupportedError`. Use `CachedTursoModelAdapter` for device-local caching.

Direct batches and model transactions start with `BEGIN CONCURRENT`. If TursoDB
reports a row conflict or `SQLITE_BUSY` at commit, the adapter rolls back and
retries the whole transaction with bounded backoff. Cache synchronization only
happens after a successful commit.

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

`nearest` queries are routed through the Worker; see [Native vectors](#native-vectors)
for schema requirements and limits. `geoHash`, `and`, `or`, and `raw` are not
supported. `arrayContains` and `arrayContainsAny` are rejected by direct
SQL and Workers SQL until JSON1 behavior is fixed across both paths.

## Schema migration

On direct save, the adapter creates the table if needed and adds missing
columns. Existing column type changes, field renames, field deletions, primary
key changes, unique constraints, and foreign keys are not automatically
migrated.

Workers access delegates database/table creation and additive migration to
`@mathrunet/masamune_cloudflare_turso`.

## Native vectors

`TursoModelAdapter` and `CachedTursoModelAdapter` convert query text with `vectorConverter` and send `CollectionModelQuery.nearest("embedding", "search text")` to the Worker. Nearest-neighbor searches always query the Worker, including with the cached adapter, without merging stale local results or rankings. Document caching continues as usual.

`@TidbSchema(extraColumns: [TidbSchemaColumn("embedding", "VECTOR(3)", vectorMetric: "euclidean")])` declares the dimensions and distance metric of a `ModelVectorValue` column. Run `katana code generate` after adding it. The default metric is cosine. Use matching local versions of the annotation, builder, CLI, and Worker.
For Turso, also set `nativeVectors: true`. This routes all CRUD through the Worker and avoids the existing direct-connection TEXT type inference. The CLI converts VECTOR(N) to TursoDB F32_BLOB(N) while preserving the distance metric.
See the [Node README](https://github.com/mathrunet/node_masamune/tree/main/packages/masamune_cloudflare_turso#native-vectors) for input, query, and migration constraints. ANN indexes are not generated automatically.


# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
