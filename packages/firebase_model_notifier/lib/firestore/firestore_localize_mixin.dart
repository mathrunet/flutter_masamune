part of firebase_model_notifier;

/// A mixin to use Firestore's localization features.
///
/// Need to deploy Localize function to Functions
mixin FirestoreLocalizeMixin<T> on FirestoreDocumentModel<T> {
  /// Suffix to perform the translation.
  String get localizationValueKey => MetaConst.translate;

  /// Key to perform the translation.
  List<String> get localizationKeys;

  /// You can filter the loaded content when it is loaded.
  ///
  /// Edit the value of [loaded] and return.
  @override
  @protected
  @mustCallSuper
  DynamicMap filterOnLoad(DynamicMap loaded) {
    for (final key in localizationKeys) {
      final language = Localize.language;
      assert(
        language.isNotEmpty,
        "The locale is not set. Run [Localize.initialize()] to initialize the translation.",
      );
      final localizations =
          loaded.get<DynamicMap>("$key$localizationValueKey", {});
      loaded[key] = localizations.get(language, loaded.get<String>(key, ""));
    }
    return super.filterOnLoad(loaded);
  }

  /// You can filter the saving content when it is saving.
  ///
  /// Edit the value of [save] and return.
  @override
  @protected
  @mustCallSuper
  DynamicMap filterOnSave(DynamicMap save) {
    final language = Localize.language;
    assert(
      language.isNotEmpty,
      "The locale is not set. Run [Localize.initialize()] to initialize the translation.",
    );
    save[localeValueKey] = language;
    return super.filterOnSave(save);
  }
}
