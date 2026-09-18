/**
 * ① transfer_subエクスポートスクリプト（移管元・App Transfer完了前に実行）
 *
 * Firebase Authの全ユーザーからAppleプロバイダ(apple.com)のUID(sub)を列挙し、
 * Appleの /auth/usermigrationinfo で旧Team sub → transfer_sub を取得して
 * JSONとして標準出力へ書き出す。
 *
 * 必須環境変数:
 *   APPLE_TEAM_ID            旧Team ID
 *   APPLE_KEY_ID             旧TeamのSign in with Apple鍵のKey ID
 *   APPLE_PRIVATE_KEY_PATH   旧Teamの秘密鍵(.p8)のパス
 *   APPLE_CLIENT_ID          アプリのclient_id（Bundle ID / Services ID）
 *   RECIPIENT_TEAM_ID        移管先のTeam ID
 *   GOOGLE_APPLICATION_CREDENTIALS  FirebaseサービスアカウントJSON
 */
import { readFileSync } from "node:fs";
import jwt from "jsonwebtoken";
import { initializeApp, applicationDefault } from "firebase-admin/app";
import { getAuth, UserRecord } from "firebase-admin/auth";

const APPLE_AUTH_URL = "https://appleid.apple.com/auth";

function requiredEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`環境変数 ${name} が設定されていません`);
  }
  return value;
}

/** Sign in with Apple用のclient_secret(JWT)を生成する。 */
function createClientSecret(): string {
  const teamId = requiredEnv("APPLE_TEAM_ID");
  const keyId = requiredEnv("APPLE_KEY_ID");
  const clientId = requiredEnv("APPLE_CLIENT_ID");
  const privateKey = readFileSync(requiredEnv("APPLE_PRIVATE_KEY_PATH"), "utf8");
  const now = Math.floor(Date.now() / 1000);
  return jwt.sign(
    {
      iss: teamId,
      iat: now,
      exp: now + 60 * 30,
      aud: "https://appleid.apple.com",
      sub: clientId,
    },
    privateKey,
    { algorithm: "ES256", keyid: keyId },
  );
}

/** client_credentialsフローでuser_migrationスコープのアクセストークンを取得する。 */
async function fetchAccessToken(clientSecret: string): Promise<string> {
  const clientId = requiredEnv("APPLE_CLIENT_ID");
  const response = await fetch(`${APPLE_AUTH_URL}/token`, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "client_credentials",
      scope: "user.migration",
      client_id: clientId,
      client_secret: clientSecret,
    }),
  });
  if (!response.ok) {
    throw new Error(`アクセストークン取得失敗: ${response.status} ${await response.text()}`);
  }
  const json = (await response.json()) as { access_token: string };
  return json.access_token;
}

/** 旧Teamのsubをtransfer_subに変換する。 */
async function fetchTransferSub(
  sub: string,
  clientSecret: string,
  accessToken: string,
): Promise<string | null> {
  const response = await fetch(`${APPLE_AUTH_URL}/usermigrationinfo`, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      Authorization: `Bearer ${accessToken}`,
    },
    body: new URLSearchParams({
      sub,
      target: requiredEnv("RECIPIENT_TEAM_ID"),
      client_id: requiredEnv("APPLE_CLIENT_ID"),
      client_secret: clientSecret,
    }),
  });
  if (!response.ok) {
    console.error(`transfer_sub取得失敗 sub=${sub}: ${response.status} ${await response.text()}`);
    return null;
  }
  const json = (await response.json()) as { transfer_sub: string };
  return json.transfer_sub;
}

/** Firebase AuthからAppleプロバイダを持つ全ユーザーを列挙する。 */
async function listAppleUsers(): Promise<Array<{ uid: string; appleSub: string }>> {
  const auth = getAuth();
  const users: Array<{ uid: string; appleSub: string }> = [];
  let pageToken: string | undefined;
  do {
    const page = await auth.listUsers(1000, pageToken);
    for (const user of page.users as UserRecord[]) {
      const apple = user.providerData.find((p) => p.providerId === "apple.com");
      if (apple?.uid) {
        users.push({ uid: user.uid, appleSub: apple.uid });
      }
    }
    pageToken = page.pageToken;
  } while (pageToken);
  return users;
}

async function main(): Promise<void> {
  initializeApp({ credential: applicationDefault() });
  const clientSecret = createClientSecret();
  const accessToken = await fetchAccessToken(clientSecret);
  const users = await listAppleUsers();
  console.error(`Appleログインユーザー: ${users.length}件`);

  const results: Array<{ uid: string; oldSub: string; transferSub: string }> = [];
  for (const user of users) {
    const transferSub = await fetchTransferSub(user.appleSub, clientSecret, accessToken);
    if (transferSub) {
      results.push({ uid: user.uid, oldSub: user.appleSub, transferSub });
    }
    // Appleのレート制限対策として軽いウェイトを入れる。
    await new Promise((resolve) => setTimeout(resolve, 50));
  }
  console.error(`transfer_sub取得成功: ${results.length}/${users.length}件`);
  process.stdout.write(JSON.stringify(results, null, 2));
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
