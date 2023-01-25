// Copyright 2023 mathru. All rights reserved.

/// Firestore plugin for katana_model. A package that models data into documents and collections and allows Firestore, local DB, and data mocks to be handled in the same interface.
///
/// To use, import `package:katana_model_firestore/katana_model_firestore.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_model_firestore;

// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:katana_firebase/katana_firebase.dart';
import 'package:katana_model/katana_model.dart';

export 'package:katana_firebase/katana_firebase.dart';
export 'package:katana_model/katana_model.dart';

part 'adapter/firestore_model_adapter.dart';
