part of model_notifier;

class ApiDynamicDocumentModel extends ApiDocumentModel<DynamicMap>
    with MapModelMixin<String, dynamic> {
  ApiDynamicDocumentModel(
    String endpoint, {
    DynamicMap? initialValue,
    Map<String, String> headers = const {},
  }) : super(
          endpoint,
          initialValue ?? {},
          headers: headers,
        );

  @override
  @protected
  bool get notifyOnChangeMap => false;

  @override
  DynamicMap fromMap(DynamicMap map) => map.cast<String, dynamic>();

  @override
  DynamicMap toMap(DynamicMap value) => value.cast<String, Object>();
}
