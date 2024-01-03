// Copyright (c) 2024 mathru. All rights reserved.

/// Building system for masamune model planetscale. Prisma's scheme and API are automatically generated.
///
/// To use, import `package:masamune_model_planetscale_builder/masamune_model_planetscale_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_model_planetscale_builder;

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masamune_annotation/masamune_annotation.dart';
import 'package:masamune_model_planetscale_annotation/masamune_model_planetscale_annotation.dart';
import 'package:source_gen/source_gen.dart';

// ignore: implementation_imports

part 'src/builder.dart';
part 'src/extensions.dart';
part 'value/annotation_value.dart';
part 'value/class_value.dart';
part 'value/parameter_value.dart';
part 'value/path_value.dart';
