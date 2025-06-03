// Copyright (c) 2024 mathru. All rights reserved.

/// Building system for katana theme packages. Create a list of image assets from the Asset folder.
///
/// To use, import `package:katana_theme_builder/katana_theme_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_theme_builder;

// Dart imports:
import "dart:async";
import "dart:io";

// Package imports:
import "package:analyzer/dart/element/element.dart";
import "package:build/build.dart";
import "package:code_builder/code_builder.dart";
import "package:dart_style/dart_style.dart";
import "package:glob/glob.dart";
import "package:katana_theme_annotation/katana_theme_annotation.dart";
import "package:source_gen/source_gen.dart";
import "package:yaml/yaml.dart";

part "common/extensions.dart";
part "generator/theme_generator.dart";
part "src/builder.dart";
part "value/asset_value.dart";
part "value/font_node.dart";
part "value/asset_node.dart";
part "value/asset_config.dart";
part "value/font_value.dart";
