# masamune_model_tidb_annotation

Annotations for generating TiDB Data Service Configuration as Code from
Masamune models.

```dart
@tidbDataService
@CollectionModelPath("users")
abstract class UserModel {
  const UserModel({required this.name});
  final String name;
}
```

`TidbDataService` can override the logical database, output directory, and
Cloudflare `rules.json` path. Data Service v1 supports flat model paths only.

Use `prefixes` to generate physical databases for adapter prefixes in addition
to the unprefixed production database.

```dart
@TidbDataService(prefixes: ["dev", "staging_"])
@CollectionModelPath("database/main/users")
abstract class UserModel {}
```

The values above are normalized to `dev_` and `staging_`, generating
`main.users`, `dev_main.users`, and `staging_main.users`. Rules are still
evaluated with the logical database name `main`.
