part of model_notifier;

extension ListenableListExtensions<T extends Listenable> on Iterable<T> {
  /// Convert the list of [Listenable] to the list of widgets.
  ///
  /// It not only converts,
  /// but also listens for changes in each item and rebuilds only that part of the item if there are changes in each item.
  ///
  /// Easily create high performance lists.
  ///
  /// [callback] with the content of the widget.
  List<Widget> mapListenable(Widget? Function(T item) callback) {
    return map((item) {
      return ListenableListener<T>(
        listenable: item,
        builder: (context, listenable) =>
            callback.call(listenable) ?? const SizedBox(),
      );
    }).toList();
  }

  /// The data in the list of [others] is conditionally given to the current list.
  ///
  /// If [test] is `true`, [apply] will be executed.
  ///
  /// Otherwise, [orElse] will be executed.
  Iterable<K> setWhereListenable<K extends Listenable>(
    Iterable<T> others, {
    required bool Function(T original, T other) test,
    required K? Function(T original, T other) apply,
    K? Function(T original)? orElse,
  }) {
    final tmp = <K>[];
    for (final original in this) {
      final res = others.firstWhereOrNull((item) => test.call(original, item));
      if (res != null) {
        final applied = apply.call(original, res);
        if (applied != null) {
          tmp.add(applied);
        }
      } else {
        final applied = orElse?.call(original);
        if (applied != null) {
          tmp.add(applied);
        }
      }
    }
    return tmp;
  }
}

extension ListenableMapExtensions<K, V> on ValueListenable<Map<K, V>> {
  /// Merges the map in [others] with the current map.
  ///
  /// If the same key is found, the value of [others] has priority.
  ListenableMap<K, V> mergeListenable(
    ValueListenable<Map<K, V>> others, {
    K Function(K key)? convertKeys,
    V Function(V value)? convertValues,
  }) {
    final filter = (Map<K, V> origin) {
      final res = <K, V>{};
      for (final tmp in value.entries) {
        res[tmp.key] = tmp.value;
      }
      for (final tmp in others.value.entries) {
        final key = convertKeys?.call(tmp.key) ?? tmp.key;
        final value = convertValues?.call(tmp.value) ?? tmp.value;
        res[key] = value;
      }
      return res;
    };
    return ListenableMap<K, V>.from(filter(const {}))
      ..dependOn(this, filter)
      ..dependOn(others, filter);
  }
}

extension MasamuneDynamicMapExtensions on DynamicMap {
  /// Get the uid.
  ///
  /// Same process as below.
  /// ```
  /// this.get(Const.uid, "");
  /// ```
  String get uid {
    return this.get(Const.uid, "");
  }

  /// Get the time.
  ///
  /// Same process as below.
  /// ```
  /// this.get(Const.time, DateTime.now().millisecondsSinceEpoch);
  /// ```
  int get time {
    return this.get(Const.time, DateTime.now().millisecondsSinceEpoch);
  }

  /// Get the locale.
  ///
  /// Same process as below.
  /// ```
  /// this.get(MetaConst.locale, Localize.locale);
  /// ```
  String get locale {
    return this.get(MetaConst.locale, Localize.locale);
  }
}

extension GeoMapExtensions<K, V> on Map<K, V> {
  /// Get the geo data corresponding to [key] in the map.
  ///
  /// If [key] is not found, the geo data of [orElse] is returned.
  GeoData getAsGeoData(K key, [GeoData? orElse]) {
    assert(key != null, "The key is empty.");
    if (!containsKey(key)) {
      return orElse ?? const GeoData();
    }
    return (this[key] as GeoData?) ?? orElse ?? const GeoData();
  }
}

extension NullableGeoMapExtensions<K, V> on Map<K, V>? {
  /// Get the geo data corresponding to [key] in the map.
  ///
  /// If [key] is not found, the geo data of [orElse] is returned.
  GeoData getAsGeoData(K key, [GeoData? orElse]) {
    assert(key != null, "The key is empty.");
    if (this == null || !containsKey(key)) {
      return orElse ?? const GeoData();
    }
    return (this![key] as GeoData?) ?? orElse ?? const GeoData();
  }
}

extension DynamicDocumentModelExtensions on DynamicDocumentModel {
  /// Get the translated data stored in [key].
  ///
  /// If there is no data in [key], it is replaced by the data in [orElse].
  ///
  /// Specify the language in [locale].
  ///
  /// [localizationValueKey] is the suffix of the data that contains the translated map.
  String localized(
    String key,
    String orElse, {
    String? locale,
    String localizationValueKey = MetaConst.translate,
  }) {
    locale ??= Localize.language;
    final map = this.get(
      "$key$localizationValueKey",
      const <String, dynamic>{},
    );
    if (map.isEmpty) {
      return this.get(key, orElse);
    }
    return map.get(
      locale,
      this.get(key, orElse),
    );
  }

  /// Generates a field divided by a bi-gram for searching.
  ///
  /// The [key] is the key to save the data for search.
  ///
  /// The original data to be split into bigrams is specified by [bigramKeys],
  /// and the data to be saved for tags is specified by [tagKeys].
  DynamicDocumentModel setSearchField({
    String key = MetaConst.search,
    List<String> bigramKeys = const [Const.name, Const.text],
    List<String> tagKeys = const [Const.tag, Const.category],
  }) {
    var tmp = "";
    for (final bigramKey in bigramKeys) {
      if (this[bigramKey] is! String) {
        continue;
      }
      tmp += this[bigramKey];
    }
    for (final tagKey in tagKeys) {
      final tags = this[tagKey];
      if (tags is! List) {
        continue;
      }
      for (final tag in tags) {
        tmp += tag.toString();
      }
    }
    final res = <String, bool>{};
    tmp = tmp.toLowerCase();
    final bigramList = tmp.splitByBigram();
    for (final bigram in bigramList) {
      res[bigram] = true;
    }
    final characterList = tmp.splitByCharacter();
    for (final character in characterList) {
      res[character] = true;
    }
    this[key] = res;
    return this;
  }

  /// Create a field for notification.
  ///
  /// [title] is the title of the push notification,
  /// [text] is the content of the push notification, and [time] is the date and time the push notification was sent.
  ///
  /// [timeKey], [titleKey], and [textKey] specify the respective keys.
  DynamicDocumentModel setNotificationField({
    required String title,
    required String text,
    required DateTime time,
    String timeKey = MetaConst.pushTime,
    String titleKey = MetaConst.pushName,
    String textKey = MetaConst.pushText,
  }) {
    assert(title.isNotEmpty, "The title is empty.");
    assert(text.isNotEmpty, "The text is empty.");
    assert(timeKey.isNotEmpty, "The time key is empty.");
    assert(titleKey.isNotEmpty, "The title key is empty.");
    assert(textKey.isNotEmpty, "The text key is empty.");
    this[timeKey] = time.millisecondsSinceEpoch;
    this[titleKey] = title;
    this[textKey] = text;
    return this;
  }

  /// Increments the value specified by [key] by [value].
  ///
  /// It is also possible to specify a minus value for [value].
  ///
  /// By specifying [intervals],
  /// it is possible to perform aggregation separated by periods.
  DynamicDocumentModel increment(
    String key,
    num value, {
    List<CounterUpdaterInterval> intervals = const [],
  }) {
    _buildCounterUpdate(
      map: this,
      key: key,
      value: value,
      counterIntervals: intervals,
    );
    return this;
  }

  /// Set a value to delete the [key] field.
  DynamicDocumentModel deleteField(String key) {
    this[key] = null;
    return this;
  }

  /// Set the timestamp to [key].
  DynamicDocumentModel timestamp(String key) {
    this[key] = DateTime.now().millisecondsSinceEpoch;
    return this;
  }
}
