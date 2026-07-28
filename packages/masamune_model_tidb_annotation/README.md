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

Define shared physical database prefixes once in `katana.yaml`. Every
`@tidbDataService` model then generates the prefixed databases in addition to
the unprefixed production database.

```yaml
cloudflare:
  tidb:
    data_service:
      prefixes:
        - dev
        - staging
```

```dart
@tidbDataService
@CollectionModelPath("database/main/users")
abstract class UserModel {}
```

The values above are normalized to `dev_` and `staging_`, generating
`main.users`, `dev_main.users`, and `staging_main.users`. Rules are still
evaluated with the logical database name `main`.

`TidbDataService.prefixes` remains available for model-specific additions. Its
values are merged with the shared `katana.yaml` prefixes and deduplicated after
normalization.
