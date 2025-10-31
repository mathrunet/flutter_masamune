// Copyright (c) 2025 mathru. All rights reserved.

/// Define a builder to describe Firestore rules; build using the masamune_annotation annotation.
///
/// To use, import `package:masamune_model_firebase_data_connect_builder/masamune_model_firebase_data_connect_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:io";

// Package imports:
import "package:analyzer/dart/element/element2.dart";
import "package:analyzer/dart/element/type.dart";
import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:dart_style/dart_style.dart";
import "package:glob/glob.dart";
import "package:katana_builder/katana_builder.dart";
import "package:masamune_builder/masamune_builder.dart";
import "package:masamune_model_firebase_data_connect_annotation/masamune_model_firebase_data_connect_annotation.dart";
import "package:source_gen/source_gen.dart" as source_gen;
import "package:source_gen/source_gen.dart";

part "common/adapter_class.dart";

part "generator/adapter_generator.dart";

part "src/builder.dart";
part "src/extensions.dart";
part "src/functions.dart";

part "value/schema_type.dart";
part "value/schema_value.dart";
part "value/ignored_value.dart";
part "value/auth_type.dart";
