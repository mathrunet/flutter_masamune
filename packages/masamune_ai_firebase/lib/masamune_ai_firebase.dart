// Copyright (c) 2025 mathru. All rights reserved.

// ignore_for_file: implementation_imports

/// Plug-in to make Firebase Vertex AI available on Masamune Framework.
///
/// To use, import `package:masamune_ai_firebase/masamune_ai_firebase.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";

// Package imports:
import "package:firebase_app_check/firebase_app_check.dart";
import "package:firebase_vertexai/firebase_vertexai.dart";
import "package:katana_firebase/katana_firebase.dart";
import "package:masamune/masamune.dart";
import "package:masamune_ai/masamune_ai.dart";
import "package:universal_platform/universal_platform.dart";

export "package:masamune_ai/masamune_ai.dart";
export "package:firebase_vertexai/firebase_vertexai.dart"
    show FunctionCallingConfig;

part "adapter/firebase_ai_masamune_adapter.dart";
part "src/extensions.dart";
part "src/firebase_ai_model.dart";
