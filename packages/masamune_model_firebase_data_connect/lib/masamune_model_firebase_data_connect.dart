// Copyright (c) 2024 mathru. All rights reserved.

/// A model package for Masamune that automatically generates GraphQL files for Firebase Data Connect from Collection and Document data schemes so that they can be used in applications.
///
/// To use, import `package:masamune_model_firebase_data_connect/masamune_model_firebase_data_connect.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_model_firebase_data_connect;

import 'dart:async';

import 'package:masamune/masamune.dart';

export 'package:masamune/masamune.dart';
export 'package:masamune_model_firebase_data_connect_annotation/masamune_model_firebase_data_connect_annotation.dart';

part 'adapter/firebase_data_connect_model_adapter.dart';
