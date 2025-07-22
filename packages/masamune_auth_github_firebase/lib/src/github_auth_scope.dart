part of "/masamune_auth_github_firebase.dart";

/// The scopes of the GitHub API.
///
/// GitHub APIのスコープ。
enum GithubAuthScope {
  /// The scope to access the repository.
  ///
  /// リポジトリにアクセスするためのスコープ。
  repo,

  /// The scope to access the repository status.
  ///
  /// リポジトリのステータスにアクセスするためのスコープ。
  repoStatus,

  /// The scope to access the repository deployment.
  ///
  /// リポジトリのデプロイメントにアクセスするためのスコープ。
  repoDeployment,

  /// The scope to access the public repository.
  ///
  /// パブリックリポジトリにアクセスするためのスコープ。
  publicRepo,

  /// The scope to invite to the repository.
  ///
  /// リポジトリに招待するためのスコープ。
  repoInvite,

  /// The scope to access the security events.
  ///
  /// セキュリティイベントにアクセスするためのスコープ。
  securityEvents,

  /// The scope to access the admin repository hook.
  ///
  /// 管理者リポジトリフックにアクセスするためのスコープ。
  adminRepoHook,

  /// The scope to write the repository hook.
  readRepoHook,

  /// The scope to access the admin organization.
  ///
  /// 管理者組織にアクセスするためのスコープ。
  adminOrg,

  /// The scope to write the organization.
  ///
  /// 組織に書き込むためのスコープ。
  writeOrg,

  /// The scope to read the organization.
  ///
  /// 組織を読み込むためのスコープ。
  readOrg,

  /// The scope to access the admin public key.
  ///
  /// 管理者公開鍵にアクセスするためのスコープ。
  adminPublicKey,

  /// The scope to write the public key.
  ///
  /// 公開鍵に書き込むためのスコープ。
  writePublicKey,

  /// The scope to read the public key.
  ///
  /// 公開鍵を読み込むためのスコープ。
  readPublicKey,

  /// The scope to access the admin organization hook.
  ///
  /// 管理者組織フックにアクセスするためのスコープ。
  adminOrgHook,

  /// The scope to access the gist.
  ///
  /// gistにアクセスするためのスコープ。
  gist,

  /// The scope to access the notifications.
  ///
  /// 通知にアクセスするためのスコープ。
  notifications,

  /// The scope to read the thread.
  ///
  /// スレッドを読み込むためのスコープ。
  readThread,

  /// The scope to write the thread.
  ///
  /// スレッドに書き込むためのスコープ。
  writeThread,

  /// The scope to read the thread subscription.
  ///
  /// スレッドサブスクリプションを読み込むためのスコープ。
  readThreadSubscription,

  /// The scope to access the user.
  ///
  /// ユーザーにアクセスするためのスコープ。
  user,

  /// The scope to read the user.
  ///
  /// ユーザーを読み込むためのスコープ。
  readUser,

  /// The scope to access the user email.
  ///
  /// ユーザーのメールアドレスにアクセスするためのスコープ。
  userEmail,

  /// The scope to follow the user.
  ///
  /// ユーザーをフォローするためのスコープ。
  userFollow,

  /// The scope to access the project.
  ///
  /// プロジェクトにアクセスするためのスコープ。
  project,

  /// The scope to read the project.
  ///
  /// プロジェクトを読み込むためのスコープ。
  readProject,

  /// The scope to delete the repository.
  ///
  /// リポジトリを削除するためのスコープ。
  deleteRepo,

  /// The scope to write the packages.
  ///
  /// パッケージに書き込むためのスコープ。
  writePackages,

  /// The scope to read the packages.
  ///
  /// パッケージを読み込むためのスコープ。
  readPackages,

  /// The scope to delete the packages.
  ///
  /// パッケージを削除するためのスコープ。
  deletePackages,

  /// The scope to access the admin gpg key.
  ///
  /// 管理者GPGキーにアクセスするためのスコープ。
  adminGpgKey,

  /// The scope to write the gpg key.
  ///
  /// GPGキーに書き込むためのスコープ。
  writeGpgKey,

  /// The scope to read the gpg key.
  ///
  /// GPGキーを読み込むためのスコープ。
  readGpgKey,

  /// The scope to access the codespace.
  ///
  /// コードスペースにアクセスするためのスコープ。
  codespace,

  /// The scope to access the workflow.
  ///
  /// ワークフローにアクセスするためのスコープ。
  workflow,

  /// The scope to read the audit log.
  ///
  /// 監査ログを読み込むためのスコープ。
  readAuditLog;

  /// The scope of the GitHub API.
  ///
  /// GitHub APIのスコープ。
  String get scope {
    switch (this) {
      case GithubAuthScope.repo:
        return "repo";
      case GithubAuthScope.repoStatus:
        return "repo:status";
      case GithubAuthScope.repoDeployment:
        return "repo_deployment";
      case GithubAuthScope.publicRepo:
        return "public_repo";
      case GithubAuthScope.repoInvite:
        return "repo:invite";
      case GithubAuthScope.securityEvents:
        return "security_events";
      case GithubAuthScope.adminRepoHook:
        return "admin:repo_hook";
      case GithubAuthScope.readRepoHook:
        return "read:repo_hook";
      case GithubAuthScope.adminOrg:
        return "admin:org";
      case GithubAuthScope.writeOrg:
        return "write:org";
      case GithubAuthScope.readOrg:
        return "read:org";
      case GithubAuthScope.adminPublicKey:
        return "admin:public_key";
      case GithubAuthScope.writePublicKey:
        return "write:public_key";
      case GithubAuthScope.readPublicKey:
        return "read:public_key";
      case GithubAuthScope.adminOrgHook:
        return "admin:org_hook";
      case GithubAuthScope.gist:
        return "gist";
      case GithubAuthScope.notifications:
        return "notifications";
      case GithubAuthScope.readThread:
        return "read:thread";
      case GithubAuthScope.writeThread:
        return "write:thread";
      case GithubAuthScope.readThreadSubscription:
        return "read:thread_subscription";
      case GithubAuthScope.user:
        return "user";
      case GithubAuthScope.readUser:
        return "read:user";
      case GithubAuthScope.userEmail:
        return "user:email";
      case GithubAuthScope.userFollow:
        return "user:follow";
      case GithubAuthScope.project:
        return "project";
      case GithubAuthScope.readProject:
        return "read:project";
      case GithubAuthScope.deleteRepo:
        return "delete_repo";
      case GithubAuthScope.writePackages:
        return "write:packages";
      case GithubAuthScope.readPackages:
        return "read:packages";
      case GithubAuthScope.deletePackages:
        return "delete:packages";
      case GithubAuthScope.adminGpgKey:
        return "admin:gpg_key";
      case GithubAuthScope.writeGpgKey:
        return "write:gpg_key";
      case GithubAuthScope.readGpgKey:
        return "read:gpg_key";
      case GithubAuthScope.codespace:
        return "codespace";
      case GithubAuthScope.workflow:
        return "workflow";
      case GithubAuthScope.readAuditLog:
        return "read:audit_log";
    }
  }
}
