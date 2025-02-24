// Copyright (c) 2024 mathru. All rights reserved.

// ignore_for_file: implementation_imports

/// Plug-in to make Firebase Vertex AI available on Masamune Framework.
///
/// To use, import `package:masamune_ai_firebase/masamune_ai_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_ai_firebase;

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:masamune/masamune.dart';
import 'package:masamune_ai/masamune_ai.dart';
import 'package:universal_platform/universal_platform.dart';

part 'adapter/firebase_ai_masamune_adapter.dart';
