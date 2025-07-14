import "package:masamune/masamune.dart";
import "package:masamune_test/masamune_test.dart";

import "package:masamune_model_github/models/github_issue_comment.dart";

void main() {
  masamuneModelTileTest(
    name: "GithubIssueCommentModel",
    path: "github_issue_comment",
    // TODO: Set the document Id.
    document: (context, ref) => ref.appRef.model(GithubIssueCommentModel.document("0198057a2433718da19bf4df47c0e919")),
    builder: (context, ref, value) {
      // TODO: Write test code.
      return value.toTile(context);
    },
  );
}
