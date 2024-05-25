// Copyright (c) 2024 mathru. All rights reserved.

/// This package is designed to provide support for macros. It provides basic functionality for implementing macros.
///
/// To use, import `package:katana_macro/katana_macro.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_macro;

// Package imports:
import 'package:katana/katana.dart';
import 'package:macros/macros.dart';

export 'package:katana/katana.dart';

part 'src/extensions.dart';
part 'src/macro_class_value.dart';
part 'src/macro_variable_value.dart';
part 'src/macro_type_value.dart';
part 'src/macro_constructor_value.dart';
part 'src/macro_method_value.dart';
part 'src/macro_code.dart';
