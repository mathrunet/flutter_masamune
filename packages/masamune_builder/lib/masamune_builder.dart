// Copyright 2023 mathru. All rights reserved.

/// Building system for masamune framework. Automatic creation of models, themes, pages, and translation data.
///
/// To use, import `package:masamune_builder/masamune_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_builder;

import 'dart:async';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune_annotation/masamune_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:code_builder/src/specs/type_function.dart' as type_function;

export 'package:katana/katana.dart';
export 'package:katana_listenables_builder/katana_listenables_builder.dart'
    show katanaListenablesBuilderFactory;
export 'package:katana_localization_builder/katana_localization_builder.dart'
    show katanaLocalizationBuilderFactory;
export 'package:katana_router_builder/katana_router_builder.dart'
    show katanaRouterPageBuilderFactory, katanaRouterRouterBuilderFactory;
export 'package:katana_theme_builder/katana_theme_builder.dart'
    show katanaThemeBuilderFactory;

part 'src/builder.dart';
part 'src/config.dart';

part 'controller/controller_class.dart';
part 'controller_group/controller_group_class.dart';

part 'model/model_class.dart';
part 'model/document_model_class.dart';
part 'model/collection_model_class.dart';

part 'form/form_value.dart';

part 'generator/controller_generator.dart';
part 'generator/document_model_generator.dart';
part 'generator/controller_group_generator.dart';
part 'generator/collection_model_generator.dart';
part 'generator/form_value_generator.dart';

part 'value/path_value.dart';
part 'value/class_value.dart';
part 'value/parameter_value.dart';
