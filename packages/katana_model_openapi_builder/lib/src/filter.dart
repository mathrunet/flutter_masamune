part of katana_model_openapi_builder;

DynamicMap _filter(String? parentKey, DynamicMap map) {
  final res = <String, dynamic>{};
  for (final tmp in map.entries) {
    final key = tmp.key;
    final val = tmp.value;
    switch (key) {
      case "example":
        continue;
      case "security":
      case "schemes":
        if (parentKey == null) {
          res[key] = <Map<String, List<String?>?>>[];
        } else {
          continue;
        }
        break;
      case "produces":
      case "parameters":
        if (val is! List) {
          res[key] = [val];
        } else {
          res[key] = val;
        }
        break;
      case "required":
        if (val is! List) {
          res[key] = [val.toString()];
        } else {
          res[key] = val;
        }
        break;
      case "type":
        if (val.toString().startsWith("number")) {
          res[key] = "number";
        } else {
          res[key] = val;
        }
        break;
      default:
        if (val is DynamicMap) {
          if (val.isEmpty) {
            continue;
          }
          final map = _filter(key, val);
          if (map.isEmpty) {
            continue;
          }
          res[key] = map;
        } else if (val is DynamicList) {
          if (val.isEmpty) {
            continue;
          }
          final list = val.map((e) {
            if (e is DynamicMap) {
              final map = _filter(key, e);
              if (map.isEmpty) {
                return null;
              }
              return map;
            } else {
              return e;
            }
          }).removeEmpty();
          if (list.isEmpty) {
            continue;
          }
          res[key] = list;
        } else {
          res[key] = val;
        }
        break;
    }
  }
  if (parentKey == null && !res.containsKey("security")) {
    res["security"] = <Map<String, List<String?>?>>[];
  }
  return res;
}

APIDocument _additionalDefinitions(APIDocument api) {
  final definitions = api.definitions;
  if (definitions == null) {
    return api;
  }
  final res = <String, APISchemaObject?>{};
  for (final entry in definitions.entries) {
    for (final property in (entry.value?.properties ?? {}).entries) {
      if (property.value?.referenceURI == null) {
        final url = "${entry.key.toPascalCase()}${property.key.toPascalCase()}";
        if (property.value?.type == APIType.object) {
          res["${entry.key.toPascalCase()}${property.key.toPascalCase()}"] =
              property.value;
          property.value?.referenceURI = Uri.parse("#/definitions/$url");
        } else if (property.value?.type == APIType.array &&
            property.value?.items?.type == APIType.object) {
          res["${entry.key.toPascalCase()}${property.key.toPascalCase()}"] =
              property.value?.items;
          property.value?.items?.referenceURI = Uri.parse("#/definitions/$url");
        }
      }
    }
  }
  for (final tmp in res.entries) {
    if (definitions.containsKey(tmp.key)) {
      continue;
    }
    definitions[tmp.key] = tmp.value;
  }
  return api;
}
