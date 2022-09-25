part of masamune;

@deprecated
class ValidateContext implements Listenable {
  ValidateContext._(this.validationIds);
  final List<String> validationIds;
  final Set<String> _validatedIds = {};
  final List<VoidCallback> _listeners = [];

  void set(String id) {
    if (_validatedIds.contains(id)) {
      return;
    }
    _validatedIds.add(id);
    _listeners.forEach((e) => e.call());
  }

  void unset(String id) {
    if (!_validatedIds.contains(id)) {
      return;
    }
    _validatedIds.remove(id);
    _listeners.forEach((e) => e.call());
  }

  bool get validated {
    for (final id in validationIds) {
      if (!_validatedIds.contains(id)) {
        return false;
      }
    }
    return true;
  }

  void _dispose() {
    _listeners.clear();
    _validatedIds.clear();
  }

  @override
  void addListener(VoidCallback listener) {
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    if (!_listeners.contains(listener)) {
      return;
    }
    _listeners.remove(listener);
  }
}

@deprecated
extension WidgetRefValidatorExtensions on WidgetRef {
  @deprecated
  ValidateContext useValidator(List<String> validationIds) {
    return valueBuilder<ValidateContext, _ValidatorValue>(
      key: "validator_${validationIds.join(",")}",
      builder: () {
        return _ValidatorValue(validationIds);
      },
    );
  }
}

@deprecated
class _ValidatorValue extends ScopedValue<ValidateContext> {
  const _ValidatorValue(this.validationIds);
  final List<String> validationIds;
  @override
  ScopedValueState<ValidateContext, ScopedValue<ValidateContext>>
      createState() => _ValidatorValueState();
}

@deprecated
class _ValidatorValueState
    extends ScopedValueState<ValidateContext, _ValidatorValue> {
  late final ValidateContext _validator;

  @override
  void initValue() {
    super.initValue();
    _validator = ValidateContext._(value.validationIds);
    _validator.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  ValidateContext build() => _validator;

  @override
  void dispose() {
    super.dispose();
    _validator.removeListener(_handledOnUpdate);
    _validator._dispose();
  }
}
