// Copyright (c) 2024 mathru. All rights reserved.

/// Building system for katana localization packages. Automatic localization file generation.
///
/// To use, import `package:katana_localization_builder/katana_localization_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_localization_builder;

// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:io";
import "dart:typed_data";

// Package imports:
import "package:analyzer/dart/element/element.dart";
import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:csv/csv.dart";
import "package:dart_style/dart_style.dart";
import "package:http/http.dart" as http;
import "package:katana_localization_annotation/katana_localization_annotation.dart";
import "package:source_gen/source_gen.dart";

part "common/base_class.dart";
part "common/localize_class.dart";
part "generator/localize_generator.dart";
part "src/builder.dart";
part "src/config.dart";
part "src/loader.dart";
part "value/class_value.dart";
part "value/localize_value.dart";
part "value/path_value.dart";
