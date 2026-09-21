<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"><br/>
  </a>
  <h1 align="center">Masamune Model D1</h1>
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

Use `D1ModelAdapter` or `CachedD1ModelAdapter` to access Cloudflare D1 through
`@mathrunet/masamune_cloudflare_d1` Workers. Use the matching annotation, builder,
Node package, and Katana CLI together.

```dart
final session = D1ModelSession(
  endpoint: workerEndpoint,
  environment: "dev",
  userId: authenticatedUserId,
);
final adapter = D1ModelAdapter(
  prefix: null,
  session: session,
  functionsAdapter: functionsAdapter,
);
final document = ref.app.model(ItemModel.document("one", adapter: adapter));
await document.load();
```

Configure `functionsAdapter` with a `CloudflareFunctionsAdapter` using the same
endpoint and an authentication adapter. Standard flat model paths use the `main`
database. For another database, use `database/<database>/<table>/<id>`. Match the
environment prefix to the Worker's `FLAVOR`.

## Sessions and consistency

Share a session per endpoint, environment, and user. Requests to the same database
are serialized and carry forward D1 bookmarks. On logout, call `session.reset()`
and create a new session for the next user. A reset session cannot be reused, and
responses from its in-flight requests are discarded.

## Persistent local cache

`CachedD1ModelAdapter` loads from the device-local cache first. Cache namespaces
separate users, endpoints, environments, and prefixes. Call `reload()` on the
model when fresh remote data is required. A D1 bookmark does not guarantee the
freshness of a cache hit.

## Supported operations

A batch atomically executes up to 100 operations in one database and one request.
Mixed-database batches, larger batches, and callback-based `runTransaction` are
rejected. Listenable adapters are not supported. Store large integers and exact
decimal values in TEXT-backed models. Writes with an unknown outcome are not
retried automatically.

## Schema generation and migration

Use [`@D1Schema`](../masamune_model_d1_annotation/README.md) with
[`masamune_model_d1_builder`](../masamune_model_d1_builder/README.md) and
`katana code generate`. See the Node package's
[migration guide](https://github.com/mathrunet/node_masamune/blob/main/packages/masamune_cloudflare_d1/MIGRATION.md)
for schema management and DDL application.

## Vectorize search

D1 with Vectorize is an unpublished integration. Saving, searching, deleting,
and preserving unloaded vector values have been verified with the package's
adapter in a dedicated cloud environment.

Declare `@D1Schema(vectors: ...)` and add a nullable `ModelVectorValue` field with
the same name. Because fields use SQL identifiers, set `vectorValueFieldKey` to
an identifier such as `embedding` instead of the `VectorDocumentMixin` default
`@vector`. For `nearest("embedding", text)`, pass a `vectorConverter` that uses
the same embedding method as the stored vectors. The default
`PassVectorConverter` does not convert text. Numeric queries can also use
`D1GetModelFunctionsAction(nearest: {"key": "embedding", "value": [...]})`.

Nearest-neighbor searches always query the Worker, including with the cached
adapter, and preserve the server's ranking. Only documents are cached; rankings
are not recomputed locally. An empty, server-sourced `ModelVectorValue` that
represents an unloaded value is omitted from saves to preserve the existing
vector. Use explicit `null` to delete it. A successful write or D1 bookmark does
not guarantee that Vectorize has indexed the change. See the
[Node README](https://github.com/mathrunet/node_masamune/tree/main/packages/masamune_cloudflare_d1#d1-and-vectorize)
for retries, rebuilds, and search candidate limits.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
