# パッケージのリリース

操作の入口は `/dev:masamune:release`。
通常のpushでは公開せず、専用コマンドが作成するPRの検証後にGitHub Actionsから公開する。

初回設定・移行基準・版更新・再開方法は[共通リリース手順](https://github.com/mathrunet/masamune/blob/main/tools/package-release/README.md)を参照。
`.release/baselines.json`は移行時の確認済み公開基準、`manifest.json`と`request.json`はリリース処理が管理する。
