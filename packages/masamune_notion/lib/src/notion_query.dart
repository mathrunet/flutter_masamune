// ignore_for_file: use_late_for_private_fields_and_variables

part of masamune_notion;

@immutable
class NotionQuery extends ModelQuery {
  const NotionQuery({
    String? databaseId,
    this.type = NotionQueryType.text,
    String? key,
    String? orderBy,
    dynamic isEqualTo,
    dynamic isNotEqualTo,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    DynamicList? arrayContainsAny,
    DynamicList? whereIn,
    DynamicList? whereNotIn,
    ModelQueryOrder order = ModelQueryOrder.asc,
    int? limit,
  }) : super(
          databaseId ?? "",
          key: key,
          orderBy: orderBy,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          whereNotIn: whereNotIn,
          order: order,
          limit: limit,
        );

  factory NotionQuery.fromPath(String path) {
    if (path.isEmpty) {
      return NotionQuery(databaseId: path);
    }
    final uri = Uri.tryParse(path);
    if (uri == null) {
      return NotionQuery(databaseId: path);
    }
    final query = uri.queryParameters;

    return NotionQuery(
      databaseId: uri.path,
      key: _parseQuery(query, "key"),
      type: _parseQuery(query, "type").toString().toNotionQueryType(),
      isEqualTo: _parseQuery(query, "equalTo"),
      isNotEqualTo: _parseQuery(query, "notEqualTo"),
      isLessThanOrEqualTo: _parseQuery(query, "endAt"),
      isGreaterThanOrEqualTo: _parseQuery(query, "startAt"),
      arrayContains: _parseQuery(query, "contains"),
      arrayContainsAny: _parseQuery(query, "containsAny", true),
      whereIn: _parseQuery(query, "whereIn", true),
      whereNotIn: _parseQuery(query, "whereNotIn", true),
      orderBy: () {
        if (query.containsKey("orderByDesc")) {
          return query["orderByDesc"];
        } else if (query.containsKey("orderByAsc")) {
          return query["orderByAsc"];
        }
      }(),
      order: () {
        if (query.containsKey("orderByDesc")) {
          return ModelQueryOrder.desc;
        } else {
          return ModelQueryOrder.asc;
        }
      }(),
      limit: _parseQuery(query, "limitToFirst"),
    );
  }

  static dynamic _parseQuery(
    Map<String, String> query,
    String key, [
    bool isArray = false,
  ]) {
    if (!query.containsKey(key)) {
      return null;
    }
    final value = query[key];
    if (value.isEmpty) {
      return null;
    }
    if (isArray) {
      return value!.split(",").mapAndRemoveEmpty((item) => item.toAny());
    }
    return value.toAny();
  }

  final NotionQueryType type;

  @override
  String get value {
    final path = super.value;
    if (path.contains("?")) {
      return "$path&type=${type.name}";
    } else {
      return "$path?type=${type.name}";
    }
  }

  DynamicMap? toFilter() {
    if (key.isEmpty) {
      return null;
    }
    switch (type) {
      case NotionQueryType.select:
        return <String, dynamic>{
          "property": key,
          "select": {
            if (isEqualTo is String && isEqualTo.isNotEmpty)
              "equals": isEqualTo
            else if (isNotEqualTo is String && isNotEqualTo.isNotEmpty)
              "does_not_equal": isNotEqualTo
            else
              "is_not_empty": true,
          },
        };
      case NotionQueryType.multiSelect:
        return <String, dynamic>{
          "property": key,
          "multi_select": {
            if (arrayContains is String && arrayContains.isNotEmpty)
              "contains": arrayContains
            else
              "is_not_empty": true,
          },
        };
      case NotionQueryType.date:
        return <String, dynamic>{
          "property": key,
          "date": {
            if (isEqualTo is String && isEqualTo.isNotEmpty)
              "equals": isEqualTo
            else if (isGreaterThanOrEqualTo is String &&
                isGreaterThanOrEqualTo.isNotEmpty)
              "on_or_after": isGreaterThanOrEqualTo
            else if (isGreaterThanOrEqualTo is String &&
                isGreaterThanOrEqualTo.isNotEmpty)
              "on_or_before": isLessThanOrEqualTo
            else
              "is_not_empty": true,
          },
        };
      case NotionQueryType.people:
        return <String, dynamic>{
          "property": key,
          "multi_select": {
            if (arrayContains is String && arrayContains.isNotEmpty)
              "contains": arrayContains
            else
              "is_not_empty": true,
          },
        };
      default:
        if (isEqualTo is String ||
            isNotEqualTo is String ||
            arrayContains is String) {
          return <String, dynamic>{
            "property": key,
            "text": {
              if (isEqualTo.isNotEmpty)
                "equals": isEqualTo
              else if (isNotEqualTo.isNotEmpty)
                "does_not_equal": isNotEqualTo
              else if (arrayContains.isNotEmpty)
                "contains": arrayContains
              else
                "is_not_empty": true,
            },
          };
        } else if (isEqualTo is num ||
            isNotEqualTo is num ||
            isGreaterThanOrEqualTo is num ||
            isLessThanOrEqualTo is num) {
          return <String, dynamic>{
            "property": key,
            "number": {
              if (isEqualTo != null)
                "equals": isEqualTo
              else if (isNotEqualTo != null)
                "does_not_equal": isNotEqualTo
              else if (isGreaterThanOrEqualTo != null)
                "greater_than_or_equal_to": isGreaterThanOrEqualTo
              else if (isLessThanOrEqualTo != null)
                "less_than_or_equal_to": isLessThanOrEqualTo
              else
                "is_not_empty": true,
            },
          };
        } else if (isEqualTo is bool || isNotEqualTo is bool) {
          return <String, dynamic>{
            "property": key,
            "checkbox": {
              if (isEqualTo != null)
                "equals": isEqualTo
              else if (isNotEqualTo != null)
                "does_not_equal": isNotEqualTo
              else
                "equals": false,
            },
          };
        } else {
          return null;
        }
    }
  }
}

@immutable
class NotionQueryGroup extends NotionQuery {
  const NotionQueryGroup(
    this.group, [
    this.groupType = NotionQueryGroupType.and,
  ]);

  final List<NotionQuery> group;
  final NotionQueryGroupType groupType;

  @override
  String get value {
    return group.fold(
      "",
      (previousValue, element) => previousValue + element.value,
    );
  }

  @override
  String get path {
    return group.fold(
      "",
      (previousValue, element) => previousValue + element.path,
    );
  }

  @override
  DynamicMap? toFilter() {
    final groups = group.mapAndRemoveEmpty((e) => e.toFilter());
    if (groups.isEmpty) {
      return null;
    }
    return <String, dynamic>{
      groupType.name: groups,
    };
  }
}

enum NotionQueryType {
  text,
  select,
  multiSelect,
  date,
  people,
}

enum NotionQueryGroupType {
  and,
  or,
}

extension _NotionQueryTypeStringExtensions on String? {
  NotionQueryType toNotionQueryType() {
    for (final type in NotionQueryType.values) {
      if (type.name == this) {
        return type;
      }
    }
    return NotionQueryType.text;
  }
}
