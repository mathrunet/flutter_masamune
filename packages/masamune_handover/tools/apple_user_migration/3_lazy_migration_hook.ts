/**
 * ③ lazy migrationフック（Cloud Functions・移管完了後〜②完了までの空白期間の保険）
 *
 * App Transfer完了後、②のバッチが完了する前に既存ユーザーが
 * Appleログインすると新Team subが返り「新規ユーザー」として
 * 重複アカウントが作成されてしまう。
 *
 * このフックはFirebase Auth blocking function (beforeUserCreated) として動作し、
 * 新規作成されようとしているAppleユーザーのsubをtransfer_subマッピングと照合。
 * 既存ユーザーに対応する場合は作成をブロックして既存アカウントのUIDを更新し、
 * クライアントへ再ログインを促す。
 *
 * デプロイ:
 *   1. transfer_subs.json を Firestore の `apple_migration` コレクションへ投入
 *      （ドキュメントID = transferSub、フィールド = { uid, oldSub }）
 *      ※ ①実行後に scripts/import_mapping.ts 等で投入するか、
 *        ②のバッチと同時に投入する。
 *   2. この関数を firebase/functions に追加して deploy。
 *   3. ②の完了後、全ユーザーの移行が確認できたらこの関数と
 *      `apple_migration` コレクションを削除する。
 */
import { beforeUserCreated, HttpsError } from "firebase-functions/v2/identity";
import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";

initializeApp();

export const appleUserLazyMigration = beforeUserCreated(async (event) => {
  const user = event.data;
  const apple = user?.providerData?.find((p) => p.providerId === "apple.com");
  if (!apple?.uid) {
    // Apple以外のログインは対象外。
    return;
  }

  // 新Team subからtransfer_sub経由の逆引きはできないため、
  // ②のバッチが新subをマッピングへ追記した場合に備えて
  // newSubフィールドでも照合する。
  const firestore = getFirestore();
  const snapshot = await firestore
    .collection("apple_migration")
    .where("newSub", "==", apple.uid)
    .limit(1)
    .get();
  if (snapshot.empty) {
    // マッピングに存在しない = 本当の新規ユーザー。作成を許可。
    return;
  }

  const mapping = snapshot.docs[0].data() as { uid: string; oldSub: string };

  // 既存アカウントのAppleプロバイダUIDを新subへ書き換える。
  const auth = getAuth();
  // 同一プロバイダのUID差し替えはunlink→linkの2段階で行う。
  await auth.updateUser(mapping.uid, {
    providersToUnlink: ["apple.com"],
  });
  await auth.updateUser(mapping.uid, {
    providerToLink: {
      providerId: "apple.com",
      uid: apple.uid,
      email: apple.email ?? undefined,
    },
  });

  // 重複アカウントの作成をブロックし、クライアントへ再ログインを促す。
  // クライアント側はこのエラーコードを受けたら再度signInWithAppleを実行する。
  // （2回目は既存アカウントに新subが紐付いているため正常にログインできる）
  throw new HttpsError(
    "aborted",
    "apple-user-migrated: please retry sign-in",
  );
});
