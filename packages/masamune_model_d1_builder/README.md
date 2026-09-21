<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"><br/>
  </a>
  <h1 align="center">Masamune Model D1 Builder</h1>
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

Generate D1 schema fragments from Masamune models annotated with
[`@D1Schema`](../masamune_model_d1_annotation/README.md).

```yaml
dependencies:
  masamune_model_d1_annotation: ^3.1.0

dev_dependencies:
  masamune_model_d1_builder: ^3.1.0
```

Generate the model code and schema through Katana CLI:

```bash
katana code generate
# Watch for changes:
katana code watch
```

## Generated output

The builder writes a `.d1_schema` fragment for each input file. Katana CLI
aggregates all fragments into `d1/schema/schema.json` by default, preserving
unchanged models and excluding deleted ones. The builder alone does not write
the shared manifest. Do not edit generated fragments manually.

The schema supports `TEXT`, `INTEGER`, `REAL`, `BOOLEAN`, and `JSON`, reserved ID
and timestamp columns, server-owned columns and tables, database prefixes, and
non-unique indexes. Duplicate tables, invalid identifiers, and unsupported SQL
types are rejected. JSON-backed vector fields configured with `D1Schema.vectors` are supported;
native SQL vector types are not. The builder validates bindings, dimensions,
metrics, and referenced JSON columns.

## Migration

Schema generation does not apply DDL. See the Node package's
[migration guide](https://github.com/mathrunet/node_masamune/blob/main/packages/masamune_cloudflare_d1/MIGRATION.md)
for approval and application procedures.

## Development

This is a pure Dart code-generation package. Validate it with `dart analyze`
and `dart test`.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
