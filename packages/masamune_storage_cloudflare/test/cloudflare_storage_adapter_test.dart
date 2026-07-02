// Copyright (c) 2025 mathru. All rights reserved.

// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:masamune_storage_cloudflare/masamune_storage_cloudflare.dart";

void main() {
  test("fetchPublicURI builds a Cloudflare R2 public URL", () async {
    const adapter = CloudflareStorageAdapter(
      publicBaseUrl: "https://assets.example.com/",
    );

    final uri = await adapter.fetchPublicURI("/images/profile.jpg");

    expect(uri.toString(), "https://assets.example.com/images/profile.jpg");
  });
}
