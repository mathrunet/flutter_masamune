import "package:masamune/masamune.dart";
import "package:masamune_test/masamune_test.dart";

import "package:masamune_model_github/models/github_pull_request_comment.dart";

void main() {
  masamuneModelTileTest(
    name: "GithubPullRequestCommentModel",
    path: "github_pull_request_comment",
    // TODO: Set the document Id.
    document: (context, ref) => ref.appRef.model(GithubPullRequestCommentModel.document("0198057a474a7e0994244b5d6f67a03b")),
    builder: (context, ref, value) {
      // TODO: Write test code.
      return value.toTile(context);
    },
  );
}
