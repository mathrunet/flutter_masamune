part of '/katana_model_firestore.dart';

/// FirestoreConverter for [ModelRef].
///
/// [ModelRef]用のFirestoreConverter。
class FirestoreModelRefConverter extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelRef].
  ///
  /// [ModelRef]用のFirestoreConverter。
  const FirestoreModelRefConverter();

  @override
  String get type => ModelRefBase.typeString;

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  ) {
    if (value is List) {
      if (value.every((e) => e is DocumentReference<DynamicMap>)) {
        return {
          key: value
              .whereType<DocumentReference<DynamicMap>>()
              .cast<DocumentReference<DynamicMap>>()
              .mapAndRemoveEmpty<DynamicMap>((e) {
            final path = adapter.prefix.isEmpty
                ? e.path
                : e.path.replaceAll(
                    RegExp("^${adapter.prefix!.trimQuery().trimString("/")}/"),
                    "",
                  );
            return ModelRefBase.fromPath(
              path,
            ).toJson();
          }),
        };
      }
    } else if (value is Map) {
      if (value.values.every((e) => e is DocumentReference<DynamicMap>)) {
        return {
          key: value
              .where((k, v) => v is DocumentReference<DynamicMap>)
              .cast<String, DocumentReference<DynamicMap>>()
              .map<String, DynamicMap>((k, v) {
            final path = adapter.prefix.isEmpty
                ? v.path
                : v.path.replaceAll(
                    RegExp("^${adapter.prefix!.trimQuery().trimString("/")}/"),
                    "",
                  );
            return MapEntry(
              k,
              ModelRefBase.fromPath(
                path,
              ).toJson(),
            );
          }),
        };
      }
    } else if (value is DocumentReference<DynamicMap>) {
      final path = adapter.prefix.isEmpty
          ? value.path
          : value.path.replaceAll(
              RegExp("^${adapter.prefix!.trimQuery().trimString("/")}/"),
              "",
            );
      return {
        key: ModelRefBase.fromPath(
          path,
        ).toJson(),
      };
    }
    return null;
  }

  @override
  DynamicMap? convertTo(
    String key,
    Object? value,
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  ) {
    if (value is DynamicMap && value.containsKey(_kTypeKey)) {
      if (value.get(_kTypeKey, "").startsWith(type)) {
        final ref = ModelRefBase.fromJson(value);
        return {
          key: adapter.database.doc(adapter._path(ref.modelQuery.path)),
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty &&
          list.every((e) => e.get(_kTypeKey, "").startsWith(type))) {
        final res = <DocumentReference<DynamicMap>>[];
        for (final entry in list) {
          final ref = ModelRefBase.fromJson(entry);
          res.add(adapter.database.doc(adapter._path(ref.modelQuery.path)));
        }
        return {
          key: res,
        };
      }
    } else if (value is Map) {
      final map = value
          .where((key, value) => value is DynamicMap)
          .cast<String, DynamicMap>();
      if (map.isNotEmpty &&
          map.values.every((e) => e.get(_kTypeKey, "").startsWith(type))) {
        final res = <String, DocumentReference<DynamicMap>>{};
        for (final entry in map.entries) {
          final ref = ModelRefBase.fromJson(entry.value);
          res[entry.key] =
              adapter.database.doc(adapter._path(ref.modelQuery.path));
        }
        return {
          key: res,
        };
      }
    }
    return null;
  }

  @override
  Object? convertQueryValue(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return adapter.database.doc(
      adapter._path((value as ModelRefBase).modelQuery.path),
    );
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return value is ModelRefBase;
  }
}
