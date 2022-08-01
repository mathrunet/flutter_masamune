part of katana_module;

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
abstract class ModuleValueWidget<TModule extends PageModule, TValue>
    extends StatefulWidget {
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
  const ModuleValueWidget({Key? key}) : super(key: key);

  /// Converts from a ValueWidget passed in [child] to a ModuleValueWidget.
  ///
  /// Modules are not used for this purpose.
  static _ValueWidgetContainer<TModule, TValue>
      fromValueWidget<TModule extends PageModule, TValue>(
    ValueWidget<TValue> child,
  ) {
    return _ValueWidgetContainer<TModule, TValue>(child);
  }

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
  Widget build(
    BuildContext context,
    WidgetRef ref,
    TModule module,
    TValue value,
  );

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
  State<StatefulWidget> createState() =>
      ModuleValueWidgetState<TModule, TValue>();
}

class ModuleValueWidgetState<TModule extends PageModule, TValue>
    extends State<ModuleValueWidget<TModule, TValue>> {
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
    final module = PageModuleScope._of<TModule>(context);
    final value = ModuleValueProvider._of<TModule, TValue>(context);
    return NavigatorPathBuilder(
      builder: (path, context) => _navigatorPathBuild(path, context),
      child: Scoped(
        builder: (context, ref) => widget.build.call(
          context,
          ref,
          module,
          value,
        ),
      ),
    );
  }
}

/// Notifier to convey a specific value of a module to the widget directly below it.
///
/// Only [ModuleValueWidget<TModule, TValue>] can be placed under this.
///
/// For [value], specify the value you want to pass.
class ModuleValueProvider<TModule extends PageModule, TValue>
    extends InheritedWidget {
  /// Notifier to convey a specific value of a module to the widget directly below it.
  ///
  /// Only [ModuleValueWidget<TModule, TValue>] can be placed under this.
  ///
  /// For [value], specify the value you want to pass.
  const ModuleValueProvider({
    Key? key,
    required this.value,
    required ModuleValueWidget<TModule, TValue> child,
  }) : super(key: key, child: child);

  /// The value to pass to [child].
  final TValue value;

  static TValue _of<TModule extends PageModule, TValue>(BuildContext context) {
    final scoped = context.dependOnInheritedWidgetOfExactType<
            ModuleValueProvider<TModule, TValue>>() ??
        context.dependOnInheritedWidgetOfExactType<ModuleValueProvider>();
    assert(
      scoped != null,
      "[ModuleValueNotifier<TValue>] was not found. Please specify the widget of [ModuleValueNotifier<TValue>] as the parent.",
    );
    return scoped?.value as TValue;
  }

  /// Whether the framework should notify widgets that inherit from this widget.
  ///
  /// When this widget is rebuilt, sometimes we need to rebuild the widgets that
  /// inherit from this widget but sometimes we do not. For example, if the data
  /// held by this widget is the same as the data held by `oldWidget`, then we
  /// do not need to rebuild the widgets that inherited the data held by
  /// `oldWidget`.
  ///
  /// The framework distinguishes these cases by calling this function with the
  /// widget that previously occupied this location in the tree as an argument.
  /// The given widget is guaranteed to have the same [runtimeType] as this
  /// object.
  @override
  @protected
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class _ValueWidgetContainer<TModule extends PageModule, TValue>
    extends ModuleValueWidget<TModule, TValue> {
  const _ValueWidgetContainer(this.child);
  final ValueWidget<TValue> child;
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    TModule module,
    TValue value,
  ) {
    return ValueProvider(value: value, child: child);
  }
}
