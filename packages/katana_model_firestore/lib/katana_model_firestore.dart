// Copyright 2023 mathru. All rights reserved.

/// Firestore plugin for katana_model. A package that models data into documents and collections and allows Firestore, local DB, and data mocks to be handled in the same interface.
///
/// To use, import `package:katana_model_firestore/katana_model_firestore.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_model_firestore;

// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:katana_firebase/katana_firebase.dart';
import 'package:katana_model/katana_model.dart';
import 'package:universal_platform/universal_platform.dart';

// Flutter imports:

export 'package:katana_firebase/katana_firebase.dart';
export 'package:katana_model/katana_model.dart';

part 'src/firestore_cache.dart';
part 'src/firestore_model_field_value_converter.dart';

part 'converter/firestore_model_counter_converter.dart';
part 'converter/firestore_model_timestamp_converter.dart';
part 'converter/firestore_model_uri_converter.dart';
part 'converter/firestore_model_locale_converter.dart';
part 'converter/firestore_model_localized_value_converter.dart';
part 'converter/firestore_model_image_uri_converter.dart';
part 'converter/firestore_model_video_uri_converter.dart';
part 'converter/firestore_model_geo_value_converter.dart';
part 'converter/firestore_model_search_converter.dart';
part 'converter/firestore_model_ref_converter.dart';
part 'converter/firestore_null_converter.dart';
part 'converter/firestore_enum_converter.dart';
part 'converter/firestore_basic_converter.dart';

part 'adapter/listenable_firestore_model_adapter.dart';
part 'adapter/firestore_model_adapter.dart';
