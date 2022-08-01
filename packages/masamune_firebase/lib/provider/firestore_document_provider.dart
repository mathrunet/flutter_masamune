part of masamune_firebase;

/// Base class for holding and manipulating data from a firestore database as a document of [T].
///
/// The [load()] method retrieves the value from the local database and
/// the [save()] method saves the value to the local database.
///
/// You can monitor for real-time updates by running [listen()].
///
/// In addition, since it can be used as [Map],
/// it is possible to operate the content as it is.
final firestoreDocumentProvider =
    ChangeNotifierProvider.family<FirestoreDynamicDocumentModel, String>(
  (_, path) => FirestoreDynamicDocumentModel(path),
);

/// Base class for holding and manipulating data from a firestore database as a document of [T].
///
/// The [load()] method retrieves the value from the local database and
/// the [save()] method saves the value to the local database.
///
/// You can monitor for real-time updates by running [listen()].
///
/// In addition, since it can be used as [Map],
/// it is possible to operate the content as it is.
final firestoreDocumentDisposableProvider = ChangeNotifierProvider.autoDispose
    .family<FirestoreDynamicDocumentModel, String>(
  (_, path) => FirestoreDynamicDocumentModel(path),
);

// /// Specify the path and use [DynamicMap] to
// /// hold the data [FirestoreDocumentModel].
// ///
// /// You don't need to define a class to hold data strictly,
// /// so you can develop quickly, but it lacks stability.
// class FirestoreDynamicDocumentModel extends FirestoreDocumentModel<DynamicMap>
//     with MapModelMixin<String, dynamic>, FirestoreDocumentMetaMixin<DynamicMap>
//     implements DynamicDocumentModel {
//   /// Specify the path and use [DynamicMap] to
//   /// hold the data [FirestoreDocumentModel].
//   ///
//   /// You don't need to define a class to hold data strictly,
//   /// so you can develop quickly, but it lacks stability.
//   FirestoreDynamicDocumentModel(String path, [DynamicMap? map])
//       : assert(
//           !(path.splitLength() <= 0 || path.splitLength() % 2 != 0),
//           "The path hierarchy must be an even number: $path",
//         ),
//         super(path, map ?? {});

//   /// If this value is true,
//   /// Notify changes when there are changes in the map itself using map-specific methods.
//   @override
//   @protected
//   bool get notifyOnChangeMap => false;

//   /// Creates a specific object from a given [map].
//   ///
//   /// This is used to convert the loaded data into an object for internal management.
//   @override
//   DynamicMap fromMap(DynamicMap map) => map.cast<String, dynamic>();

//   /// Creates a [DynamicMap] from its own [value].
//   ///
//   /// It is used for storing data.
//   @override
//   DynamicMap toMap(DynamicMap value) => value.cast<String, Object>();
// }
