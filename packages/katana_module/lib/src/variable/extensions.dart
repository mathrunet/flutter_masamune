part of katana_module;

extension VariableConfigBuildExtensions on VariableConfig {
  /// Build a widget that displays only values.
  ///
  /// If [data] is specified, the data is acquired from data that already exists.
  ///
  /// If [onlyRequired] is set to `true`, only [required] values will be displayed.
  Iterable<Widget> buildView({
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    if (onlyRequired && !this.required) {
      return const [];
    }
    if (!show || view == null) {
      return const [];
    }
    return view!._build(
      context: context,
      ref: ref,
      config: this,
      data: data,
      onlyRequired: onlyRequired,
    );
  }

  /// Build the widget for the form.
  ///
  /// If [data] is specified, the data is acquired from data that already exists.
  ///
  /// If [onlyRequired] is set to `true`, only [required] values will be displayed.
  Iterable<Widget> buildForm({
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    if (onlyRequired && !this.required) {
      return const [];
    }
    if (form == null) {
      return const [];
    }
    return form!._build(
      context: context,
      ref: ref,
      config: this,
      data: data,
      onlyRequired: onlyRequired,
    );
  }

  dynamic _setValue({
    required BuildContext context,
    required WidgetRef ref,
    bool updated = true,
  }) {
    if (form == null) {
      return null;
    }
    return form!._value(
      context: context,
      ref: ref,
      config: this,
      updated: updated,
    );
  }

  /// Set [target] to the data entered in the VariableConfig form.
  ///
  /// If [onlyRequired] is set to `true`, only [required] values will be set.
  dynamic setValue({
    required DynamicMap target,
    required BuildContext context,
    required WidgetRef ref,
    bool onlyRequired = false,
    bool updated = true,
  }) {
    if (onlyRequired && !this.required) {
      return;
    }
    final value = _setValue(
      context: context,
      ref: ref,
      updated: updated,
    );
    if (value == null) {
      return;
    }
    target[id] = value;
  }
}

extension VariableConfigListExtensions on Iterable<VariableConfig>? {
  /// Build a widget that displays only values.
  ///
  /// If [data] is specified, the data is acquired from data that already exists.
  ///
  /// If [onlyRequired] is set to `true`, only [required] values will be displayed.
  Iterable<Widget> buildView({
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    if (this == null) {
      return const [];
    }
    return this!.expand(
      (e) => e.buildView(
        context: context,
        ref: ref,
        data: data,
        onlyRequired: onlyRequired,
      ),
    );
  }

  /// Build the widget for the form.
  ///
  /// If [data] is specified, the data is acquired from data that already exists.
  ///
  /// If [onlyRequired] is set to `true`, only [required] values will be displayed.
  Iterable<Widget> buildForm({
    required BuildContext context,
    required WidgetRef ref,
    DynamicMap? data,
    bool onlyRequired = false,
  }) {
    if (this == null) {
      return const [];
    }
    return this!.expand(
      (e) => e.buildForm(
        context: context,
        ref: ref,
        data: data,
        onlyRequired: onlyRequired,
      ),
    );
  }

  /// Generates a DynamicMap according to the values entered from the form.
  ///
  /// If [onlyRequired] is set to `true`, only [required] values will be set.
  Map<String, dynamic> buildMap({
    required BuildContext context,
    required WidgetRef ref,
    bool onlyRequired = false,
  }) {
    if (this == null) {
      return const {};
    }
    return this!
        .where((e) => !onlyRequired || e.required)
        .toMap<String, dynamic>((e) {
      return MapEntry(
        e.id,
        e._setValue(
          context: context,
          ref: ref,
          updated: false,
        ),
      );
    });
  }

  /// Set [target] to the data entered in the VariableConfig form.
  ///
  /// If [onlyRequired] is set to `true`, only [required] values will be set.
  void setValue({
    required DynamicMap target,
    required BuildContext context,
    required WidgetRef ref,
    bool onlyRequired = false,
    bool updated = true,
  }) {
    if (this == null) {
      return;
    }
    for (final value in this!) {
      value.setValue(
        target: target,
        context: context,
        ref: ref,
        onlyRequired: onlyRequired,
        updated: updated,
      );
    }
  }
}
