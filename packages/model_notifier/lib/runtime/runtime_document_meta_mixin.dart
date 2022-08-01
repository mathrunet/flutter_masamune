part of model_notifier;

/// Mix-in that completes the document metadata (time, UID, etc.) on Save.
///
/// You can save the metadata just by including this mix-in.
mixin RuntimeDocumentMetaMixin<T> on RuntimeDocumentModel<T> {
  @override
  @protected
  @mustCallSuper
  DynamicMap filterOnSave(DynamicMap save) {
    save[timeValueKey] = DateTime.now().millisecondsSinceEpoch;
    save[uidValueKey] = path.split("/").last;
    final language = Localize.language;
    if (language.isNotEmpty) {
      save[localeValueKey] = language;
    }
    return super.filterOnSave(save);
  }
}
