part of masamune_notion;

@immutable
class NotionProperty
    with MapMixin<String, dynamic>
    implements Map<String, dynamic> {
  const NotionProperty(this.value);
  final DynamicMap value;

  String get id => value.get(Const.uid, "");
  String get name => value.get(Const.name, "");
  String get type => value.get(Const.type, "");
  String get text => value.get(Const.text, "");
  dynamic get rawData => value["raw"];

  @override
  dynamic operator [](Object? key) => value[key];

  @override
  void operator []=(String key, dynamic value) => this.value[key] = value;

  @override
  void clear() {
    value.clear();
  }

  @override
  Iterable<String> get keys => value.keys;

  @override
  dynamic remove(Object? key) => value.remove(key);

  static DynamicMap? fromMapEntry(String key, dynamic value) {
    if (key.isEmpty || value is! DynamicMap) {
      return null;
    }
    final id = value.get(Const.id, "");
    final type = value.get(Const.type, "");
    if (id.isEmpty || type.isEmpty) {
      return null;
    }
    switch (type) {
      case "title":
        final title = value.getAsList<DynamicMap>("title");
        return <String, dynamic>{
          Const.uid: id,
          Const.type: type,
          Const.name: key,
          "raw": title,
          Const.text: title.fold(
            "",
            (previousValue, element) =>
                "$previousValue${element.get("plain_text", "")}",
          ),
        };
      case "people":
        final people = value.getAsList<DynamicMap>("people");
        final person = people.firstOrNull;
        return <String, dynamic>{
          Const.uid: id,
          Const.type: type,
          Const.name: key,
          "raw": people,
          if (person != null) ...{
            Const.text: person.get(Const.name, ""),
            Const.icon: person.get("avatar_url", ""),
          }
        };
      case "rich_text":
        final text = value.getAsList<DynamicMap>("rich_text");
        return <String, dynamic>{
          Const.uid: id,
          Const.type: type,
          Const.name: key,
          "raw": text,
          Const.text: text.fold(
            "",
            (previousValue, element) =>
                "$previousValue${element.get("plain_text", "")}",
          ),
        };
      case "checkbox":
        return <String, dynamic>{
          Const.uid: id,
          Const.type: type,
          Const.name: key,
          "raw": value.get("checkbox", false),
          Const.text: value.get("checkbox", false).toString(),
        };
      case "created_time":
        final dateTime = DateTime.tryParse(value.get("created_time", ""));
        if (dateTime == null) {
          return null;
        }
        return <String, dynamic>{
          Const.uid: id,
          Const.type: type,
          Const.name: key,
          "raw": dateTime.millisecondsSinceEpoch,
          Const.text: dateTime.toIso8601String(),
        };
      case "select":
        final select = value.getAsMap("select");
        return <String, dynamic>{
          Const.uid: id,
          Const.type: type,
          Const.name: key,
          "raw": select,
          Const.text: select.get(Const.name, ""),
          "color": select.get("color", ""),
        };
      case "multi_select":
        final selects = value.getAsList<DynamicMap>("multi_select");
        return <String, dynamic>{
          Const.uid: id,
          Const.type: type,
          Const.name: key,
          "raw": selects,
          "select": selects
            ..mapAndRemoveEmpty((e) {
              return <String, dynamic>{
                Const.uid: e.get("id", ""),
                Const.name: e.get("name", ""),
                "color": e.get("color", ""),
              };
            }),
        };
      case "relation":
        final relation = value.getAsList<DynamicMap>("relation");
        return <String, dynamic>{
          Const.uid: id,
          Const.type: type,
          Const.name: key,
          "raw": relation,
          "relation": relation.mapAndRemoveEmpty((e) {
            return e.get("id", "").replaceAll("-", "");
          }),
        };
      case "rollup":
        final rollup = value.getAsMap("rollup");
        final rollupType = rollup.get("type", "");
        switch (rollupType) {
          case "array":
            final array = rollup.getAsList<DynamicMap>("array");
            return <String, dynamic>{
              Const.uid: id,
              Const.type: type,
              Const.name: key,
              "raw": rollup,
              "array": array.mapAndRemoveEmpty((e) {
                final type = e.get("type", "");
                final select = e.getAsMap("select");
                switch (type) {
                  case "select":
                    return <String, dynamic>{
                      Const.uid: select.get("id", ""),
                      Const.type: type,
                      Const.name: select.get("name", ""),
                      "color": select.get("color", ""),
                    };
                }
              }),
            };
        }
    }
    return null;
  }

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => id.hashCode;

  /// A string representation of this object.
  ///
  /// Some classes have a default textual representation,
  /// often paired with a static parse function (like [int.parse]).
  /// These classes will provide the textual representation as their string represetion.
  ///
  /// Other classes have no meaningful textual representation that a program will care about.
  /// Such classes will typically override toString to provide useful information when inspecting the object, mainly for debugging or logging.
  @override
  String toString() => "NotionProperty: $name($id) => $text";
}
