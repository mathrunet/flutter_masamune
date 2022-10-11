// Copyright 2022 mathru. All rights reserved.

/// Building system for masamune packages. Automatic Model creation and Page route generation.
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
import 'package:katana_router_annotation/katana_router_annotation.dart';
import 'package:katana_router_riverpod_annotation/katana_router_riverpod_annotation.dart';
import 'package:source_gen/source_gen.dart';

part 'common/extends_class.dart';
part 'common/consumer_extends_class.dart';
part 'common/query_class.dart';
part 'common/value_class.dart';
part 'generator/page_generator.dart';
part 'generator/consumer_page_generator.dart';
part 'model/class_model.dart';
part 'model/parameter_model.dart';
part 'model/path_model.dart';
part 'src/builder.dart';
part 'src/config.dart';
part 'src/extensions.dart';
part 'src/functions.dart';
