// Copyright 2023 mathru. All rights reserved.

/// Package that defines and notifies the model.
///
/// To use, import `package:katana_model_firestore/katana_model_firestore.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_model_firestore;

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:katana_firebase/katana_firebase.dart';
import 'package:katana_model/katana_model.dart';

export 'package:katana_firebase/katana_firebase.dart';
export 'package:katana_model/katana_model.dart';

part 'adapter/firestore_model_adapter.dart';
