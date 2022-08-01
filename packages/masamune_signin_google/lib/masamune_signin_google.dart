// Copyright 2022 mathru. All rights reserved.

/// Masamune google signin framework library.
///
/// To use, import `package:masamune_signin_google/masamune_signin_google.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_signin_google;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masamune_firebase/masamune_firebase.dart';
export 'package:masamune/masamune.dart';
export 'package:masamune_firebase/masamune_firebase.dart';

part 'src/google_auth.dart';
part 'adapter/google_sign_in_adapter.dart';
