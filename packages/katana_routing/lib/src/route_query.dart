part of katana_routing;

/// Define a query for routing.
///
/// You can pass it as [arguments] with [pageNamed()] and so on.
class RouteQuery {
  /// Define a query for routing.
  ///
  /// You can pass it as [arguments] with [pageNamed()] and so on.
  ///
  /// Specify the page animation for [transition].
  ///
  /// You can explicitly specify arguments to be passed to the next page in [parameters].
  const RouteQuery({
    PageTransition transition = PageTransition.initial,
    DynamicMap parameters = const {},
  })  : _transition = transition,
        _parameters = parameters;

  final PageTransition _transition;
  final DynamicMap _parameters;

  /// Copy [RouteQuery] and create a new instance.
  ///
  /// Specify the page animation for [transition].
  ///
  /// You can explicitly specify arguments to be passed to the next page in [parameters].
  RouteQuery copyWith({PageTransition? transition, DynamicMap? parameters}) {
    return RouteQuery(
      transition: transition ?? _transition,
      parameters: parameters ?? _parameters,
    );
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
  int get hashCode => _parameters.hashCode;

  /// A string representation of this object.
  ///
  /// Some classes have a default textual representation,
  /// often paired with a static parse function (like [int.parse]).
  /// These classes will provide the textual representation as their string represetion.
  ///
  /// Other classes have no meaningful textual representation that a program will care about.
  /// Such classes will typically override toString to provide useful information when inspecting the object, mainly for debugging or logging.
  @override
  String toString() => "${describeIdentity(this)}($_transition, $_parameters)";

  /// View the page as a full screen.
  static RouteQuery get fullscreen =>
      const RouteQuery(transition: PageTransition.fullscreen);

  /// Display the page with no animation.
  static RouteQuery get immediately =>
      const RouteQuery(transition: PageTransition.none);

  /// Display the page with fade animation.
  static RouteQuery get fade =>
      const RouteQuery(transition: PageTransition.fade);

  /// Display the page with modal animation.
  static RouteQuery get modal =>
      const RouteQuery(transition: PageTransition.modal);

  /// If the platform is mobile, it will be displayed as [fullscreen],
  /// otherwise it will be displayed as [modal].
  static RouteQuery get fullscreenOrModal {
    if (Config.isDesktop) {
      return modal;
    } else {
      return fullscreen;
    }
  }
}

/// Types of page transitions.
enum PageTransition {
  /// Normal.
  initial,

  /// No animation.
  none,

  /// Full Screen.
  fullscreen,

  /// Fade animation.
  fade,

  /// Modal view.
  modal,
}
