// ignore_for_file: prefer_typing_uninitialized_variables

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:katana_model/katana_model.dart';

void main() {
  test("ModelQuery.hasMatch", () async {
    var query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.equal(key: "name", value: "test"),
      ],
    );
    expect(query.hasMatchAsObject("test"), true);
    expect(query.hasMatchAsMap({"name": "test", "text": "aaaa"}), true);
    expect(
      query.hasMatchAsList([
        {"name": "test", "text": "aaaa"},
        {"name": "test2", "text": "bbbb"}
      ]),
      true,
    );
    expect(query.hasMatchAsObject("test2"), false);
    expect(query.hasMatchAsMap({"name": "text", "text": "aaaa"}), false);
    expect(
      query.hasMatchAsList([
        {"name": "text", "text": "aaaa"},
        {"name": "test2", "text": "bbbb"}
      ]),
      false,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.notEqual(key: "name", value: "test"),
      ],
    );
    expect(query.hasMatchAsObject("test"), false);
    expect(query.hasMatchAsMap({"name": "test", "text": "aaaa"}), false);
    expect(
      query.hasMatchAsList([
        {"name": "test", "text": "aaaa"},
        {"name": "test2", "text": "bbbb"}
      ]),
      true,
    );
    expect(query.hasMatchAsObject("test2"), true);
    expect(query.hasMatchAsMap({"name": "text", "text": "aaaa"}), true);
    expect(
      query.hasMatchAsList([
        {"name": "text", "text": "aaaa"},
        {"name": "test2", "text": "bbbb"}
      ]),
      true,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.lessThan(key: "count", value: 100),
      ],
    );
    expect(query.hasMatchAsObject(99), true);
    expect(query.hasMatchAsObject(100), false);
    expect(query.hasMatchAsObject(101), false);
    expect(query.hasMatchAsMap({"count": 99, "text": "aaaa"}), true);
    expect(query.hasMatchAsMap({"count": 100, "text": "aaaa"}), false);
    expect(query.hasMatchAsMap({"count": 101, "text": "aaaa"}), false);
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.greaterThan(key: "count", value: 100),
      ],
    );
    expect(query.hasMatchAsObject(99), false);
    expect(query.hasMatchAsObject(100), false);
    expect(query.hasMatchAsObject(101), true);
    expect(query.hasMatchAsMap({"count": 99, "text": "aaaa"}), false);
    expect(query.hasMatchAsMap({"count": 100, "text": "aaaa"}), false);
    expect(query.hasMatchAsMap({"count": 101, "text": "aaaa"}), true);
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.lessThanOrEqual(key: "count", value: 100),
      ],
    );
    expect(query.hasMatchAsObject(99), true);
    expect(query.hasMatchAsObject(100), true);
    expect(query.hasMatchAsObject(101), false);
    expect(query.hasMatchAsMap({"count": 99, "text": "aaaa"}), true);
    expect(query.hasMatchAsMap({"count": 100, "text": "aaaa"}), true);
    expect(query.hasMatchAsMap({"count": 101, "text": "aaaa"}), false);
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.greaterThanOrEqual(key: "count", value: 100),
      ],
    );
    expect(query.hasMatchAsObject(99), false);
    expect(query.hasMatchAsObject(100), true);
    expect(query.hasMatchAsObject(101), true);
    expect(query.hasMatchAsMap({"count": 99, "text": "aaaa"}), false);
    expect(query.hasMatchAsMap({"count": 100, "text": "aaaa"}), true);
    expect(query.hasMatchAsMap({"count": 101, "text": "aaaa"}), true);
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.contains(key: "count", value: 1),
      ],
    );
    expect(query.hasMatchAsObject([0, 1, 2]), true);
    expect(query.hasMatchAsObject([100, 101, 102]), false);
    expect(
      query.hasMatchAsMap({
        "count": [0, 1, 2],
        "text": "aaaa"
      }),
      true,
    );
    expect(
      query.hasMatchAsMap({
        "count": [100, 101, 102],
        "text": "aaaa"
      }),
      false,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.containsAny(key: "count", values: [2, 3, 4]),
      ],
    );
    expect(query.hasMatchAsObject([0, 1, 2]), true);
    expect(query.hasMatchAsObject([2, 3, 4]), true);
    expect(query.hasMatchAsObject([100, 101, 102]), false);
    expect(
      query.hasMatchAsMap({
        "count": [0, 1, 2],
        "text": "aaaa"
      }),
      true,
    );
    expect(
      query.hasMatchAsMap({
        "count": [2, 3, 4],
        "text": "aaaa"
      }),
      true,
    );
    expect(
      query.hasMatchAsMap({
        "count": [100, 101, 102],
        "text": "aaaa"
      }),
      false,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.where(key: "count", values: [2, 3, 4]),
      ],
    );
    expect(query.hasMatchAsObject(1), false);
    expect(query.hasMatchAsObject(2), true);
    expect(query.hasMatchAsObject(3), true);
    expect(
      query.hasMatchAsMap({"count": 1, "text": "aaaa"}),
      false,
    );
    expect(
      query.hasMatchAsMap({"count": 2, "text": "aaaa"}),
      true,
    );
    expect(
      query.hasMatchAsMap({"count": 4, "text": "aaaa"}),
      true,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.notWhere(key: "count", values: [2, 3, 4]),
      ],
    );
    expect(query.hasMatchAsObject(1), true);
    expect(query.hasMatchAsObject(2), false);
    expect(query.hasMatchAsObject(3), false);
    expect(
      query.hasMatchAsMap({"count": 1, "text": "aaaa"}),
      true,
    );
    expect(
      query.hasMatchAsMap({"count": 2, "text": "aaaa"}),
      false,
    );
    expect(
      query.hasMatchAsMap({"count": 4, "text": "aaaa"}),
      false,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.isNull(key: "count"),
      ],
    );
    expect(query.hasMatchAsObject(1), false);
    expect(query.hasMatchAsObject(2), false);
    expect(query.hasMatchAsObject(null), true);
    expect(
      query.hasMatchAsMap({"count": 1, "text": "aaaa"}),
      false,
    );
    expect(
      query.hasMatchAsMap({"text": "aaaa"}),
      true,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.isNotNull(key: "count"),
      ],
    );
    expect(query.hasMatchAsObject(1), true);
    expect(query.hasMatchAsObject(2), true);
    expect(query.hasMatchAsObject(null), false);
    expect(
      query.hasMatchAsMap({"count": 1, "text": "aaaa"}),
      true,
    );
    expect(
      query.hasMatchAsMap({"text": "aaaa"}),
      false,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.equal(key: "text", value: "aaaa"),
        ModelQueryFilter.equal(key: "count", value: 5),
      ],
    );
    expect(query.hasMatchAsObject(5), false);
    expect(query.hasMatchAsObject("aaaa"), false);
    expect(query.hasMatchAsObject(4), false);
    expect(
      query.hasMatchAsMap({"count": 1, "text": "aaaa"}),
      false,
    );
    expect(
      query.hasMatchAsMap({"count": 2, "text": "aaaa"}),
      false,
    );
    expect(
      query.hasMatchAsMap({"count": 5, "text": "aaaa"}),
      true,
    );
    expect(
      query.hasMatchAsMap({"count": 5, "text": "bbbb"}),
      false,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.greaterThanOrEqual(key: "count", value: 5),
        ModelQueryFilter.lessThanOrEqual(key: "count", value: 10),
      ],
    );
    expect(query.hasMatchAsObject(4), false);
    expect(query.hasMatchAsObject(5), true);
    expect(query.hasMatchAsObject(8), true);
    expect(query.hasMatchAsObject(10), true);
    expect(query.hasMatchAsObject(11), false);
    expect(
      query.hasMatchAsMap({"count": 1, "text": "aaaa"}),
      false,
    );
    expect(
      query.hasMatchAsMap({"count": 2, "text": "aaaa"}),
      false,
    );
    expect(
      query.hasMatchAsMap({"count": 5, "text": "aaaa"}),
      true,
    );
    expect(
      query.hasMatchAsMap({"count": 11, "text": "bbbb"}),
      false,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.equal(key: "text", value: "aaaa"),
        ModelQueryFilter.contains(key: "count", value: 10),
      ],
    );
    expect(query.hasMatchAsObject([1, 3, 10]), false);
    expect(query.hasMatchAsObject("aaaa"), false);
    expect(query.hasMatchAsObject([1, 6, 8]), false);
    expect(query.hasMatchAsObject(10), false);
    expect(query.hasMatchAsObject("bbbb"), false);
    expect(
      query.hasMatchAsMap({
        "count": [1, 3, 5],
        "text": "aaaa"
      }),
      false,
    );
    expect(
      query.hasMatchAsMap({
        "count": [1, 3, 10],
        "text": "aaaa"
      }),
      true,
    );
    expect(
      query.hasMatchAsMap({
        "count": [1, 3, 10],
        "text": "bbbb"
      }),
      false,
    );
  });
  test("ModelQuery.sort", () async {
    var query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.orderByAsc(key: "count"),
      ],
    );
    expect(
      query.sort(
        const [
          MapEntry("dddd", {"count": 10, "text": "a"}),
          MapEntry("dddd", {"count": 4, "text": "a"}),
          MapEntry("dddd", {"count": 8, "text": "a"}),
          MapEntry("dddd", {"count": 1, "text": "a"}),
        ],
      ).toString(),
      const [
        MapEntry("dddd", {"count": 1, "text": "a"}),
        MapEntry("dddd", {"count": 4, "text": "a"}),
        MapEntry("dddd", {"count": 8, "text": "a"}),
        MapEntry("dddd", {"count": 10, "text": "a"}),
      ].toString(),
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.orderByDesc(key: "count"),
      ],
    );
    expect(
      query.sort(
        const [
          MapEntry("dddd", {"count": 10, "text": "a"}),
          MapEntry("dddd", {"count": 4, "text": "a"}),
          MapEntry("dddd", {"count": 8, "text": "a"}),
          MapEntry("dddd", {"count": 1, "text": "a"}),
        ],
      ).toString(),
      const [
        MapEntry("dddd", {"count": 10, "text": "a"}),
        MapEntry("dddd", {"count": 8, "text": "a"}),
        MapEntry("dddd", {"count": 4, "text": "a"}),
        MapEntry("dddd", {"count": 1, "text": "a"}),
      ].toString(),
    );
  });
  test("ModelQuery.seekIndex", () async {
    var query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.orderByAsc(key: "count"),
      ],
    );
    expect(
      query.seekIndex(
        query.sort(
          const [
            MapEntry("dddd", {"count": 10, "text": "a"}),
            MapEntry("dddd", {"count": 4, "text": "a"}),
            MapEntry("dddd", {"count": 8, "text": "a"}),
            MapEntry("dddd", {"count": 1, "text": "a"}),
          ],
        ),
        {"count": 5, "text": "a"},
      ),
      2,
    );
    expect(
      query.seekIndex(
        query.sort(
          const [
            MapEntry("dddd", {"count": 10, "text": "a"}),
            MapEntry("dddd", {"count": 4, "text": "a"}),
            MapEntry("dddd", {"count": 8, "text": "a"}),
            MapEntry("dddd", {"count": 1, "text": "a"}),
          ],
        ),
        {"count": 15, "text": "a"},
      ),
      4,
    );
    expect(
      query.seekIndex(
        query.sort(
          const [
            MapEntry("dddd", {"count": 10, "text": "a"}),
            MapEntry("dddd", {"count": 4, "text": "a"}),
            MapEntry("dddd", {"count": 8, "text": "a"}),
            MapEntry("dddd", {"count": 1, "text": "a"}),
          ],
        ),
        {"count": 0, "text": "a"},
      ),
      0,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.orderByDesc(key: "count"),
      ],
    );
    expect(
      query.seekIndex(
        query.sort(
          const [
            MapEntry("dddd", {"count": 10, "text": "a"}),
            MapEntry("dddd", {"count": 4, "text": "a"}),
            MapEntry("dddd", {"count": 8, "text": "a"}),
            MapEntry("dddd", {"count": 1, "text": "a"}),
          ],
        ),
        {"count": 5, "text": "a"},
      ),
      2,
    );
    expect(
      query.seekIndex(
        query.sort(
          const [
            MapEntry("dddd", {"count": 10, "text": "a"}),
            MapEntry("dddd", {"count": 4, "text": "a"}),
            MapEntry("dddd", {"count": 8, "text": "a"}),
            MapEntry("dddd", {"count": 1, "text": "a"}),
          ],
        ),
        {"count": 15, "text": "a"},
      ),
      0,
    );
    expect(
      query.seekIndex(
        query.sort(
          const [
            MapEntry("dddd", {"count": 10, "text": "a"}),
            MapEntry("dddd", {"count": 4, "text": "a"}),
            MapEntry("dddd", {"count": 8, "text": "a"}),
            MapEntry("dddd", {"count": 1, "text": "a"}),
          ],
        ),
        {"count": 0, "text": "a"},
      ),
      4,
    );
  });
  test("ModelQuery.search", () async {
    var query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.like(key: kDefaultSearchableFieldKey, text: "mas"),
      ],
    );
    expect(
      query.hasMatchAsObject({
        "ma": true,
        "as": true,
        "sa": true,
        "am": true,
        "mu": true,
        "un": true,
        "ne": true,
      }),
      true,
    );
    expect(
      query.hasMatchAsMap({
        kDefaultSearchableFieldKey: {
          "ma": true,
          "as": true,
          "sa": true,
          "am": true,
          "mu": true,
          "un": true,
          "ne": true,
        },
      }),
      true,
    );
    query = const ModelQuery(
      "aaaa/bbbb",
      filters: [
        ModelQueryFilter.like(key: kDefaultSearchableFieldKey, text: "oooo"),
      ],
    );
    expect(
      query.hasMatchAsObject({
        "ma": true,
        "as": true,
        "sa": true,
        "am": true,
        "mu": true,
        "un": true,
        "ne": true,
      }),
      false,
    );
    expect(
      query.hasMatchAsMap({
        kDefaultSearchableFieldKey: {
          "ma": true,
          "as": true,
          "sa": true,
          "am": true,
          "mu": true,
          "un": true,
          "ne": true,
        },
      }),
      false,
    );
  });
}
