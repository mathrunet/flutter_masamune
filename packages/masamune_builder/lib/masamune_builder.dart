// Copyright 2022 mathru. All rights reserved.

/// Building system for masamune packages. Automatic Model creation and Page route generation.
///
/// To use, import `package:masamune_builder/masamune_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_builder;

import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/file_system/overlay_file_system.dart';
import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:katana_annotation/katana_annotation.dart';
import 'package:source_gen/source_gen.dart';

part 'src/builder.dart';
part 'src/extensions.dart';
part 'src/functions.dart';

part 'model/class_model.dart';
part 'model/parameter_model.dart';

part 'common/path_field.dart';
part 'common/converter_field.dart';
part 'common/convert_method.dart';
part 'common/key_const_class.dart';
part 'common/document_class.dart';
part 'common/collection_class.dart';
part 'common/dynamic_map_extensions.dart';
part 'common/dynamic_map_collection_extensions.dart';
part 'common/widget_ref_document_extensions.dart';
part 'common/widget_ref_collection_extensions.dart';
