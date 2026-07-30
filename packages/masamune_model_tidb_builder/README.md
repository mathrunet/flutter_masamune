# masamune_model_tidb_builder

Run `katana code generate` after adding `@tidbDataService` to Masamune models.
The builder and `katana apply` maintain the official TiDB Data Service CaC
layout:

```text
tidb/data_service/
  data_sources/cluster.json
  dataapp_config.json
  http_endpoints/config.json
  http_endpoints/sql/*.sql
  __masamune/schema.sql
  __masamune/deployed_endpoints.json
  __generated_manifest.json
```

`katana apply` writes `__masamune/deployed_endpoints.json` after a successful
TiDB deployment. It records the full TiDB resource name for every endpoint
deployed by the current project. On a later model generation, endpoints absent
from the new `http_endpoints/config.json` are deleted only when the remote
resource still exactly matches that last-applied ownership record. Other
Masamune-tagged endpoints in a shared Data App are left untouched. Keep this
state file with the generated Data Service artifacts so that the ownership
boundary survives another machine or CI checkout.

The schema migration is additive. Operations explicitly denied by
`cloudflare/src/rules.json` are omitted from generated endpoints; dynamic rules
remain enforced by Cloudflare Workers at runtime.

Configure shared prefixes once at
`cloudflare.tidb.data_service.prefixes` in `katana.yaml`. `katana code
generate` and `katana code watch` pass them to the builder for every
`@tidbDataService` model. Model-specific `TidbDataService.prefixes` values are
merged with the shared values and deduplicated after normalization.

The builder emits schema, endpoints, and runtime manifest entries for every
normalized prefixed physical database. The unprefixed production database is
always generated, and `rules.json` is evaluated using the original logical
database name.

Projects that invoke build runner directly can provide the same option in
`build.yaml`.

```yaml
targets:
  $default:
    builders:
      masamune_model_tidb_builder:
        options:
          prefixes:
            - dev
```
