// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune plugin package that includes a model adapter to retrieve data from Github.
///
/// To use, import `package:masamune_model_github/masamune_model_github.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:convert" as convert;

// Flutter imports:
import "package:flutter/widgets.dart";

// Package imports:
import "package:archive/archive.dart";
import "package:github/github.dart" as git_hub show Authentication;
import "package:github/github.dart" hide Authentication;
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_model_github/models/github_actions.dart";
import "package:masamune_model_github/models/github_actions_job.dart";
import "package:masamune_model_github/models/github_actions_log.dart";
import "package:masamune_model_github/models/github_branch.dart";
import "package:masamune_model_github/models/github_commit.dart";
import "package:masamune_model_github/models/github_content.dart";
import "package:masamune_model_github/models/github_issue.dart";
import "package:masamune_model_github/models/github_issue_timeline.dart";
import "package:masamune_model_github/models/github_label.dart";
import "package:masamune_model_github/models/github_milestone.dart";
import "package:masamune_model_github/models/github_organization.dart";
import "package:masamune_model_github/models/github_project.dart";
import "package:masamune_model_github/models/github_pull_request.dart";
import "package:masamune_model_github/models/github_pull_request_head.dart";
import "package:masamune_model_github/models/github_pull_request_timeline.dart";
import "package:masamune_model_github/models/github_reaction.dart";
import "package:masamune_model_github/models/github_repository.dart";
import "package:masamune_model_github/models/github_user.dart";

export "models/github_branch.dart";
export "models/github_commit.dart";
export "models/github_content.dart";
export "models/github_issue.dart";
export "models/github_issue_timeline.dart";
export "models/github_label.dart";
export "models/github_milestone.dart";
export "models/github_organization.dart";
export "models/github_actions.dart";
export "models/github_actions_job.dart";
export "models/github_actions_log.dart";
export "models/github_pull_request.dart";
export "models/github_pull_request_timeline.dart";
export "models/github_pull_request_head.dart";
export "models/github_reaction.dart";
export "models/github_repository.dart";
export "models/github_repository_permission.dart";
export "models/github_license.dart";
export "models/github_user.dart";

part "adapter/github_model_adapter.dart";
part "adapter/github_model_masamune_adapter.dart";

part "src/github_organization_type.dart";
part "src/github_user_controller.dart";
part "src/github_timeline_event.dart";
