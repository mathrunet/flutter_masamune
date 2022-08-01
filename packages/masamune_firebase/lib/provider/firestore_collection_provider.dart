part of masamune_firebase;

/// Base class for holding and manipulating data from a firestore database as a collection of [FirestoreDocumentModel].
///
/// The [load()] method retrieves the value from the firestore database and
/// the [save()] method saves the value to the firestore database.
///
/// When [listen()] is executed,
/// changes in the number of elements in the Firestore collection are monitored and updated in real time.
///
/// Each document's change is notified only to the documents in it.
final firestoreCollectionProvider =
    ChangeNotifierProvider.family<FirestoreDynamicCollectionModel, String>(
  (_, path) => FirestoreDynamicCollectionModel(path),
);

/// Base class for holding and manipulating data from a firestore database as a collection of [FirestoreDocumentModel].
///
/// The [load()] method retrieves the value from the firestore database and
/// the [save()] method saves the value to the firestore database.
///
/// When [listen()] is executed,
/// changes in the number of elements in the Firestore collection are monitored and updated in real time.
///
/// Each document's change is notified only to the documents in it.
final firestoreCollectionDisposableProvider = ChangeNotifierProvider.autoDispose
    .family<FirestoreDynamicCollectionModel, String>(
  (_, path) => FirestoreDynamicCollectionModel(path),
);

// /// Specify the path and use [DynamicMap] to
// /// hold the data [FirestoreCollectionModel].
// ///
// /// You don't need to define a class to hold data strictly,
// /// so you can develop quickly, but it lacks stability.
// class FirestoreDynamicCollectionModel
//     extends FirestoreCollectionModel<FirestoreDynamicDocumentModel>
//     with FirestoreCollectionQueryMixin<FirestoreDynamicDocumentModel>
//     implements DynamicCollectionModel<FirestoreDynamicDocumentModel> {
//   /// Specify the path and use [DynamicMap] to
//   /// hold the data [FirestoreCollectionModel].
//   ///
//   /// You don't need to define a class to hold data strictly,
//   /// so you can develop quickly, but it lacks stability.
//   FirestoreDynamicCollectionModel(
//     String path, [
//     List<FirestoreDynamicDocumentModel>? value,
//   ])  : assert(
//           !(path.splitLength() <= 0 || path.splitLength() % 2 != 1),
//           "The path hierarchy must be an odd number: $path",
//         ),
//         super(path, value ?? []);

//   /// Add a process to create a document object.
//   @override
//   @protected
//   FirestoreDynamicDocumentModel createDocument(String path) =>
//       FirestoreDynamicDocumentModel(path);
// }
