import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void main() {
  final defaultYaml = {
    "cloudflare": {
      "workers": {"enable": true}
    }
  };
  _check(
    resolveCloudflareWorkerLanguage(defaultYaml, detectExistingTs: false) ==
        "rust",
    "Expected default Cloudflare worker language to be rust.",
  );
  _check(
    isCloudflareRustWorker(defaultYaml, detectExistingTs: false),
    "Expected isCloudflareRustWorker to default to true.",
  );

  final tsYaml = {
    "cloudflare": {
      "workers": {"enable": true, "language": "ts"}
    }
  };
  _check(
    resolveCloudflareWorkerLanguage(tsYaml, detectExistingTs: false) == "ts",
    "Expected explicit ts fallback to resolve to ts.",
  );
  _check(
    !isCloudflareRustWorker(tsYaml, detectExistingTs: false),
    "Expected explicit ts fallback to return false for isCloudflareRustWorker.",
  );

  final rustYaml = {
    "cloudflare": {
      "workers": {"enable": true, "language": "rust"}
    }
  };
  _check(
    resolveCloudflareWorkerLanguage(rustYaml, detectExistingTs: true) == "rust",
    "Expected explicit rust setting to override existing TS detection.",
  );
  _check(
    isCloudflareRustWorker(rustYaml, detectExistingTs: true),
    "Expected explicit rust setting to return true.",
  );
}
