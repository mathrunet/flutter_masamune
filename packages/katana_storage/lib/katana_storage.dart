// Copyright 2023 mathru. All rights reserved.

/// Base package to facilitate switching between Local and Firebase storage implementations.
///
/// To use, import `package:katana_storage/katana_storage.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_storage;

import 'dart:async';
import 'dart:typed_data';

import 'package:katana/katana.dart';
import 'package:flutter/widgets.dart';

part 'adapter/runtime_storage_adapter.dart';

part 'src/storage.dart';
part 'src/storage_adapter.dart';
part 'src/storage_query.dart';
