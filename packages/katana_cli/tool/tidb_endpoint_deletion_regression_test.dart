// Dart imports:
import "dart:collection";
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/tidb.dart";
import "package:katana_cli/action/cloudflare/tidb_data_service_api.dart";

Future<void> main() async {
  await _waitsForTheNewAutomaticDeployment();
  await _reportsAutomaticDeploymentFailure();
  await _retriesEndpointPropagation();
  _detectsMissingGeneratedEndpointsDespiteLocalOwnership();
  stdout.writeln("All TiDB endpoint deletion checks passed.");
}

void _detectsMissingGeneratedEndpointsDespiteLocalOwnership() {
  final generated = <Map<String, dynamic>>[
    {
      "method": "POST",
      "endpoint": "/internal/onboarding/verify_persistence",
    },
    {
      "method": "POST",
      "endpoint": "/internal/dev/onboarding/verify_persistence",
    },
  ];
  final completeRemote = <Map<String, dynamic>>[
    {
      "method": "POST",
      "path": "/internal/onboarding/verify_persistence",
    },
    {
      "method": "POST",
      "path": "/internal/dev/onboarding/verify_persistence",
    },
  ];
  _expectEqual(
    tidbGeneratedEndpointSetIsComplete(generated, completeRemote),
    true,
    "a complete remote endpoint set is reusable",
  );
  _expectEqual(
    tidbGeneratedEndpointSetIsComplete(
      generated,
      completeRemote.take(1),
    ),
    false,
    "a missing remote endpoint must force synchronization",
  );
  _expectEqual(
    tidbGeneratedEndpointSetIsComplete(generated, [
      completeRemote.first,
      {
        "method": "GET",
        "path": "/internal/dev/onboarding/verify_persistence",
      },
    ]),
    false,
    "a remote endpoint with the wrong method must force synchronization",
  );
}

Future<void> _waitsForTheNewAutomaticDeployment() async {
  final api = _FakeTidbDataServiceApi([
    _deployment("deployments/old", "success"),
    const {},
    _deployment("deployments/new", "pending"),
    _deployment("deployments/new", "success"),
  ]);

  await deleteTidbDataServiceEndpointAndWait(
    api,
    appId: "dataapp-test",
    endpointName: "dataApps/dataapp-test/endpoints/1",
    pollInterval: Duration.zero,
  );

  _expectEqual(api.deletedEndpoints.length, 1, "endpoint is deleted once");
  _expectEqual(api.deploymentReads, 4, "automatic deployment is polled");
}

Future<void> _reportsAutomaticDeploymentFailure() async {
  final api = _FakeTidbDataServiceApi([
    _deployment("deployments/old", "success"),
    _deployment(
      "deployments/new",
      "failed",
      error: "fixture failure",
    ),
  ]);

  try {
    await deleteTidbDataServiceEndpointAndWait(
      api,
      appId: "dataapp-test",
      endpointName: "dataApps/dataapp-test/endpoints/2",
      pollInterval: Duration.zero,
    );
  } on StateError catch (exception) {
    if (exception.message.toString().contains("fixture failure")) {
      return;
    }
    throw StateError("deployment failure detail was not preserved");
  }
  throw StateError("failed automatic deployment was not reported");
}

Future<void> _retriesEndpointPropagation() async {
  var calls = 0;
  final result = await retryTidbDataEndpointUntilDeployed(
    () async {
      calls++;
      if (calls < 3) {
        throw const HttpException("deployed endpoint not found");
      }
      return {"data": "ready"};
    },
    pollInterval: Duration.zero,
  );

  _expectEqual(calls, 3, "endpoint propagation is retried");
  _expectEqual(result["data"], "ready", "propagated endpoint result is kept");
}

Map<String, dynamic> _deployment(
  String name,
  String status, {
  String? error,
}) {
  return {
    "deployments": [
      {
        "name": name,
        "status": status,
        if (error != null) "statusErrorMessage": error,
      },
    ],
  };
}

class _FakeTidbDataServiceApi implements TidbDataServiceApi {
  _FakeTidbDataServiceApi(Iterable<Map<String, dynamic>> deploymentResponses)
      : _deploymentResponses = Queue.of(deploymentResponses);

  final Queue<Map<String, dynamic>> _deploymentResponses;
  final List<String> deletedEndpoints = [];
  int deploymentReads = 0;

  @override
  Future<Map<String, dynamic>> dataService(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    if (method == "DELETE") {
      deletedEndpoints.add(path);
      return {};
    }
    if (method == "GET" && path.endsWith("/deployments")) {
      deploymentReads++;
      if (_deploymentResponses.isEmpty) {
        throw StateError("unexpected deployment poll");
      }
      return _deploymentResponses.removeFirst();
    }
    throw StateError("unexpected request: $method $path");
  }
}

void _expectEqual(Object? actual, Object? expected, String message) {
  if (actual != expected) {
    throw StateError("$message: expected $expected, got $actual");
  }
}
