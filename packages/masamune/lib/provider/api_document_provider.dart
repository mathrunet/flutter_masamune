part of masamune;

final apiDocumentProvider =
    ChangeNotifierProvider.family<ApiDynamicDocumentModel, String>(
  (_, endpoint) => ApiDynamicDocumentModel(endpoint),
);
