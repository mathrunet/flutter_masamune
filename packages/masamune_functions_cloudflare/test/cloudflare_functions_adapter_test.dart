// Package imports:
import "package:masamune/masamune.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_functions_cloudflare/masamune_functions_cloudflare.dart";

class _TestAction extends FunctionsAction<DynamicMap> {
  const _TestAction({
    this.workerType,
    this.path,
  });

  @override
  final String? workerType;

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

  test("workerType null resolves to endpoint", () {
    expect(
      adapter.resolveUrl(const _TestAction()),
      "https://edge.example.com/test_action",
    );
  });

  test("workerType edge resolves to endpoint", () {
    expect(
      adapter.resolveUrl(const _TestAction(workerType: "edge")),
      "https://edge.example.com/test_action",
    );
  });

  test("workerType region resolves to regionEndpoint", () {
    expect(
      adapter.resolveUrl(const _TestAction(workerType: "region")),
      "https://region.example.com/test_action",
    );
  });

  test("path takes precedence over action", () {
    expect(
      adapter.resolveUrl(
        const _TestAction(workerType: "region", path: "/api/nested/path/"),
      ),
      "https://region.example.com/api/nested/path",
    );
    expect(
      adapter.resolveUrl(const _TestAction(path: "api/edge")),
      "https://edge.example.com/api/edge",
    );
  });

  test("region workerType without regionEndpoint throws StateError", () {
    const edgeOnly = CloudflareFunctionsAdapter(
      endpoint: "https://edge.example.com",
    );
    expect(
      () => edgeOnly.resolveUrl(const _TestAction(workerType: "region")),
      throwsStateError,
    );
  });

  test("unknown workerType throws UnsupportedError", () {
    expect(
      () => adapter.resolveUrl(const _TestAction(workerType: "unknown")),
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
