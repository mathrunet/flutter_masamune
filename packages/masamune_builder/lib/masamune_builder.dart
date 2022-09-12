// Copyright 2022 mathru. All rights reserved.

/// Building system for masamune packages. Automatic Model creation and Page route generation.
///
/// To use, import `package:masamune_builder/masamune_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_builder;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:katana_annotation/katana_annotation.dart';
import 'package:source_gen/source_gen.dart';

part 'src/builder.dart';
part 'src/extensions.dart';
