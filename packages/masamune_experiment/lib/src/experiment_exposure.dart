part of "/masamune_experiment.dart";

/// Settings for recording which branch of [Experiment.run] the user was exposed to.
///
/// When passed to [Experiment.run], an [ExperimentLoggerEvent.exposure] event is sent to the [LoggerAdapter]s
/// with the value `<experimentId>:<label>` of the selected [ExperimentCase].
/// `masamune_logger_firebase` stores it as the Firebase Analytics user property [userProperty].
///
/// [userProperty] must start with a letter, contain only letters, digits and underscores,
/// be at most 24 characters and must not start with `firebase_`, `google_` or `ga_`.
///
/// `<experimentId>:<label>` must be at most 36 characters.
///
/// ```dart
/// experiment.run(
///   (config) => config.getString("new_button"),
///   cases,
///   exposure: const ExperimentExposure(
///     userProperty: "ab_slot_1",
///     experimentId: "F-20261107-01",
///   ),
/// );
/// ```
@immutable
class ExperimentExposure {
  /// Settings for recording which branch of [Experiment.run] the user was exposed to.
  ///
  /// [userProperty] must start with a letter, contain only letters, digits and underscores,
  /// be at most 24 characters and must not start with `firebase_`, `google_` or `ga_`.
  ///
  /// `<experimentId>:<label>` must be at most 36 characters.
  const ExperimentExposure({
    required this.userProperty,
    required this.experimentId,
  })  : assert(
          userProperty.length > 0 &&
              userProperty.length <= maxUserPropertyLength,
          "The userProperty must be 1-24 characters.",
        ),
        assert(
          experimentId.length > 0,
          "The experimentId must not be empty.",
        );

  /// Maximum length of [userProperty].
  static const int maxUserPropertyLength = 24;

  /// Maximum length of [valueOf].
  static const int maxValueLength = 36;

  static final RegExp _userPropertyPattern = RegExp(r"^[A-Za-z][A-Za-z0-9_]*$");

  /// Name of the user property that stores the exposed branch.
  final String userProperty;

  /// ID of the experiment. It is used as the prefix of the user property value.
  final String experimentId;

  /// Returns the user property value for [label]: `<experimentId>:<label>`.
  String valueOf(String label) => "$experimentId:$label";

  /// Returns `true` if [userProperty] is a valid user property name.
  bool get isValidUserProperty {
    return userProperty.length <= maxUserPropertyLength &&
        _userPropertyPattern.hasMatch(userProperty) &&
        !userProperty.startsWith("firebase_") &&
        !userProperty.startsWith("google_") &&
        !userProperty.startsWith("ga_");
  }

  @override
  String toString() => "ExperimentExposure($userProperty, $experimentId)";

  @override
  int get hashCode => Object.hash(userProperty, experimentId);

  @override
  bool operator ==(Object other) {
    return other is ExperimentExposure &&
        other.userProperty == userProperty &&
        other.experimentId == experimentId;
  }
}
