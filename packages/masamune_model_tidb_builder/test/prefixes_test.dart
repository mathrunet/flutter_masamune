// Copyright (c) 2025 mathru. All rights reserved.

// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:masamune_model_tidb_builder/src/prefixes.dart";

void main() {
  test("reads list and comma-separated builder options", () {
    expect(
      readTidbDatabasePrefixOption(["dev", "staging_"]),
      ["dev", "staging_"],
    );
    expect(
      readTidbDatabasePrefixOption("dev,staging_"),
      ["dev", "staging_"],
    );
    expect(readTidbDatabasePrefixOption(null), isEmpty);
  });

  test("normalizes and deduplicates prefixes", () {
    expect(
      normalizeTidbDatabasePrefixes([
        "dev",
        "dev_",
        " dev___ ",
        "staging",
        "",
        "___",
      ]),
      ["dev_", "staging_"],
    );
  });

  test("merges builder and annotation prefixes", () {
    final configured = readTidbDatabasePrefixOption("dev,staging");
    const annotated = ["dev_", "preview"];

    expect(
      normalizeTidbDatabasePrefixes([...configured, ...annotated]),
      ["dev_", "staging_", "preview_"],
    );
  });

  test("rejects invalid builder options and identifiers", () {
    expect(
      () => readTidbDatabasePrefixOption(true),
      throwsArgumentError,
    );
    expect(
      () => normalizeTidbDatabasePrefixes(["dev-test"]),
      throwsArgumentError,
    );
  });
}
