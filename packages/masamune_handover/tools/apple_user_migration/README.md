# Sign in with Apple ユーザー移行スクリプト（App Transfer用）

App Store TransferでアプリのApple Developer Teamが変わると、Sign in with Appleのユーザー識別子（`sub`）はTeam単位のため**既存ユーザーが別人扱い**になります。Appleが提供する `transfer_sub` 交換フローを使って、Firebase Authに保存されたAppleプロバイダUIDを旧Teamのsubから新Teamのsubへ移行します。

## タイムライン（厳守）

| ステップ | スクリプト | 実行者 | タイミング | 失期した場合 |
|---|---|---|---|---|
| ① transfer_subエクスポート | `1_export_transfer_sub.ts` | 移管元（旧Team） | **App Transfer完了前** | 救済不能（旧Team鍵が無効化） |
| ② 新sub交換＋Auth書き換え | `2_exchange_and_update.ts` | 移管先（新Team） | 移管完了後**即時〜60日以内** | 60日超で救済不能 |
| ③ lazy migration | `3_lazy_migration_hook.ts` | アプリ実装（Cloud Functions） | ①〜②の間＋②の拾い漏れ対策 | 重複アカウント発生 |

## 前提

- Node.js 20+ / `npm install jsonwebtoken node-fetch firebase-admin`
- 旧Team: Sign in with Apple用の秘密鍵（.p8）、Key ID、Team ID、アプリのclient_id（Bundle ID or Services ID）
- 新Team: 同上（新Teamで再発行したもの）＋移管先のrecipient_team_id
- Firebase: サービスアカウント鍵（Admin SDK用）

## 実行方法

```bash
# ① 移管元が実行（移管前）
APPLE_TEAM_ID=OLD_TEAM APPLE_KEY_ID=XXX APPLE_PRIVATE_KEY_PATH=./old_key.p8 \
APPLE_CLIENT_ID=com.example.app RECIPIENT_TEAM_ID=NEW_TEAM \
GOOGLE_APPLICATION_CREDENTIALS=./firebase-admin.json \
npx tsx 1_export_transfer_sub.ts > transfer_subs.json

# ② 移管先が実行（移管完了後60日以内）
APPLE_TEAM_ID=NEW_TEAM APPLE_KEY_ID=YYY APPLE_PRIVATE_KEY_PATH=./new_key.p8 \
APPLE_CLIENT_ID=com.example.app \
GOOGLE_APPLICATION_CREDENTIALS=./firebase-admin.json \
npx tsx 2_exchange_and_update.ts transfer_subs.json
```

`transfer_subs.json` は個人情報相当（ユーザーIDマッピング）のため、受け渡しは暗号化して行い、移行完了後に双方で破棄してください。

## 参考

- Apple: Transferring your apps and users to another team
  https://developer.apple.com/documentation/sign_in_with_apple/transferring_your_apps_and_users_to_another_team
- Apple: Bringing new apps and users into your team
  https://developer.apple.com/documentation/sign_in_with_apple/bringing_new_apps_and_users_into_your_team
