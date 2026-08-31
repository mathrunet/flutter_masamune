<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Model TiDB</h1>
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

Use `TidbModelAdapter` with `@mathrunet/masamune_cloudflare_tidb` Workers.

```dart
final adapter = TidbModelAdapter();
```

Model paths use the same layout as Turso.

```text
database/<database>/<table>/<document_id>
```

The adapter sends all reads and writes to the Workers CRUD endpoint. It does not
open direct MySQL/TiDB TCP connections from Flutter clients.

## Persistent local cache

Use `CachedTidbModelAdapter` when loaded data should remain available from a
device-local cache after the app restarts.

```dart
final adapter = CachedTidbModelAdapter();
```

Documents are loaded from the local cache first. Call `reload()` on the
Masamune model when fresh remote data is required. Saves, deletes, batches, and
transactions keep TiDB, the runtime cache, and the persistent cache in sync.

Use `cacheFilter` to exclude documents from the persistent cache. Collection
cache loading is opt-in through `collectionLoaders`, which can return cached
rows only or return a modified query to merge additional TiDB rows.

```dart
late final CachedTidbModelAdapter adapter;
adapter = CachedTidbModelAdapter(
  cacheFilter: (_, value) => value["private"] != true,
  collectionLoaders: [
    (query, _) async {
      final cache = await adapter.loadCachedCollection(query);
      if (cache == null) {
        return null;
      }
      return CachedTidbModelCollectionLoaderResponse(value: cache);
    },
  ],
);
```

Pass a custom `cachedLocalDatabase` for testing or custom persistence behavior.
The default shared database stores native data in the application documents
area and Web data through the storage used by `DatabaseExporter`. Database
prefixes also isolate persistent cache entries.

## Separate development and production databases

Pass `prefix` to select a prefixed physical database while keeping model paths
unchanged.

```dart
final developmentAdapter = TidbModelAdapter(
  prefix: "dev___", // Normalized to "dev_".
);
```

For `database/main/users`, this adapter connects to `dev_main.users`. A null,
empty, or underscore-only prefix connects to the existing `main.users`.
Trailing underscores are removed before exactly one underscore is appended.
Rules continue to use the logical path `main/users`, and local caches are
separated by prefix.

# Katana CLI

Enable TiDB in `katana.yaml` and run `katana apply`.

```yaml
cloudflare:
  tidb:
    enable: true
    project_id: "123"
    cluster_id: "456"
```

TiDB uses Data Service only. Store the Organization Management API public and
private keys under `cloudflare.tidb.management_api` in `katana_secrets.yaml`.
Katana-generated state is stored in the Git-ignored `cloudflare/tidb.yaml`.

Define shared prefixes once in `katana.yaml`. Every
`@tidbDataService` model uses the same list, and `katana apply` creates the
generated physical databases through additive schema SQL.

```yaml
cloudflare:
  tidb:
    prefixes:
      - dev
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
