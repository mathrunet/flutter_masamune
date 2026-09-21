// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune model adapters for accessing Cloudflare Durable Objects through Cloudflare Workers.
///
/// Includes persistent local caching and real-time subscriptions.
///
/// To use, import `package:masamune_model_do/masamune_model_do.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:convert";

import "src/do_socket.dart";
export "src/do_socket.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:meta/meta.dart";

part "actions/do_delete_model_functions_action.dart";
part "actions/do_get_model_functions_action.dart";
part "actions/do_post_model_functions_action.dart";
part "actions/do_put_model_functions_action.dart";
part "adapter/cached_do_model_adapter.dart";
part "adapter/do_model_adapter.dart";
part "src/cached_do_model_collection_loader_response.dart";
part "src/do_database_prefix.dart";
part "src/do_model_path.dart";
part "src/do_query.dart";
part "src/do_sql.dart";

part "src/do_session.dart";
part "actions/do_batch_model_functions_action.dart";

part "adapters/listenable_durable_object.dart";
part "adapters/cached_listenable_durable_object.dart";
