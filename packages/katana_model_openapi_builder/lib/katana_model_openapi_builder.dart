// Copyright (c) 2024 mathru. All rights reserved.

/// Building system for katana model open-api plugin packages. Create models of adapters and freezed available in katana_model from the open API yaml.
///
/// To use, import `package:katana_model_openapi_builder/katana_model_openapi_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_model_openapi_builder;

// Dart imports:
import "dart:async";
import "dart:convert";

// Package imports:
import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:dart_style/dart_style.dart";
import "package:katana/katana.dart";
import "package:open_api_forked/v3.dart";
import "package:yaml/yaml.dart";

part "src/builder.dart";
part "src/filter.dart";
part "src/extensions.dart";
part "generator/openapi_generator.dart";
part "common/freezed_class.dart";
