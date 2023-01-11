// Copyright 2023 mathru. All rights reserved.

/// Base package to facilitate switching between Local and Firebase storage implementations.
///
/// To use, import `package:katana_functions/katana_functions.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_functions;

import 'package:flutter/widgets.dart';
import 'package:katana/katana.dart';

export 'package:katana/katana.dart';

part 'adapter/runtime_functions_adapter.dart';

part 'src/functions.dart';
part 'src/functions_adapter.dart';
