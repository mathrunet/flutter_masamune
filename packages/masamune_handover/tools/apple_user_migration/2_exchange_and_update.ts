/**
 * ② transfer_sub交換＋Firebase Auth書き換えバッチ（移管先・App Transfer完了後60日以内に実行）
 *
 * ①で出力したtransfer_subs.jsonを読み込み、新Teamの鍵で
 * transfer_sub → 新Team subへ交換し、Firebase Authの
 * Appleプロバイダ(apple.com)UIDを旧subから新subへ書き換える。
 *
 * 使い方: npx tsx 2_exchange_and_update.ts transfer_subs.json
 *
 * 必須環境変数:
 *   APPLE_TEAM_ID            新Team ID
 *   APPLE_KEY_ID             新TeamのSign in with Apple鍵のKey ID
 *   APPLE_PRIVATE_KEY_PATH   新Teamの秘密鍵(.p8)のパス
 *   APPLE_CLIENT_ID          アプリのclient_id（Bundle ID / Services ID）
 *   GOOGLE_APPLICATION_CREDENTIALS  FirebaseサービスアカウントJSON
 */
import { readFileSync } from "node:fs";
import jwt from "jsonwebtoken";
import { initializeApp, applicationDefault } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";

const APPLE_AUTH_URL = "https://appleid.apple.com/auth";

interface TransferEntry {
  uid: string;
  oldSub: string;
  transferSub: string;
}

function requiredEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`環境変数 ${name} が設定されていません`);
  }
  return value;
}

function createClientSecret(): string {
  const now = Math.floor(Date.now() / 1000);
  return jwt.sign(
    {
      iss: requiredEnv("APPLE_TEAM_ID"),
      iat: now,
      exp: now + 60 * 30,
      aud: "https://appleid.apple.com",
      sub: requiredEnv("APPLE_CLIENT_ID"),
    },
    readFileSync(requiredEnv("APPLE_PRIVATE_KEY_PATH"), "utf8"),
    { algorithm: "ES256", keyid: requiredEnv("APPLE_KEY_ID") },
  );
}

async function fetchAccessToken(clientSecret: string): Promise<string> {
  const response = await fetch(`${APPLE_AUTH_URL}/token`, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "client_credentials",
      scope: "user.migration",
      client_id: requiredEnv("APPLE_CLIENT_ID"),
      client_secret: clientSecret,
    }),
  });
  if (!response.ok) {
    throw new Error(`アクセストークン取得失敗: ${response.status} ${await response.text()}`);
  }
  const json = (await response.json()) as { access_token: string };
  return json.access_token;
}

/** transfer_subを新Teamのsubへ交換する。 */
async function exchangeTransferSub(
  transferSub: string,
  clientSecret: string,
  accessToken: string,
): Promise<{ sub: string; email?: string } | null> {
  const response = await fetch(`${APPLE_AUTH_URL}/usermigrationinfo`, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      Authorization: `Bearer ${accessToken}`,
    },
    body: new URLSearchParams({
      transfer_sub: transferSub,
      client_id: requiredEnv("APPLE_CLIENT_ID"),
      client_secret: clientSecret,
    }),
  });
  if (!response.ok) {
    console.error(
      `sub交換失敗 transfer_sub=${transferSub}: ${response.status} ${await response.text()}`,
    );
    return null;
  }
  return (await response.json()) as { sub: string; email?: string };
}

/** Firebase AuthのAppleプロバイダUIDを新subへ書き換える。 */
async function updateFirebaseUser(
  uid: string,
  newSub: string,
  newEmail?: string,
): Promise<boolean> {
  const auth = getAuth();
  try {
    // 同一プロバイダのUID差し替えはunlink→linkの2段階で行う。
    await auth.updateUser(uid, {
      providersToUnlink: ["apple.com"],
    });
    await auth.updateUser(uid, {
      providerToLink: {
        providerId: "apple.com",
        uid: newSub,
        email: newEmail,
      },
    });
    return true;
  } catch (e) {
    console.error(`Firebase Auth更新失敗 uid=${uid}:`, e);
    return false;
  }
}

async function main(): Promise<void> {
  const inputPath = process.argv[2];
  if (!inputPath) {
    throw new Error("使い方: npx tsx 2_exchange_and_update.ts transfer_subs.json");
  }
  const entries = JSON.parse(readFileSync(inputPath, "utf8")) as TransferEntry[];
  console.error(`移行対象: ${entries.length}件`);

  initializeApp({ credential: applicationDefault() });
  const clientSecret = createClientSecret();
  const accessToken = await fetchAccessToken(clientSecret);

  let succeeded = 0;
  const failed: TransferEntry[] = [];
  for (const entry of entries) {
    const exchanged = await exchangeTransferSub(entry.transferSub, clientSecret, accessToken);
    if (!exchanged) {
      failed.push(entry);
      continue;
    }
    // Private RelayメールもTeam単位で変わるため、新しいメールがあれば併せて更新する。
    const updated = await updateFirebaseUser(entry.uid, exchanged.sub, exchanged.email);
    if (updated) {
      succeeded++;
    } else {
      failed.push(entry);
    }
    await new Promise((resolve) => setTimeout(resolve, 50));
  }

  console.error(`完了: 成功 ${succeeded}件 / 失敗 ${failed.length}件`);
  if (failed.length > 0) {
    // 失敗分は再実行できるようファイルに残す。
    const retryPath = `${inputPath}.failed.json`;
    const { writeFileSync } = await import("node:fs");
    writeFileSync(retryPath, JSON.stringify(failed, null, 2));
    console.error(`失敗分を ${retryPath} に保存しました。再実行してください。`);
    process.exit(1);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
