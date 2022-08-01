part of model_notifier;

class ApiDynamicCollectionModel extends ApiCollectionModel<DynamicMap> {
  ApiDynamicCollectionModel(
    String endpoint, {
    List<MapModel<dynamic>>? initialValue,
    Map<String, String> headers = const {},
  }) : super(
          endpoint,
          headers: headers,
          initialValue: initialValue ?? [],
        );

  @override
  List<DynamicMap> fromCollection(List<Object> list) => list.cast<DynamicMap>();

  @override
  List<Object> toCollection(List<DynamicMap> list) => list.cast<Object>();

  @override
  DynamicMap createDocument([Object? id]) => {};
}
