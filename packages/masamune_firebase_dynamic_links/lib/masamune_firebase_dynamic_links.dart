// Copyright 2022 mathru. All rights reserved.

/// Masamune firebase dynamic links framework library.
///
/// To use, import `package:masamune_firebase_dynamic_links/masamune_firebase_dynamic_links.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_firebase_dynamic_links;

import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:masamune_firebase/masamune_firebase.dart';

export 'package:masamune/masamune.dart';
export 'package:masamune_firebase/masamune_firebase.dart';

part 'adapter/firebase_dynamic_links_adapter.dart';
part 'src/firebase_dynamic_links_core.dart';
part 'src/firebase_dynamic_links_model.dart';
