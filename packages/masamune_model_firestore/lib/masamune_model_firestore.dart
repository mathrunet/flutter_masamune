// Copyright (c) 2024 mathru. All rights reserved.

/// A model adapter plugin that applies and expands on `katana_model_firestore` to retrieve data from Firestore.
///
/// To use, import `package:masamune_model_firestore/masamune_model_firestore.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_model_firestore;

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:katana_model_firestore/katana_model_firestore.dart';
import 'package:masamune/masamune.dart';

part 'adapter/cached_firestore_model_adapter.dart';
part 'adapter/cached_listenable_firestore_model_adapter.dart';

part 'src/cached_firestore_model_adapter_collection_loader.dart';
