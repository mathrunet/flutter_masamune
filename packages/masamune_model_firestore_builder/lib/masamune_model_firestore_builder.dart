// Copyright (c) 2024 mathru. All rights reserved.

/// Define a builder to describe Firestore rules; build using the masamune_annotation annotation.
///
/// To use, import `package:masamune_model_firestore_builder/masamune_model_firestore_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_model_firestore_builder;

import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:masamune_annotation/masamune_annotation.dart';
import 'package:masamune_builder/masamune_builder.dart';
import 'package:source_gen/source_gen.dart';

part 'src/builder.dart';
part 'src/extensions.dart';
part 'value/rule_value.dart';
part 'value/rule_type.dart';
