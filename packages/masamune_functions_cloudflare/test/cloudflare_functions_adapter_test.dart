// Package imports:
import "package:masamune/masamune.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_functions_cloudflare/masamune_functions_cloudflare.dart";

class _TestAction extends FunctionsAction<DynamicMap> {
  const _TestAction({
    this.target,
    this.path,
  });

  @override
  final String? target;

  @override
  final String? path;

  @override
  String get action => "test_action";

  @override
  DynamicMap? toMap() => null;

  @override
  DynamicMap toResponse(DynamicMap map) => map;
}

void main() {
  const adapter = CloudflareFunctionsAdapter(
    endpoint: "https://edge.example.com/",
    regionEndpoint: "https://region.example.com/",
  );

  test("target null resolves to endpoint", () {
    expect(
      adapter.resolveUrl(const _TestAction()),
      "https://edge.example.com/test_action",
    );
  });

  test("target edge resolves to endpoint", () {
    expect(
      adapter.resolveUrl(const _TestAction(target: "edge")),
      "https://edge.example.com/test_action",
    );
  });

  test("target region resolves to regionEndpoint", () {
    expect(
      adapter.resolveUrl(const _TestAction(target: "region")),
      "https://region.example.com/test_action",
    );
  });

  test("path takes precedence over action", () {
    expect(
      adapter.resolveUrl(
        const _TestAction(target: "region", path: "/api/nested/path/"),
      ),
      "https://region.example.com/api/nested/path",
    );
    expect(
      adapter.resolveUrl(const _TestAction(path: "api/edge")),
      "https://edge.example.com/api/edge",
    );
  });

  test("region target without regionEndpoint throws StateError", () {
    const edgeOnly = CloudflareFunctionsAdapter(
      endpoint: "https://edge.example.com",
    );
    expect(
      () => edgeOnly.resolveUrl(const _TestAction(target: "region")),
      throwsStateError,
    );
  });

  test("unknown target throws UnsupportedError", () {
    expect(
      () => adapter.resolveUrl(const _TestAction(target: "unknown")),
      throwsUnsupportedError,
    );
  });

  test("regionEndpoint is part of equality", () {
    const other = CloudflareFunctionsAdapter(
      endpoint: "https://edge.example.com/",
    );
    expect(adapter == other, isFalse);
    expect(
      adapter ==
          const CloudflareFunctionsAdapter(
            endpoint: "https://edge.example.com/",
            regionEndpoint: "https://region.example.com/",
          ),
      isTrue,
    );
  });
}
