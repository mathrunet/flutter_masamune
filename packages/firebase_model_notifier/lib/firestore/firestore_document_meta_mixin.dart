part of firebase_model_notifier;

/// A mix-in to save [uid], [time] and [locale] when saving Firestore documents.
mixin FirestoreDocumentMetaMixin<T> on FirestoreDocumentModel<T> {
  /// You can filter the saving content when it is saving.
  ///
  /// Edit the value of [save] and return.
  @override
  @protected
  @mustCallSuper
  DynamicMap filterOnSave(DynamicMap save) {
    save[timeValueKey] = FieldValue.serverTimestamp();
    save[uidValueKey] = reference.id;
    final language = Localize.language;
    if (language.isNotEmpty) {
      save[localeValueKey] = language;
    }
    return super.filterOnSave(save);
  }
}
