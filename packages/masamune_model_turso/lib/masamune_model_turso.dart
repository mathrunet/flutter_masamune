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
import "package:libsql_dart/libsql_dart.dart";
import "package:masamune/masamune.dart";
import "package:meta/meta.dart";

part "actions/turso_delete_model_functions_action.dart";
part "actions/turso_get_model_functions_action.dart";
part "actions/turso_post_model_functions_action.dart";
part "actions/turso_put_model_functions_action.dart";
part "actions/turso_token_functions_action.dart";
part "adapter/turso_model_adapter.dart";
part "src/turso_model_path.dart";
part "src/turso_query.dart";
part "src/turso_sql.dart";
