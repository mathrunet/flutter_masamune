part of "/masamune_experiment.dart";

/// Experiment events for logging.
///
/// The event name is `ExperimentLoggerEvent.exposure` (the result of [toString]).
enum ExperimentLoggerEvent {
  /// The user was exposed to a branch of [Experiment.run] with [ExperimentExposure].
  ///
  /// The parameters are [userPropertyKey], [valueKey], [experimentIdKey] and [labelKey].
  exposure;

  /// Key for the name of the user property.
  static const userPropertyKey = "user_property";

  /// Key for the value of the user property (`<experimentId>:<label>`).
  static const valueKey = "value";

  /// Key for the ID of the experiment.
  static const experimentIdKey = "experiment_id";

  /// Key for the label of the selected branch.
  static const labelKey = "label";
}
