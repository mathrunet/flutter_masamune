part of flutter_runtime_database;

/// Path list events.
///
/// Called when [load] or [unload].
typedef BuildEvent = void Function(BuildContext context);

/// Event for performing verification.
///
/// Called when [validateOnLoad] or [validateOnPostload].
typedef ValidateEvent = String Function(BuildContext context);

/// Action events.
///
/// Function without arguments or return location.
typedef VoidAction = void Function();

/// Action events.
///
/// [IDataField] can be specified as an argument.
typedef FieldAction = void Function(IDataField field);

/// Action events.
///
/// [IDataDocument] can be specified as an argument.
typedef DocumentAction = void Function(IDataDocument document);

/// Action events.
///
/// [IDataCollection] can be specified as an argument.
typedef CollectionAction = void Function(IDataCollection collection);
