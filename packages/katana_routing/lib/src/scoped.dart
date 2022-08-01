part of katana_routing;

/// Use this when using a different state management tool or a different MaterialApp for a specific plugin.
///
/// By placing it at the top of StatelessWidget's Widget tree, etc.
/// and inserting [container] which is managed separately,
/// Riverpod, Model, etc. can be used without going through UIMaterialApp.
class AppScoped extends StatelessWidget {
  const AppScoped({
    Key? key,
    this.container,
    required this.child,
  }) : super(key: key);

  /// App default ProviderContainer.
  static final ProviderContainer providerContainer = ProviderContainer();

  /// Separately managed ProviderContainer.
  final ProviderContainer? container;

  /// Child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: container ?? AppScoped.providerContainer,
      child: child,
    );
  }
}

/// You can limit the rebuild range by tucking it inside a widget.
///
/// Basically, it is used in the same way as [Consumer].
///
/// ```
/// Scoped(
///   builder: (context, ref) {
///     final document = ref.watch(localDocumentProvider("local"));
///     context.rebuild();
///   }
/// )
/// ```
class Scoped extends StatefulWidget {
  /// You can limit the rebuild range by tucking it inside a widget.
  ///
  /// Basically, it is used in the same way as [Consumer].
  ///
  /// ```
  /// Scoped(
  ///   builder: (context, ref) {
  ///     final document = ref.watch(localDocumentProvider("local"));
  ///     context.rebuild();
  ///   }
  /// )
  /// ```
  const Scoped({Key? key, required this.builder}) : super(key: key);

  /// Builder of Scoped.
  final Widget Function(BuildContext context, WidgetRef ref) builder;

  /// The closest instance of this class that encloses the given context.
  ///
  /// Typical usage:
  ///
  /// ```dart
  /// final state = UIScope.of(context);
  /// ```
  static ScopedStateBase of(BuildContext context) {
    final scoped = context
        .getElementForInheritedWidgetOfExactType<_Scoped>()!
        .widget as _Scoped;
    return scoped.state;
  }

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// Subclasses should override this method to return a newly created
  /// instance of their associated [State] subclass:
  ///
  /// ```dart
  /// @override
  /// _MyState createState() => _MyState();
  /// ```
  ///
  /// The framework can call this method multiple times over the lifetime of
  /// a [StatefulWidget]. For example, if the widget is inserted into the tree
  /// in multiple locations, the framework will create a separate [State] object
  /// for each location. Similarly, if the widget is removed from the tree and
  /// later inserted into the tree again, the framework will call [createState]
  /// again to create a fresh [State] object, simplifying the lifecycle of
  /// [State] objects.
  @override
  @protected
  State<StatefulWidget> createState() => ScopedState();
}

class ScopedState extends State<Scoped> implements ScopedStateBase {
  /// A map for storing page information.
  @override
  @protected
  final DynamicMap _map = {};

  /// Explicitly rebuild the widget.
  ///
  /// Basically, do not use it.
  ///
  /// Use this only if you want to force a rebuild.
  @override
  void rebuild() => setState(() {});

  /// Called when this object is removed from the tree.
  ///
  /// The framework calls this method whenever it removes this [State] object
  /// from the tree. In some cases, the framework will reinsert the [State]
  /// object into another part of the tree (e.g., if the subtree containing this
  /// [State] object is grafted from one location in the tree to another due to
  /// the use of a [GlobalKey]). If that happens, the framework will call
  /// [activate] to give the [State] object a chance to reacquire any resources
  /// that it released in [deactivate]. It will then also call [build] to give
  /// the [State] object a chance to adapt to its new location in the tree. If
  /// the framework does reinsert this subtree, it will do so before the end of
  /// the animation frame in which the subtree was removed from the tree. For
  /// this reason, [State] objects can defer releasing most resources until the
  /// framework calls their [dispose] method.
  ///
  /// Subclasses should override this method to clean up any links between
  /// this object and other elements in the tree (e.g. if you have provided an
  /// ancestor with a pointer to a descendant's [RenderObject]).
  ///
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.deactivate()`.
  ///
  /// See also:
  ///
  ///  * [dispose], which is called after [deactivate] if the widget is removed
  ///    from the tree permanently.
  @override
  @protected
  @mustCallSuper
  void deactivate() {
    _map.values.whereType<ScopedValueState>().forEach((e) => e.deactivate());
    super.deactivate();
  }

  /// Called when this object is removed from the tree permanently.
  ///
  /// The framework calls this method when this [State] object will never
  /// build again. After the framework calls [dispose], the [State] object is
  /// considered unmounted and the [mounted] property is false. It is an error
  /// to call [setState] at this point. This stage of the lifecycle is terminal:
  /// there is no way to remount a [State] object that has been disposed.
  ///
  /// Subclasses should override this method to release any resources retained
  /// by this object (e.g., stop any active animations).
  ///
  /// {@macro flutter.widgets.State.initState}
  ///
  /// If you override this, make sure to end your method with a call to
  /// super.dispose().
  ///
  /// See also:
  ///
  ///  * [deactivate], which is called prior to [dispose].
  @override
  @protected
  @mustCallSuper
  void dispose() {
    _map.values.whereType<ScopedValueState>().forEach((e) => e.dispose());
    _map.clear();
    super.dispose();
  }

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method in a number of different situations. For
  /// example:
  ///
  ///  * After calling [initState].
  ///  * After calling [didUpdateWidget].
  ///  * After receiving a call to [setState].
  ///  * After a dependency of this [State] object changes (e.g., an
  ///    [InheritedWidget] referenced by the previous [build] changes).
  ///  * After calling [deactivate] and then reinserting the [State] object into
  ///    the tree at another location.
  ///
  /// This method can potentially be called in every frame and should not have
  /// any side effects beyond building a widget.
  ///
  /// The framework replaces the subtree below this widget with the widget
  /// returned by this method, either by updating the existing subtree or by
  /// removing the subtree and inflating a new subtree, depending on whether the
  /// widget returned by this method can update the root of the existing
  /// subtree, as determined by calling [Widget.canUpdate].
  ///
  /// Typically implementations return a newly created constellation of widgets
  /// that are configured with information from this widget's constructor, the
  /// given [BuildContext], and the internal state of this [State] object.
  ///
  /// The given [BuildContext] contains information about the location in the
  /// tree at which this widget is being built. For example, the context
  /// provides the set of inherited widgets for this location in the tree. The
  /// [BuildContext] argument is always the same as the [context] property of
  /// this [State] object and will remain the same for the lifetime of this
  /// object. The [BuildContext] argument is provided redundantly here so that
  /// this method matches the signature for a [WidgetBuilder].
  ///
  /// ## Design discussion
  ///
  /// ### Why is the [build] method on [State], and not [StatefulWidget]?
  ///
  /// Putting a `Widget build(BuildContext context)` method on [State] rather
  /// than putting a `Widget build(BuildContext context, State state)` method
  /// on [StatefulWidget] gives developers more flexibility when subclassing
  /// [StatefulWidget].
  ///
  /// For example, [AnimatedWidget] is a subclass of [StatefulWidget] that
  /// introduces an abstract `Widget build(BuildContext context)` method for its
  /// subclasses to implement. If [StatefulWidget] already had a [build] method
  /// that took a [State] argument, [AnimatedWidget] would be forced to provide
  /// its [State] object to subclasses even though its [State] object is an
  /// internal implementation detail of [AnimatedWidget].
  ///
  /// Conceptually, [StatelessWidget] could also be implemented as a subclass of
  /// [StatefulWidget] in a similar manner. If the [build] method were on
  /// [StatefulWidget] rather than [State], that would not be possible anymore.
  ///
  /// Putting the [build] function on [State] rather than [StatefulWidget] also
  /// helps avoid a category of bugs related to closures implicitly capturing
  /// `this`. If you defined a closure in a [build] function on a
  /// [StatefulWidget], that closure would implicitly capture `this`, which is
  /// the current widget instance, and would have the (immutable) fields of that
  /// instance in scope:
  ///
  /// ```dart
  /// class MyButton extends StatefulWidget {
  ///   ...
  ///   final Color color;
  ///
  ///   @override
  ///   Widget build(BuildContext context, MyButtonState state) {
  ///     ... () { print("color: $color"); } ...
  ///   }
  /// }
  /// ```
  ///
  /// For example, suppose the parent builds `MyButton` with `color` being blue,
  /// the `$color` in the print function refers to blue, as expected. Now,
  /// suppose the parent rebuilds `MyButton` with green. The closure created by
  /// the first build still implicitly refers to the original widget and the
  /// `$color` still prints blue even through the widget has been updated to
  /// green.
  ///
  /// In contrast, with the [build] function on the [State] object, closures
  /// created during [build] implicitly capture the [State] instance instead of
  /// the widget instance:
  ///
  /// ```dart
  /// class MyButtonState extends State<MyButton> {
  ///   ...
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     ... () { print("color: ${widget.color}"); } ...
  ///   }
  /// }
  /// ```
  ///
  /// Now when the parent rebuilds `MyButton` with green, the closure created by
  /// the first build still refers to [State] object, which is preserved across
  /// rebuilds, but the framework has updated that [State] object's [widget]
  /// property to refer to the new `MyButton` instance and `${widget.color}`
  /// prints green, as expected.
  ///
  /// See also:
  ///
  ///  * [StatefulWidget], which contains the discussion on performance considerations.
  @override
  Widget build(BuildContext context) {
    return _Scoped(
      state: this,
      child: Consumer(
        key: widget.key,
        builder: (context, ref, child) {
          return widget.builder(context, ref);
        },
      ),
    );
  }
}

/// You can limit the rebuild range by tucking it inside a widget.
///
/// Basically, it is used in the same way as [ConsumerWidget].
///
/// ```
/// class Test extends ScopedWidget {
///   void build(BuildContext context, WidgetRef ref) {
///     final document = ref.watch(localDocumentProvider("local"));
///     context.rebuild();
///   }
/// }
/// ```
abstract class ScopedWidget extends StatefulWidget {
  /// You can limit the rebuild range by tucking it inside a widget.
  ///
  /// Basically, it is used in the same way as [ConsumerWidget].
  ///
  /// ```
  /// class Test extends ScopedWidget {
  ///   void build(BuildContext context, WidgetRef ref) {
  ///     final document = ref.watch(localDocumentProvider("local"));
  ///     context.rebuild();
  ///   }
  /// }
  /// ```
  const ScopedWidget({Key? key}) : super(key: key);

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree
  /// in a given [BuildContext] and when the dependencies of this widget change
  /// (e.g., an [InheritedWidget] referenced by this widget changes). This
  /// method can potentially be called in every frame and should not have any side
  /// effects beyond building a widget.
  ///
  /// The framework replaces the subtree below this widget with the widget
  /// returned by this method, either by updating the existing subtree or by
  /// removing the subtree and inflating a new subtree, depending on whether the
  /// widget returned by this method can update the root of the existing
  /// subtree, as determined by calling [Widget.canUpdate].
  ///
  /// Typically implementations return a newly created constellation of widgets
  /// that are configured with information from this widget's constructor and
  /// from the given [BuildContext].
  ///
  /// The given [BuildContext] contains information about the location in the
  /// tree at which this widget is being built. For example, the context
  /// provides the set of inherited widgets for this location in the tree. A
  /// given widget might be built with multiple different [BuildContext]
  /// arguments over time if the widget is moved around the tree or if the
  /// widget is inserted into the tree in multiple places at once.
  ///
  /// The implementation of this method must only depend on:
  ///
  /// * the fields of the widget, which themselves must not change over time,
  ///   and
  /// * any ambient state obtained from the `context` using
  ///   [BuildContext.dependOnInheritedWidgetOfExactType].
  ///
  /// If a widget's [build] method is to depend on anything else, use a
  /// [StatefulWidget] instead.
  ///
  /// See also:
  ///
  ///  * [StatelessWidget], which contains the discussion on performance considerations.
  @protected
  Widget build(BuildContext context, WidgetRef ref);

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// Subclasses should override this method to return a newly created
  /// instance of their associated [State] subclass:
  ///
  /// ```dart
  /// @override
  /// _MyState createState() => _MyState();
  /// ```
  ///
  /// The framework can call this method multiple times over the lifetime of
  /// a [StatefulWidget]. For example, if the widget is inserted into the tree
  /// in multiple locations, the framework will create a separate [State] object
  /// for each location. Similarly, if the widget is removed from the tree and
  /// later inserted into the tree again, the framework will call [createState]
  /// again to create a fresh [State] object, simplifying the lifecycle of
  /// [State] objects.
  @override
  @protected
  State<StatefulWidget> createState() => ScopedWidgetState();
}

class ScopedWidgetState extends State<ScopedWidget> {
  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method in a number of different situations. For
  /// example:
  ///
  ///  * After calling [initState].
  ///  * After calling [didUpdateWidget].
  ///  * After receiving a call to [setState].
  ///  * After a dependency of this [State] object changes (e.g., an
  ///    [InheritedWidget] referenced by the previous [build] changes).
  ///  * After calling [deactivate] and then reinserting the [State] object into
  ///    the tree at another location.
  ///
  /// This method can potentially be called in every frame and should not have
  /// any side effects beyond building a widget.
  ///
  /// The framework replaces the subtree below this widget with the widget
  /// returned by this method, either by updating the existing subtree or by
  /// removing the subtree and inflating a new subtree, depending on whether the
  /// widget returned by this method can update the root of the existing
  /// subtree, as determined by calling [Widget.canUpdate].
  ///
  /// Typically implementations return a newly created constellation of widgets
  /// that are configured with information from this widget's constructor, the
  /// given [BuildContext], and the internal state of this [State] object.
  ///
  /// The given [BuildContext] contains information about the location in the
  /// tree at which this widget is being built. For example, the context
  /// provides the set of inherited widgets for this location in the tree. The
  /// [BuildContext] argument is always the same as the [context] property of
  /// this [State] object and will remain the same for the lifetime of this
  /// object. The [BuildContext] argument is provided redundantly here so that
  /// this method matches the signature for a [WidgetBuilder].
  ///
  /// ## Design discussion
  ///
  /// ### Why is the [build] method on [State], and not [StatefulWidget]?
  ///
  /// Putting a `Widget build(BuildContext context)` method on [State] rather
  /// than putting a `Widget build(BuildContext context, State state)` method
  /// on [StatefulWidget] gives developers more flexibility when subclassing
  /// [StatefulWidget].
  ///
  /// For example, [AnimatedWidget] is a subclass of [StatefulWidget] that
  /// introduces an abstract `Widget build(BuildContext context)` method for its
  /// subclasses to implement. If [StatefulWidget] already had a [build] method
  /// that took a [State] argument, [AnimatedWidget] would be forced to provide
  /// its [State] object to subclasses even though its [State] object is an
  /// internal implementation detail of [AnimatedWidget].
  ///
  /// Conceptually, [StatelessWidget] could also be implemented as a subclass of
  /// [StatefulWidget] in a similar manner. If the [build] method were on
  /// [StatefulWidget] rather than [State], that would not be possible anymore.
  ///
  /// Putting the [build] function on [State] rather than [StatefulWidget] also
  /// helps avoid a category of bugs related to closures implicitly capturing
  /// `this`. If you defined a closure in a [build] function on a
  /// [StatefulWidget], that closure would implicitly capture `this`, which is
  /// the current widget instance, and would have the (immutable) fields of that
  /// instance in scope:
  ///
  /// ```dart
  /// class MyButton extends StatefulWidget {
  ///   ...
  ///   final Color color;
  ///
  ///   @override
  ///   Widget build(BuildContext context, MyButtonState state) {
  ///     ... () { print("color: $color"); } ...
  ///   }
  /// }
  /// ```
  ///
  /// For example, suppose the parent builds `MyButton` with `color` being blue,
  /// the `$color` in the print function refers to blue, as expected. Now,
  /// suppose the parent rebuilds `MyButton` with green. The closure created by
  /// the first build still implicitly refers to the original widget and the
  /// `$color` still prints blue even through the widget has been updated to
  /// green.
  ///
  /// In contrast, with the [build] function on the [State] object, closures
  /// created during [build] implicitly capture the [State] instance instead of
  /// the widget instance:
  ///
  /// ```dart
  /// class MyButtonState extends State<MyButton> {
  ///   ...
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     ... () { print("color: ${widget.color}"); } ...
  ///   }
  /// }
  /// ```
  ///
  /// Now when the parent rebuilds `MyButton` with green, the closure created by
  /// the first build still refers to [State] object, which is preserved across
  /// rebuilds, but the framework has updated that [State] object's [widget]
  /// property to refer to the new `MyButton` instance and `${widget.color}`
  /// prints green, as expected.
  ///
  /// See also:
  ///
  ///  * [StatefulWidget], which contains the discussion on performance considerations.
  @override
  Widget build(BuildContext context) {
    return Scoped(builder: widget.build);
  }
}

/// Base class for Scoped.
abstract class ScopedStateBase {
  /// A map for storing page information.
  @protected
  final DynamicMap _map = {};

  /// The location in the tree where this widget builds.
  ///
  /// The framework associates [State] objects with a [BuildContext] after
  /// creating them with [StatefulWidget.createState] and before calling
  /// [initState]. The association is permanent: the [State] object will never
  /// change its [BuildContext]. However, the [BuildContext] itself can be moved
  /// around the tree.
  ///
  /// After calling [dispose], the framework severs the [State] object's
  /// connection with the [BuildContext].
  BuildContext get context;

  /// Explicitly rebuild the widget.
  ///
  /// Basically, do not use it.
  ///
  /// Use this only if you want to force a rebuild.
  void rebuild();
}

class _Scoped extends InheritedWidget {
  const _Scoped({required Widget child, required this.state, Key? key})
      : super(key: key, child: child);
  final ScopedStateBase state;
  @override
  bool updateShouldNotify(_Scoped old) {
    return true;
  }
}
