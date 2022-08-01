part of katana_module;

/// Module for defining conditions.
///
/// If you specify [T],
/// you can set the type of value that is the source of the condition.
@immutable
abstract class ConditionModule<T> extends Module {
  /// Module for defining conditions.
  const ConditionModule();

  /// Pass [context] and [value] to check the condition.
  ///
  /// If `true` is returned, the process is passed.
  bool check(BuildContext context, T value);
}

/// Module that passes a query and
/// returns `true` if the condition is met.
@immutable
class ModelQueryConditionModule extends ConditionModule<Object?> {
  /// Module that passes a model query and
  /// returns `true` if the condition is met.
  const ModelQueryConditionModule(this.query);

  /// Model query to use as a condition.
  final ModelQuery query;

  @override
  bool check(BuildContext context, Object? value) {
    return query.check(value);
  }
}
