// Copyright (c) 2024 mathru. All rights reserved.

/// A builder package to generate table and schema definitions for Firebase and databases from Masamune model definitions, output in Markdown tabular format.
///
/// To use, import `package:masamune_model_docs_builder/masamune_model_docs_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_model_docs_builder;

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:katana_builder/katana_builder.dart';
import 'package:masamune_annotation/masamune_annotation.dart';
import 'package:masamune_builder/masamune_builder.dart';
import 'package:source_gen/source_gen.dart';

part 'src/builder.dart';
part 'src/extensions.dart';
part 'src/functions.dart';
part 'value/docs_value.dart';
part 'value/docs_type.dart';
