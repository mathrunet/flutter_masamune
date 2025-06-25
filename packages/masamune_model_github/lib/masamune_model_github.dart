// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune plugin package that includes a model adapter to retrieve data from Github.
///
/// To use, import `package:masamune_model_github/masamune_model_github.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

import "dart:async";

import "package:github/github.dart" as github;
import "package:masamune/masamune.dart";
import "package:meta/meta.dart";

part "adapter/github_model_adapter.dart";
