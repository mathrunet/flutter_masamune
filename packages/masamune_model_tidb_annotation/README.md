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
