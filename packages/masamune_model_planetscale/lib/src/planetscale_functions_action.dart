part of '/masamune_model_planetscale.dart';

class _PlanetscaleFunctionsAction
    extends FunctionsAction<_PlanetscaleFunctionsActionResponse> {
  const _PlanetscaleFunctionsAction(this.queries);

  final List<_PlanetscaleQueryBase> queries;

  @override
  String get action => "planetscale";

  @override
  DynamicMap? toMap() {
    return {
      "query": queries.map((e) => e.toMap()).toList(),
    };
  }

  @override
  _PlanetscaleFunctionsActionResponse toResponse(DynamicMap map) {
    try {
      if (map.isEmpty) {
        throw Exception("Failed to get response from planetscale.");
      }

      if (!map.get("success", false)) {
        throw Exception(
          "Failed to get response from planetscale: ${map.get("message", "Unknown error.")}",
        );
      }
      return _PlanetscaleFunctionsActionResponse(
        data: map.getAsMap<DynamicMap>("data"),
        count: map.get<num?>("count", null)?.toInt(),
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

class _PlanetscaleFunctionsActionResponse extends FunctionsActionResponse {
  const _PlanetscaleFunctionsActionResponse({
    required this.data,
    this.count,
  });
  final Map<String, DynamicMap> data;
  final int? count;
}
