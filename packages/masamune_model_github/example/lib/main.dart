// Dart imports:

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:masamune/masamune.dart";

/// List of Masamune adapters for the application.
///
/// アプリケーション用のMasamuneアダプターのリスト。
final List<MasamuneAdapter> masamuneAdapters = [
  // GitHub APIアダプターのテスト用のプレースホルダー
  // 実際に使用する場合は、GithubModelAdapterを追加する必要があります
];

/// Entry point of the application.
///
/// アプリケーションのエントリーポイント。
void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (ref) => MasamuneApp(
      title: "GitHub Model Demo",
      masamuneAdapters: ref.adapters,
      theme: AppThemeData(
        primary: Colors.green,
      ),
      home: const GitHubDemoPage(),
    ),
  );
}

/// GitHub Model動作チェック用のメインページ
class GitHubDemoPage extends StatefulWidget {
  /// GitHub Model動作チェック用のメインページ
  const GitHubDemoPage({super.key});

  @override
  State<GitHubDemoPage> createState() => _GitHubDemoPageState();
}

class _GitHubDemoPageState extends State<GitHubDemoPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GitHub Model Demo"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Repository", icon: Icon(Icons.folder)),
            Tab(text: "Issues", icon: Icon(Icons.bug_report)),
            Tab(text: "Pull Requests", icon: Icon(Icons.merge)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          RepositoryDemoTab(),
          IssuesDemoTab(),
          PullRequestsDemoTab(),
        ],
      ),
    );
  }
}

/// リポジトリ情報デモタブ
class RepositoryDemoTab extends StatelessWidget {
  /// リポジトリ情報デモタブ
  const RepositoryDemoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "masamune_model_github パッケージ概要",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "このパッケージはGitHub APIを使用してリポジトリ、Issue、Pull Requestの情報を取得・操作するためのMasamuneアダプターを提供します。",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "主な機能",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("• GitHub APIを使用したリポジトリ情報の取得"),
                  Text("• Issueの一覧表示と作成・更新"),
                  Text("• Pull Requestの一覧表示と操作"),
                  Text("• Masamuneフレームワークとの統合"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "設定例",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''
// masamuneAdaptersにGithubModelAdapterを追加
final List<MasamuneAdapter> masamuneAdapters = [
  GithubModelAdapter(
    token: "your_github_api_token",
    owner: "flutter",
    repository: "flutter",
  ),
];''',
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "使用例：リポジトリ情報の取得",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''
// リポジトリ情報の取得
final repositoryDocument = ref.app.model(
  RepositoryModel.document("owner/repository"),
);
await repositoryDocument.load();
final repo = repositoryDocument.value;''',
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Issuesデモタブ
class IssuesDemoTab extends StatelessWidget {
  /// Issuesデモタブ
  const IssuesDemoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Issues機能",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "GitHub IssuesをMasamuneのモデルとして取り扱い、作成・更新・取得が可能です。",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "使用例：Issueの一覧取得",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''
// Issue一覧の取得
final issuesCollection = ref.app.model(
  IssueModel.collection().path("issue/owner/repository"),
);
await issuesCollection.load();
final issues = issuesCollection.value;''',
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "使用例：新しいIssueの作成",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''
// 新しいIssueの作成
final issueDoc = ref.app.model(
  IssueModel.document("owner/repository/new"),
);
await issueDoc.save(
  IssueModel(
    title: "バグレポート",
    body: "説明文をここに入力",
    labels: ["bug", "urgent"],
  ),
);''',
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "IssueModelの主なフィールド",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("• title: Issueのタイトル"),
                  Text("• body: Issueの本文"),
                  Text("• state: Issueの状態（open/closed）"),
                  Text("• number: Issue番号"),
                  Text("• user: 作成者情報"),
                  Text("• labels: ラベル一覧"),
                  Text("• createdAt: 作成日時"),
                  Text("• updatedAt: 更新日時"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pull Requestsデモタブ
class PullRequestsDemoTab extends StatelessWidget {
  /// Pull Requestsデモタブ
  const PullRequestsDemoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pull Requests機能",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "GitHub Pull RequestsをMasamuneのモデルとして取り扱い、作成・更新・取得が可能です。",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "使用例：Pull Request一覧の取得",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''
// Pull Request一覧の取得
final prsCollection = ref.app.model(
  PullRequestModel.collection().path("pull_request/owner/repository"),
);
await prsCollection.load();
final pullRequests = prsCollection.value;''',
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "使用例：新しいPull Requestの作成",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '''
// 新しいPull Requestの作成
final prDoc = ref.app.model(
  PullRequestModel.document("owner/repository/new"),
);
await prDoc.save(
  PullRequestModel(
    title: "新機能の追加",
    body: "説明文をここに入力",
    head: "feature-branch",
    base: "main",
  ),
);''',
                      style: TextStyle(
                        fontFamily: "monospace",
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PullRequestModelの主なフィールド",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("• title: Pull Requestのタイトル"),
                  Text("• body: Pull Requestの本文"),
                  Text("• state: Pull Requestの状態（open/closed/merged）"),
                  Text("• number: Pull Request番号"),
                  Text("• user: 作成者情報"),
                  Text("• head: マージ元ブランチ情報"),
                  Text("• base: マージ先ブランチ情報"),
                  Text("• createdAt: 作成日時"),
                  Text("• updatedAt: 更新日時"),
                  Text("• mergedAt: マージ日時"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "重要な注意事項",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "• GitHub APIトークンが必要です",
                    style: TextStyle(color: Colors.red),
                  ),
                  const Text("• リアルタイムリスニングには対応していません"),
                  const Text("• トランザクション・バッチ操作には対応していません"),
                  const Text("• API制限にご注意ください"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Text(
                      "実際に使用するには、有効なGitHub APIトークンをGithubModelAdapterに設定する必要があります。",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
