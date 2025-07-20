// Copyright (c) 2025 mathru. All rights reserved.

/// A model package for Masamune that automatically generates GraphQL files for Firebase Data Connect from Collection and Document data schemes so that they can be used in applications.
///
/// To use, import `package:masamune_model_firebase_data_connect/masamune_model_firebase_data_connect.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:convert";

// Flutter imports:
import "package:flutter/foundation.dart";

// Package imports:
import "package:firebase_data_connect/firebase_data_connect.dart";
import "package:katana_firebase/katana_firebase.dart";
import "package:masamune/masamune.dart";

export "package:masamune/masamune.dart";
export "package:masamune_model_firebase_data_connect_annotation/masamune_model_firebase_data_connect_annotation.dart";

part "adapter/firebase_data_connect_model_adapter.dart";

part "converter/firebase_data_connect_model_counter_converter.dart";
part "converter/firebase_data_connect_model_timestamp_converter.dart";
part "converter/firebase_data_connect_model_date_converter.dart";
part "converter/firebase_data_connect_model_command_base_converter.dart";
part "converter/firebase_data_connect_model_uri_converter.dart";
part "converter/firebase_data_connect_model_locale_converter.dart";
part "converter/firebase_data_connect_model_localized_value_converter.dart";
part "converter/firebase_data_connect_model_image_uri_converter.dart";
part "converter/firebase_data_connect_model_video_uri_converter.dart";
part "converter/firebase_data_connect_model_geo_value_converter.dart";
part "converter/firebase_data_connect_model_search_converter.dart";
part "converter/firebase_data_connect_model_ref_converter.dart";
part "converter/firebase_data_connect_null_converter.dart";
part "converter/firebase_data_connect_enum_converter.dart";
part "converter/firebase_data_connect_basic_converter.dart";
part "converter/firebase_data_connect_model_token_converter.dart";
part "converter/firebase_data_connect_model_time_converter.dart";
part "converter/firebase_data_connect_model_timestamp_range_converter.dart";
part "converter/firebase_data_connect_model_date_range_converter.dart";
part "converter/firebase_data_connect_model_time_range_converter.dart";
part "src/firebase_data_connect_model_field_value_converter.dart";
