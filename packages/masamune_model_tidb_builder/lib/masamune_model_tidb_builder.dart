// Copyright (c) 2025 mathru. All rights reserved.

/// Builder for TiDB共通スキーマ.
library;

// Dart imports:
import "dart:async";
import "dart:convert";

// Package imports:
import "package:analyzer/dart/element/element.dart";
import "package:build/build.dart";
import "package:masamune_model_tidb_annotation/masamune_model_tidb_annotation.dart";
import "package:source_gen/source_gen.dart";

// Project imports:
import "src/schema_spec.dart";
import "src/prefixes.dart";

export "src/schema_spec.dart";

part "src/builder.dart";

/// Creates the TiDBスキーマ aggregate builder.
///
/// TiDBスキーマの集約Builderを作成します。
Builder masamuneModelTidbBuilderFactory(BuilderOptions options) {
  return _MasamuneModelTidbBuilder(
    readTidbDatabasePrefixOption(options.config["prefixes"]),
  );
}
