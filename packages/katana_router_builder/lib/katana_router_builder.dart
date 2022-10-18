// Copyright 2023 mathru. All rights reserved.

/// Building system for katana router packages. Automatic Page route generation.
///
/// To use, import `package:masamune_builder/masamune_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_router_builder;

import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:katana_router_annotation/katana_router_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'package:source_gen/source_gen.dart' as source_gen;

part 'common/query_class.dart';
part 'common/router_class.dart';
part 'generator/page_generator.dart';
part 'generator/nested_page_generator.dart';
part 'generator/router_generator.dart';
part 'value/annotation_value.dart';
part 'value/class_value.dart';
part 'value/parameter_value.dart';
part 'value/path_value.dart';
part 'value/query_value.dart';
part 'src/builder.dart';
part 'src/config.dart';
part 'src/extensions.dart';
part 'src/functions.dart';
