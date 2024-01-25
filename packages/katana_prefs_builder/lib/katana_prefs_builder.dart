// Copyright (c) 2024 mathru. All rights reserved.

/// Building system for katana prefs packages. The package for type-safe use of retrieving and storing Shared Preferences values, defining data in a Freezed-like fashion.
///
/// To use, import `package:katana_prefs_builder/katana_prefs_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_prefs_builder;

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:katana_builder/katana_builder.dart';
import 'package:katana_prefs_annotation/katana_prefs_annotation.dart';
import 'package:source_gen/source_gen.dart';

part 'common/base_class.dart';
part 'generator/prefs_generator.dart';
part 'src/builder.dart';
part 'src/config.dart';
part 'value/class_value.dart';
part 'value/parameter_value.dart';
