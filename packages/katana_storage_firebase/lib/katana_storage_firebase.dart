// Copyright 2023 mathru. All rights reserved.

/// Firebase plugin for katana_storage. A package to facilitate switching between Local and Firebase storage implementations.
///
/// To use, import `package:katana_storage_firebase/katana_storage_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_storage_firebase;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:katana_storage/katana_storage.dart';

part 'adapter/firebase_storage_adapter.dart';
