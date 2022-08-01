part of katana_module;

/// A reroute configuration that requires login authentication and
/// registration of information.
@immutable
class RegistrationRequiredRerouteConfig extends RerouteConfig {
  /// A reroute configuration that requires login authentication and
  /// registration of information.
  const RegistrationRequiredRerouteConfig({
    this.loginRequiredRoutePath = "/landing",
    this.informationRequiredRoutePath = "/register",
    required this.key,
    this.userPath = "user",
    this.informationRequiredReroutePath = const {},
  });

  /// Reroute Path for login required.
  final String loginRequiredRoutePath;

  /// Reroute Path for information required.
  final String informationRequiredRoutePath;

  /// User collection path.
  final String userPath;

  /// A key to check.
  final String key;

  /// Specify the path according to the ID of the role.
  final Map<String, String> informationRequiredReroutePath;

  /// Reroute settings that are tied to.
  ///
  /// If [value] is `true`, the route will be changed to the path of [key].
  @override
  Map<String, bool Function(BuildContext context)> get value => {
        loginRequiredRoutePath: (context) {
          return !(context.model?.isSignedIn ?? true);
        },
        ...informationRequiredReroutePath.map(
          (key, value) => MapEntry(
            "/$value",
            (context) {
              final userId = context.model?.userId;
              if (userId.isEmpty) {
                return false;
              }
              final provider = context.model?.documentProvider(
                "$userPath/$userId",
                disposable: false,
              );
              if (provider == null) {
                return false;
              }
              final doc = readProvider(provider);
              return doc.get(this.key, "") == key;
            },
          ),
        ),
        informationRequiredRoutePath: (context) {
          final userId = context.model?.userId;
          if (userId.isEmpty) {
            return false;
          }
          final provider = context.model?.documentProvider(
            "$userPath/$userId",
            disposable: false,
          );
          if (provider == null) {
            return false;
          }
          final doc = readProvider(provider);
          return !doc.containsKey(key);
        },
      };

  /// Runs when restoring authentication.
  @override
  @mustCallSuper
  Future<void> onRestoreAuth(BuildContext context) async {
    await context.model?.tryRestoreAuth();
    return super.onRestoreAuth(context);
  }

  /// Runs after authentication has taken place.
  ///
  /// It is also called after registration or login has been completed.
  @override
  @mustCallSuper
  Future<void> onAfterAuth(BuildContext context) async {
    final userId = context.model?.userId;
    if (userId.isEmpty) {
      return;
    }
    final provider = context.model?.documentProvider(
      "$userPath/$userId",
      disposable: false,
    );
    if (provider == null) {
      return;
    }
    final doc = readProvider(provider);
    context.model?.loadDocument(doc);
    await doc.loading;
    return super.onAfterAuth(context);
  }

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      loginRequiredRoutePath.hashCode ^
      informationRequiredRoutePath.hashCode ^
      key.hashCode ^
      userPath.hashCode;
}
