// Copyright (c) 2025 mathru. All rights reserved.

/// Builder for TiDB Data Service Configuration as Code.
library;

// Dart imports:
import "dart:async";
import "dart:convert";
import "dart:io";

// Package imports:
import "package:analyzer/dart/element/element.dart";
import "package:build/build.dart";
import "package:masamune_model_tidb_annotation/masamune_model_tidb_annotation.dart";
import "package:source_gen/source_gen.dart";

// Project imports:
import "src/endpoint_spec.dart";
import "src/prefixes.dart";
import "src/rules_reader.dart";

export "src/endpoint_spec.dart";
export "src/rules_reader.dart";

part "src/builder.dart";

/// Creates the TiDB Data Service aggregate builder.
///
/// TiDB Data Serviceの集約Builderを作成します。
Builder masamuneModelTidbBuilderFactory(BuilderOptions options) {
  return _MasamuneModelTidbBuilder(
    readTidbDatabasePrefixOption(options.config["prefixes"]),
  );
}
