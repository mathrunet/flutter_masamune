part of model_notifier;

/// Documentation model for flexibly modifying the contents of an object that is primarily a [DynamicMap].
abstract class DynamicDocumentModel
    implements
        ConvertibleValueModel<DynamicMap>,
        DynamicMap,
        ListenableDynamicMap,
        FutureModel<DynamicMap>,
        StoredDocumentModel<DynamicMap> {}
