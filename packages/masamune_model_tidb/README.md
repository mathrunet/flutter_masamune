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

The adapter first requests a scoped token from `/tidb/token`. If rules allow
direct access, the response contains the TiDB host, database, username, and a
short-lived JWT. The JWT is used as the TiDB password for `tidb_auth_token`.
If direct access is not allowed, or the platform cannot open a direct TCP
connection, the adapter falls back to the Workers CRUD endpoint.

Flutter Web uses the Workers endpoint because direct MySQL/TiDB TCP connections
are not available in browsers.

# Katana CLI

Enable TiDB in `katana.yaml` and run `katana apply`.

```yaml
cloudflare:
  tidb:
    enable: true
    connection_url: mysql://user:password@gateway01.ap-northeast-1.prod.aws.tidbcloud.com:4000/app_db
```

Katana CLI generates JWT settings and direct read/write/read-write usernames in
`katana_secrets.yaml`, then stores them in Cloudflare Workers secrets with
`wrangler secret put`.

TiDB Cloud Starter and Essential clusters require a username prefix. For
example, if the TiDB Cloud connection dialog shows
`4M9hEa4vE3S7jAF.root`, the prefix is `4M9hEa4vE3S7jAF`. Use the prefixed
username in `connection_url`:

```text
mysql://4M9hEa4vE3S7jAF.root:<PASSWORD>@gateway01.ap-northeast-1.prod.aws.tidbcloud.com:4000/app_db
```

The Workers backend reads that prefix and applies it to direct client usernames
when needed. The root password in `connection_url` is not returned to the
Flutter client; the client receives only a scoped short-lived JWT and the
resolved direct username.

TiDB databases are not created automatically. Create the database in TiDB Cloud
before using it. Tables and missing columns are created automatically on save.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)
