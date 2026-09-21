// Copyright (c) 2025 mathru. All rights reserved.

/// Builder for generating Cloudflare D1 schema fragments from Masamune models.
///
/// Katana CLI aggregates the generated fragments into a shared schema manifest.
///
/// To use, import `package:masamune_model_d1_builder/masamune_model_d1_builder.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library;

// Dart imports:
import "dart:async";
import "dart:convert";

// Package imports:
import "package:analyzer/dart/element/element.dart";
import "package:build/build.dart";
import "package:masamune_model_d1_annotation/masamune_model_d1_annotation.dart";
import "package:source_gen/source_gen.dart";

// Project imports:
import "src/schema_spec.dart";
import "src/prefixes.dart";

export "src/schema_spec.dart";

part "src/builder.dart";

/// Creates the Cloudflare D1 schema fragment builder.
///
/// Cloudflare D1のスキーマ断片を生成するBuilderを作成します。
Builder masamuneModelD1BuilderFactory(BuilderOptions options) {
  return _MasamuneModelD1Builder(
    readD1DatabasePrefixOption(options.config["prefixes"]),
  );
}
