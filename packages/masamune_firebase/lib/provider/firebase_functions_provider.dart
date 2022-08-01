part of masamune_firebase;

/// Class for handling the response from Functions as a value.
///
/// It is possible to specify the [endpoint] of Functions as an argument.
final functionsProvider =
    ChangeNotifierProvider.family<FirebaseFunctionsDynamicModel, String>(
  (_, endpoint) => FirebaseFunctionsDynamicModel(endpoint),
);

/// Class for retrieving value data of [dynamic] through Functions.
class FirebaseFunctionsDynamicModel extends FirebaseFunctionsModel<dynamic> {
  /// Class for retrieving value data of [dynamic] through Functions.
  FirebaseFunctionsDynamicModel(String endpoint, [dynamic initialValue])
      : super(endpoint, initialValue);

  /// If this value is true,
  /// the change will be notified when [value] itself is changed.
  @override
  @protected
  bool get notifyOnChangeValue => false;

  /// You can describe the process of converting the response [dynamic] data to [T] data.
  @override
  dynamic fromResponse(dynamic value) {
    return value;
  }
}
