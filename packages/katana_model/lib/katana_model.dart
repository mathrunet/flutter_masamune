// Copyright 2023 mathru. All rights reserved.

/// A package that models data into documents and collections and allows Firestore, local DB, and data mocks to be handled in the same interface.
///
/// To use, import `package:katana_model/katana_model.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_model;

// Dart imports:
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:katana/katana.dart';

export 'package:katana/katana.dart';

part 'adapter/runtime_model_adapter.dart';

part 'extension/searchable_document_mixin.dart';
part 'extension/searchable_collection_mixin.dart';
part 'extension/searchable_initial_collection_mixin.dart';

part 'src/const.dart';
part 'src/model_update_notification.dart';
part 'src/document_base.dart';
part 'src/model_adapter.dart';
part 'src/no_sql_database.dart';
part 'src/model_ref.dart';
part 'src/model_uri.dart';
part 'src/model_query.dart';
part 'src/model_locale.dart';
part 'src/collection_base.dart';
part 'src/listenable_listener.dart';
part 'src/async_count_value.dart';
part 'src/model_batch.dart';
part 'src/model_transaction.dart';
part 'src/model_field_value.dart';
part 'src/model_geo_value.dart';
part 'src/model_initial_value.dart';
part 'src/model_access_query.dart';
part 'src/internal_transaction.dart';
