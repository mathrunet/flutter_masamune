<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"><br/>
  </a>
  <h1 align="center">Masamune Model Durable Objects</h1>
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

Use `DurableObjectModelAdapter` or `CachedDurableObjectModelAdapter` to access
per-user Durable Objects SQLite databases through Cloudflare Workers
authentication and rules.

```dart
final session = DurableObjectModelSession(
  endpoint: functionsAdapter.endpoint,
  environment: "dev",
  userId: authenticatedUserId,
);
final adapter = DurableObjectModelAdapter(
  prefix: null,
  session: session,
  functionsAdapter: functionsAdapter,
);
final document = ref.app.model(ItemModel.document("one", adapter: adapter));
await document.load();
```

Use the same endpoint as the functions adapter, the environment (`dev` or `prod`),
and the authenticated user's UID. On logout, call `session.reset()` and create a
new session for the next authenticated user. The server validates the UID and
environment against authentication and prevents access to another user's object.

Standard model paths use the `main` database. Use
`database/<database>/<table>` for a collection in another database, and append
`/<id>` for a document. Set `prefix: null`; the Worker handles environment
isolation.

## Supported operations

The adapter supports CRUD, `where`, `orderBy`, `limit`, `count`, Vectorize
nearest-neighbor queries, and atomic batches of up to 100 operations in one
database. Callback-based transactions are not supported.

For nearest-neighbor queries, specify `ModelQueryFilter.nearest` and `limit`.
`VectorValue` and `ModelVectorValue` can be sent directly; strings are converted
to numeric vectors by the adapter's `vectorConverter`. Rankings are determined
by the server. The cached adapter stores returned documents without recomputing
rankings locally. Vectorize is eventually consistent: immediately after an
update, stale generations are excluded, so results may be empty or incomplete.

## Persistent local cache

`CachedDurableObjectModelAdapter` reads from a device-local cache scoped to the
session. Call `reload()` for fresh remote data. Configure `cacheFilter` and a
`NoSqlDatabase` as with other cached adapters. Responses received after a session
reset are discarded, and failed mutations do not update the cache.

## Schema generation and migration

Use [`@DurableObjectSchema`](../masamune_model_do_annotation/README.md), its
[builder](../masamune_model_do_builder/README.md), the Node package, and Katana
CLI together. The annotation and builder currently generate non-vector schemas;
server-side Vectorize support has separate manifest requirements described in the
[Node README](https://github.com/mathrunet/node_masamune/tree/main/packages/masamune_cloudflare_do#vectorize-nearest-neighbor-search).
See that README and the
[migration guide](https://github.com/mathrunet/node_masamune/blob/main/packages/masamune_cloudflare_do/MIGRATION.md)
for server setup, migrations, and leases. Never embed administration tokens in a
public app.

## Listenable adapters

Pass `ListenableDurableObjectModelAdapter` or
`CachedListenableDurableObjectModelAdapter` to the generated model's `adapter`.
Use the same session and functions adapter as the regular adapter. `model.load()`
starts a document or collection subscription. Subsequent loads return the same
snapshot without overwriting it with a separate asynchronous CRUD read.

Each notification triggers an authorized full snapshot fetch. Membership changes,
deletion and recreation, and changes to `orderBy` or `limit` are reflected using
indexes consistent with notification order. Caches are isolated by endpoint,
environment, UID, shared topic, and query, and are replaced by complete snapshots.
The cached adapter's `cacheFilter` affects persistence only, not the server result
set. Reading a stored cache does not establish an authenticated subscription.

Connections are renewed approximately two seconds before the ticket expires.
After a socket disconnect, reconnect delays increase from 200 ms to a maximum
of 6.4 seconds. Authorization is rechecked every 15 seconds even without updates.
A 401 or 403 stops the subscription and clears its cache and displayed data.
Other non-recoverable 4xx errors also stop it. Handle errors with `onListenError`.
Always reset the session and create a new one when authentication changes;
pending responses and notifications are discarded. Models can still be disposed
after a session reset.

Add `Functions.durableObjectSockets` on the server. Native platforms use
`dart:io`, and Web uses the browser's WebSocket implementation. `socketConnector`
is an injection point for unit tests. Web has been verified with JavaScript;
Wasm support is not guaranteed. See the Node README for server limits, costs,
tickets, and hibernation behavior.

## Explicit shared topics

Authorized participants can use CRUD and listenable adapters through sessions
with the same `sharedTopic`. Keep `userId` set to each participant's authenticated
UID; do not replace it with the topic.

```dart
final session = DurableObjectModelSession(
  endpoint: functionsAdapter.endpoint,
  environment: "dev",
  userId: authenticatedUserId,
  sharedTopic: "room-123",
);
```

Reset the old session and create a new one when the topic or authentication
changes. Do not share caches between personal data, different topics, or UIDs.
The Worker requires shared hub configuration and a membership authorization
callback; specifying a topic does not grant access. Shard selection follows the
server's ticket response, and connections remain within the configured endpoint.

Shared hubs distribute connections and notifications. They do not automatically
partition stored data or provide Firestore-compatible offline writes. See the
[Node README](https://github.com/mathrunet/node_masamune/tree/main/packages/masamune_cloudflare_do#shared-topics-and-hubs)
for capacity, redeployment, authorization, and operational limits.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
