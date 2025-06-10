// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana_model/katana_model.dart";

void main() {
  test("modelAdapter.hasMatch", () {
    const modelAdapter = RuntimeModelAdapter();
    expect(modelAdapter.hasMatch(path: "shop", pattern: "shop"), []);
    expect(modelAdapter.hasMatch(path: "member", pattern: "shop"), null);
    expect(
      modelAdapter.hasMatch(path: "shop/aaaaaa", pattern: "shop/:shop_id"),
      ["aaaaaa"],
    );
    expect(
      modelAdapter.hasMatch(
          path: "shop/aaaaaa/member", pattern: "shop/:shop_id"),
      null,
    );
    expect(
      modelAdapter.hasMatch(
          path: "shop/aaaaaa/member", pattern: "shop/:shop_id/member"),
      ["aaaaaa"],
    );
    expect(
      modelAdapter.hasMatch(
          path: "shop/aaaaaa/member/bbbbbb", pattern: "shop/:shop_id/member"),
      null,
    );
    expect(
      modelAdapter.hasMatch(
          path: "shop/aaaaaa/member/bbbbbb",
          pattern: "shop/:shop_id/member/:member_id"),
      ["aaaaaa", "bbbbbb"],
    );
  });
}
