part of model_notifier;

/// Collection model for flexibly modifying the contents of an object that is primarily a [DynamicMap].
abstract class DynamicCollectionModel<T extends DynamicDocumentModel>
    implements
        ListModel<T>,
        List<T>,
        ListenableList<T>,
        FutureModel<List<T>>,
        StoredCollectionModel<T> {}
