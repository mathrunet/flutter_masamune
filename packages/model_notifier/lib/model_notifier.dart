// Copyright 2022 mathru. All rights reserved.

/// Package that defines and notifies the model.
///
/// To use, import `package:model_notifier/model_notifier.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library model_notifier;

import 'dart:async';
import "dart:collection";
import 'dart:convert';
import "dart:math";

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:katana_flutter/katana_flutter.dart';
import 'package:katana_flutter/katana_flutter.dart' as katana show generateCode;

import 'src/others/others.dart'
    if (dart.library.io) 'src/mobile/mobile.dart'
    if (dart.library.js) 'src/others/others.dart'
    if (dart.library.html) 'src/others/others.dart';

export 'package:katana_flutter/katana_flutter.dart';

part "local/local_collection_model.dart";
part "local/local_database.dart";
part "local/local_document_meta_mixin.dart";
part "local/local_document_model.dart";
part "local/local_dynamic_collection_model.dart";
part "local/local_dynamic_document_model.dart";
part "local/local_search_query_mixin.dart";
part "local/local_transaction.dart";
part "local/local_dynamic_searchable_collection_model.dart";
part "remote/api_collection_model.dart";
part "remote/api_document_model.dart";
part "remote/api_dynamic_collection_model.dart";
part "remote/api_dynamic_document_model.dart";
part "runtime/runtime_collection_model.dart";
part "runtime/runtime_database.dart";
part "runtime/runtime_document_meta_mixin.dart";
part "runtime/runtime_document_model.dart";
part "runtime/runtime_dynamic_collection_model.dart";
part "runtime/runtime_dynamic_document_model.dart";
part "runtime/runtime_search_query_mixin.dart";
part "runtime/runtime_dynamic_searchable_collection_model.dart";
part "runtime/runtime_transaction.dart";
part 'src/convertable_value_model.dart';
part "src/dynamic_collection_model.dart";
part "src/counter_updater_interval.dart";
part "src/dynamic_document_model.dart";
part 'src/extensions.dart';
part 'src/functions.dart';
part 'src/future_model.dart';
part "src/geo_data.dart";
part 'src/list_model.dart';
part "src/list_model_mixin.dart";
part "src/listenable_list.dart";
part 'src/listenable_listener.dart';
part "src/listenable_map.dart";
part "src/local_store.dart";
part "src/map_model.dart";
part "src/map_model_mixin.dart";
part "src/model.dart";
part 'src/model_query.dart';
part 'src/transaction_builder.dart';
part 'src/stored_model.dart';
part 'src/typedef.dart';
part "src/value_model.dart";
part "src/dynamic_searchable_collection_model.dart";
