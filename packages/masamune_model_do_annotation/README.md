<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"><br/>
  </a>
  <h1 align="center">Masamune Model Durable Objects Annotation</h1>
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

Use `@DurableObjectSchema` to define the shared Durable Objects schema for a Masamune model.
Add [`masamune_model_do_builder`](../masamune_model_do_builder/README.md) to `dev_dependencies`
and generate the schema with Katana CLI.

```dart
import "package:masamune_model_do_annotation/masamune_model_do_annotation.dart";

@DurableObjectSchema(indexes: {"by_value": ["value"]})
@CollectionModelPath("item")
class ItemModel with _$ItemModel {
  const factory ItemModel({@Default(0) int value}) = _ItemModel;
  // Include the remaining generated Masamune model members here.
}
```

The default database is `main`, and the default output directory is
`do/schema`. For another database, also set the model path to
`database/<database>/<table>`.

- `prefixes` adds schemas for physical database prefixes.
- `extraColumns` defines server-owned columns that are not exposed by the model.
- `additionalTables` defines server-owned tables.
- `indexes` defines non-unique indexes.
- A column's `required` flag describes model construction, not SQL `NOT NULL`.

## Vector schema limitations

This annotation and its builder do not currently generate Vectorize configuration
or support `ModelVectorValue` columns. The adapter and Node server support vector
queries with a separately configured manifest. See the
[Node README](https://github.com/mathrunet/node_masamune/tree/main/packages/masamune_cloudflare_do#vectorize-nearest-neighbor-search)
for its `vectors` and `vectorFields` requirements.

## Generate and apply the schema

Run `katana code generate` or `katana code watch`. The builder emits per-input
`.do_schema` fragments, and Katana CLI combines them into the shared manifest.
Do not edit generated fragments manually. For SQL approval and application, see
the Node package's
[migration guide](https://github.com/mathrunet/node_masamune/blob/main/packages/masamune_cloudflare_do/MIGRATION.md).

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
