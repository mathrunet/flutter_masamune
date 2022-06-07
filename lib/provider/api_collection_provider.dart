part of masamune;

final apiCollectionProvider =
    ChangeNotifierProvider.family<ApiDynamicCollectionModel, String>(
  (_, endpoint) => ApiDynamicCollectionModel(endpoint),
);
