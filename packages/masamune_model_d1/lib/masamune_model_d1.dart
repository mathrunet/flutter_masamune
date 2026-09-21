// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune model adapters for accessing Cloudflare D1 through Cloudflare Workers.
///
/// Includes session management and persistent local caching.
///
/// To use, import `package:masamune_model_d1/masamune_model_d1.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:convert";

// Package imports:
import "package:masamune/masamune.dart";
import "package:meta/meta.dart";

part "actions/d1_delete_model_functions_action.dart";
part "actions/d1_get_model_functions_action.dart";
part "actions/d1_post_model_functions_action.dart";
part "actions/d1_put_model_functions_action.dart";
part "adapter/cached_d1_model_adapter.dart";
part "adapter/d1_model_adapter.dart";
part "src/cached_d1_model_collection_loader_response.dart";
part "src/d1_database_prefix.dart";
part "src/d1_model_path.dart";
part "src/d1_query.dart";
part "src/d1_sql.dart";

part "src/d1_session.dart";
part "actions/d1_batch_model_functions_action.dart";
