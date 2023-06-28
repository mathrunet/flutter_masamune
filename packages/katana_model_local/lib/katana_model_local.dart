// Copyright 2023 mathru. All rights reserved.

/// Local DB plugin for katana_model. A package that models data into documents and collections and allows Firestore, local DB, and data mocks to be handled in the same interface.
///
/// To use, import `package:katana_model_local/katana_model_local.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_model_local;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:katana_model/katana_model.dart';

import 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

export 'package:katana_model/katana_model.dart';

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

part 'adapter/local_model_adapter.dart';
