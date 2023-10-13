// Copyright 2023 mathru. All rights reserved.

/// Base package to facilitate switching between Local and Firebase storage implementations.
///
/// To use, import `package:katana_storage/katana_storage.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_storage;

// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:katana/katana.dart';

import 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

export 'package:katana/katana.dart';

export 'src/others/others.dart'
    if (dart.library.io) 'src/others/others.dart'
    if (dart.library.js) 'src/web/web.dart'
    if (dart.library.html) 'src/web/web.dart';

part 'adapter/local_storage_adapter.dart';
part 'adapter/runtime_storage_adapter.dart';
part 'src/memory_storage.dart';
part 'src/storage.dart';
part 'src/storage_adapter.dart';
part 'src/storage_base.dart';
part 'src/storage_query.dart';
part 'src/storage_value.dart';
