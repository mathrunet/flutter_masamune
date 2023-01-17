// Copyright 2023 mathru. All rights reserved.

/// Provides an adapter for use with Firebase Functions. Provides an interface to execute server-side processing in a type-safe manner. Actual processing on the server side is done by importing a separate adapter.
///
/// To use, import `package:katana_functions_firebase/katana_functions_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_functions_firebase;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:katana_firebase/katana_firebase.dart';
import 'package:katana_functions/katana_functions.dart';

export 'package:katana_functions/katana_functions.dart';

part 'adapter/firebase_functions_adapter.dart';
