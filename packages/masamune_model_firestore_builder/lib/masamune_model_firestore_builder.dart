// Copyright (c) 2025 mathru. All rights reserved.

/// Define a builder to describe Firestore rules; build using the masamune_annotation annotation.
///
/// To use, import `package:masamune_model_firestore_builder/masamune_model_firestore_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:convert";
import "dart:io";

// Package imports:
import "package:analyzer/dart/element/element2.dart";
import "package:analyzer/dart/element/type.dart";
import "package:build/build.dart";
import "package:glob/glob.dart";
import "package:katana_builder/katana_builder.dart";
import "package:masamune_annotation/masamune_annotation.dart";
import "package:masamune_builder/masamune_builder.dart";
import "package:meta/meta.dart";
import "package:source_gen/source_gen.dart";

part "src/builder.dart";
part "src/extensions.dart";
part "src/functions.dart";
part "value/rule_value.dart";
part "value/rule_type.dart";
part "value/index_value.dart";
part "value/index_type.dart";
