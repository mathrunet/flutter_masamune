// Copyright (c) 2024 mathru. All rights reserved.

/// Building system for katana router packages. Automatic Page route generation.
///
/// To use, import `package:katana_router_builder/katana_router_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_router_builder;

// Dart imports:
import "dart:async";

// Package imports:
import "package:analyzer/dart/element/element.dart";
import "package:analyzer/dart/element/type.dart";
import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:dart_style/dart_style.dart";
import "package:glob/glob.dart";
import "package:katana_builder/katana_builder.dart";
import "package:katana_router_annotation/katana_router_annotation.dart";
import "package:source_gen/source_gen.dart" as source_gen;
import "package:source_gen/source_gen.dart";

part "common/query_class.dart";
part "common/router_class.dart";
part "generator/page_generator.dart";
part "generator/nested_page_generator.dart";
part "generator/router_generator.dart";
part "value/annotation_value.dart";
part "value/class_value.dart";
part "value/parameter_value.dart";
part "value/path_value.dart";
part "value/query_value.dart";
part "src/builder.dart";
part "src/config.dart";
part "src/functions.dart";
