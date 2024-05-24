// Copyright (c) 2024 mathru. All rights reserved.

/// This is a macro package for creating immutable data classes. It can be applied to widgets in addition to regular data.
///
/// To use, import `package:katana_value/katana_value.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_value;

import 'dart:async';

import 'package:katana/katana.dart';
import 'package:macros/macros.dart';

export 'package:katana/katana.dart';

part 'framework/extensions.dart';
part 'framework/macro_class_value.dart';
part 'framework/macro_variable_value.dart';
part 'framework/macro_type_value.dart';
part 'framework/macro_constructor_value.dart';
part 'framework/macro_method_value.dart';
part 'framework/macro_code.dart';

part 'macro/data_value.dart';

part 'src/equal_operator.dart';
part 'src/copy_with.dart';
part 'src/to_string.dart';
part 'src/constructor.dart';
part 'src/fields.dart';
part 'src/to_json.dart';
part 'src/from_json.dart';
part 'src/macro_json_converter.dart';
