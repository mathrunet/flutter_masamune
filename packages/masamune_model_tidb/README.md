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
    connection_url: mysql://user:password@gateway01.ap-northeast-1.prod.aws.tidbcloud.com:4000/app_db
```

Katana CLI stores the TiDB connection URL in Cloudflare Workers secrets with
`wrangler secret put`.

TiDB Cloud Starter and Essential clusters require a username prefix. For
example, if the TiDB Cloud connection dialog shows
`4M9hEa4vE3S7jAF.root`, the prefix is `4M9hEa4vE3S7jAF`. Use the prefixed
username in `connection_url`:

```text
mysql://4M9hEa4vE3S7jAF.root:<PASSWORD>@gateway01.ap-northeast-1.prod.aws.tidbcloud.com:4000/app_db
```

The root password in `connection_url` is used only by the Workers backend and is
not returned to the Flutter client.

In direct mode, TiDB databases are not created automatically. Create the
database in TiDB Cloud before using it. This includes prefixed databases such
as `dev_main`. Tables and missing columns are created automatically on save.

In Data Service mode, define shared prefixes once in `katana.yaml`. Every
`@tidbDataService` model uses the same list, and `katana apply` creates the
generated physical databases through additive schema SQL.

```yaml
cloudflare:
  tidb:
    mode: data_service
    data_service:
      prefixes:
        - dev
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
