// Copyright (c) 2024 mathru. All rights reserved.

/// This is a macro package for creating immutable data classes. It can be applied to widgets in addition to regular data.
///
/// To use, import `package:katana_value/katana_value.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_value;

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:katana_macro/katana_macro.dart';
import 'package:macros/macros.dart';

export 'package:katana/katana.dart';

part 'macro/data_value.dart';

part 'src/equal_operator.dart';
part 'src/copy_with.dart';
part 'src/to_string.dart';
part 'src/constructor.dart';
part 'src/fields.dart';
part 'src/to_json.dart';
part 'src/from_json.dart';
part 'src/data_value_json_converter.dart';
