// Copyright (c) 2024 mathru. All rights reserved.

/// Building system for masamune framework. Automatic creation of models, themes, pages, and translation data.
///
/// To use, import `package:masamune_builder/masamune_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_builder;

// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:katana_builder/katana_builder.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:masamune_annotation/masamune_annotation.dart';
import 'package:source_gen/source_gen.dart';

export 'package:katana/katana.dart';
export 'package:katana_listenables_builder/katana_listenables_builder.dart'
    show katanaListenablesBuilderFactory;
export 'package:katana_localization_builder/katana_localization_builder.dart'
    show katanaLocalizationBuilderFactory;
export 'package:katana_prefs_builder/katana_prefs_builder.dart'
    show katanaPrefsBuilderFactory;
export 'package:katana_router_builder/katana_router_builder.dart'
    show katanaRouterPageBuilderFactory, katanaRouterRouterBuilderFactory;
export 'package:katana_theme_builder/katana_theme_builder.dart'
    show katanaThemeBuilderFactory;

part 'controller/controller_class.dart';
part 'controller_group/controller_group_class.dart';
part 'form/form_value.dart';
part 'generator/collection_model_generator.dart';
part 'generator/controller_generator.dart';
part 'generator/controller_group_generator.dart';
part 'generator/document_model_generator.dart';
part 'generator/form_value_generator.dart';
part 'model/collection_model_class.dart';
part 'model/collection_model_query_class.dart';
part 'model/document_model_class.dart';
part 'model/document_model_query_class.dart';
part 'model/model_class.dart';
part 'src/builder.dart';
part 'src/config.dart';
part 'value/class_value.dart';
part 'value/typedef_value.dart';
part 'value/parameter_value.dart';
part 'value/path_value.dart';
part 'value/annotation_value.dart';
part 'value/google_spread_sheet_value.dart';
part 'value/permission_value.dart';
