// Copyright (c) 2025 mathru. All rights reserved.

/// Builder for generating Cloudflare Durable Objects schema fragments from Masamune models.
///
/// Katana CLI aggregates the generated fragments into a shared schema manifest.
///
/// To use, import `package:masamune_model_do_builder/masamune_model_do_builder.dart`.
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
import "package:masamune_model_do_annotation/masamune_model_do_annotation.dart";
import "package:source_gen/source_gen.dart";

// Project imports:
import "src/prefixes.dart";
import "src/schema_spec.dart";

export "src/schema_spec.dart";

part "src/builder.dart";

/// Creates the Cloudflare Durable Objects schema fragment builder.
///
/// Cloudflare Durable Objectsのスキーマ断片を生成するBuilderを作成します。
Builder masamuneModelDurableObjectBuilderFactory(BuilderOptions options) {
  return _MasamuneModelDurableObjectBuilder(
    readDurableObjectDatabasePrefixOption(options.config["prefixes"]),
  );
}
