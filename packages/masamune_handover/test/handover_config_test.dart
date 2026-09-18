// Copyright (c) 2026 mathru. All rights reserved.

// Dart imports:
import "dart:ui";

// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:masamune_handover/masamune_handover.dart";

void main() {
  group("HandoverConfig.fromJson", () {
    test("parses a full configuration", () {
      final config = HandoverConfig.fromJson(const {
        "mode": "maintenance",
        "message": {
          "ja": "メンテナンス中です",
          "en": "Under maintenance",
        },
        "scheduled_at": "2026-10-01T00:00:00Z",
        "estimated_end_at": "2026-10-01T06:00:00Z",
        "endpoints": {
          "api_base_url": "https://api.new-owner.example",
        },
        "features": {
          "purchase": false,
          "chat": true,
        },
        "force_update": {
          "min_version": "2.0.0",
          "store_url_ios": "https://apps.apple.com/app/id0000000000",
          "store_url_android":
              "https://play.google.com/store/apps/details?id=example",
        },
      });
      expect(config.mode, HandoverMode.maintenance);
      expect(config.messageFor(const Locale("ja")), "メンテナンス中です");
      expect(config.messageFor(const Locale("fr")), "Under maintenance");
      expect(config.scheduledAt, DateTime.utc(2026, 10, 1));
      expect(config.estimatedEndAt, DateTime.utc(2026, 10, 1, 6));
      expect(
        config.endpoint("api_base_url"),
        "https://api.new-owner.example",
      );
      expect(config.isFeatureEnabled("purchase"), false);
      expect(config.isFeatureEnabled("chat"), true);
      expect(config.minVersion, "2.0.0");
    });

    test("falls back to normal mode for unknown or missing mode", () {
      expect(
        HandoverConfig.fromJson(const {"mode": "unknown"}).mode,
        HandoverMode.normal,
      );
      expect(
        HandoverConfig.fromJson(const {}).mode,
        HandoverMode.normal,
      );
    });

    test("does not throw on malformed fields", () {
      final config = HandoverConfig.fromJson(const {
        "mode": 123,
        "message": "not-a-map",
        "scheduled_at": "not-a-date",
        "endpoints": 5,
        "features": null,
        "force_update": "not-a-map",
      });
      expect(config.mode, HandoverMode.normal);
      expect(config.message, isEmpty);
      expect(config.scheduledAt, isNull);
      expect(config.endpoints, isEmpty);
      expect(config.features, isEmpty);
      expect(config.minVersion, isNull);
    });
  });

  group("HandoverConfig.isFeatureEnabled", () {
    test("undefined features are disabled in readonly mode", () {
      final config = HandoverConfig.fromJson(const {"mode": "readonly"});
      expect(config.isFeatureEnabled("purchase"), false);
    });

    test("undefined features are enabled in other modes", () {
      final config = HandoverConfig.fromJson(const {"mode": "announce"});
      expect(config.isFeatureEnabled("purchase"), true);
    });

    test("explicit flags take precedence over the mode", () {
      final config = HandoverConfig.fromJson(const {
        "mode": "readonly",
        "features": {"chat": true},
      });
      expect(config.isFeatureEnabled("chat"), true);
    });
  });

  group("HandoverConfig delegation", () {
    test("parses delegate_url", () {
      final config = HandoverConfig.fromJson(const {
        "delegate_url": "https://config.new-owner.example/handover.json",
      });
      expect(
        config.delegateUrl,
        "https://config.new-owner.example/handover.json",
      );
    });
  });
}
