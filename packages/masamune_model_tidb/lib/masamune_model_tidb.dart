// Copyright (c) 2025 mathru. All rights reserved.

/// Masamune plugin package that includes a model adapter to retrieve data from TiDB.
///
/// To use, import `package:masamune_model_tidb/masamune_model_tidb.dart`.
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

part "actions/tidb_delete_model_functions_action.dart";
part "actions/tidb_get_model_functions_action.dart";
part "actions/tidb_post_model_functions_action.dart";
part "actions/tidb_put_model_functions_action.dart";
part "adapter/cached_tidb_model_adapter.dart";
part "adapter/tidb_model_adapter.dart";
part "src/cached_tidb_model_collection_loader_response.dart";
part "src/tidb_database_prefix.dart";
part "src/tidb_model_path.dart";
part "src/tidb_query.dart";
part "src/tidb_sql.dart";
