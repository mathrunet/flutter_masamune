part of '/masamune_model_planetscale.dart';

@immutable
class _PlanetscaleGetDocumentQuery extends _PlanetscaleQueryBase {
  const _PlanetscaleGetDocumentQuery({
    required this.query,
  });

  final ModelAdapterDocumentQuery query;

  @override
  String get method => "GET";

  @override
  String get table => query.query.path.first();

  @override
  DynamicMap toMap() {
    return {
      "method": method,
      "table": table,
      "where": [
        ModelQueryFilter.equal(
          key: "@uid",
          value: query.query.path.last(),
        ).toJson(),
        const ModelQueryFilter.limitTo(value: 1),
      ]
    };
  }
}

@immutable
class _PlanetscaleGetCollectionQuery extends _PlanetscaleQueryBase {
  const _PlanetscaleGetCollectionQuery({
    required this.query,
  });

  final ModelAdapterCollectionQuery query;

  @override
  String get method => "GET";

  @override
  String get table => query.query.path;

  @override
  DynamicMap toMap() {
    return {
      "method": method,
      "table": table,
      "where": [
        ...query.query.filters.map((e) => e.toJson()),
      ],
    };
  }
}

@immutable
class _PlanetscalePostDocumentQuery extends _PlanetscaleQueryBase {
  const _PlanetscalePostDocumentQuery({
    required this.query,
    required this.value,
  });

  final ModelAdapterDocumentQuery query;
  final DynamicMap value;

  @override
  String get method => "POST";

  @override
  String get table => query.query.path.first();

  @override
  DynamicMap toMap() {
    return {
      "method": method,
      "table": table,
      "where": [
        ModelQueryFilter.equal(
          key: "@uid",
          value: query.query.path.last(),
        ).toJson(),
      ],
      "value": value,
    };
  }
}

@immutable
class _PlanetscaleDeleteDocumentQuery extends _PlanetscaleQueryBase {
  const _PlanetscaleDeleteDocumentQuery({
    required this.query,
  });

  final ModelAdapterDocumentQuery query;

  @override
  String get method => "DELETE";

  @override
  String get table => query.query.path.first();

  @override
  DynamicMap toMap() {
    return {
      "method": method,
      "table": table,
      "where": [
        ModelQueryFilter.equal(
          key: "@uid",
          value: query.query.path.last(),
        ).toJson(),
      ],
    };
  }
}

@immutable
class _PlanetscaleCountCollectionQuery extends _PlanetscaleQueryBase {
  const _PlanetscaleCountCollectionQuery({
    required this.query,
  });

  final ModelAdapterCollectionQuery query;

  @override
  String get method => "COUNT";

  @override
  String get table => query.query.path;

  @override
  DynamicMap toMap() {
    return {
      "method": method,
      "table": table,
      "where": [
        ...query.query.filters.map((e) => e.toJson()),
      ],
    };
  }
}

@immutable
abstract class _PlanetscaleQueryBase {
  const _PlanetscaleQueryBase();

  String get method;

  String get table;

  DynamicMap toMap();
}
