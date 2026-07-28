# masamune_model_tidb_builder

Run `katana code generate` after adding `@tidbDataService` to Masamune models.
The builder emits the official TiDB Data Service CaC layout:

```text
tidb/data_service/
  data_sources/cluster.json
  dataapp_config.json
  http_endpoints/config.json
  http_endpoints/sql/*.sql
  __masamune/schema.sql
  __generated_manifest.json
```

The schema migration is additive. Operations explicitly denied by
`cloudflare/src/rules.json` are omitted from generated endpoints; dynamic rules
remain enforced by Cloudflare Workers at runtime.

When `TidbDataService.prefixes` is configured, the builder emits schema,
endpoints, and runtime manifest entries for each normalized prefixed physical
database. The unprefixed production database is always generated, and
`rules.json` is evaluated using the original logical database name.
