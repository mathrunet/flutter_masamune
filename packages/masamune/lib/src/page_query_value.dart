part of '/masamune.dart';

extension on PageScopedValueRef {
  T query<T>(ScopedQueryBase<T, PageScopedValueRef> query) {
    return getScopedValue<T, _PageQueryValue<T>>(
      (ref) => _PageQueryValue<T>(
        query: query,
        ref: this,
        listen: query.listen,
        autoDisposeWhenUnreferenced: query.autoDisposeWhenUnreferenced,
      ),
      listen: query.listen,
      name: query.queryName,
    );
  }
}

extension on QueryScopedValueRef<PageScopedValueRef> {
  T query<T>(ScopedQueryBase<T, PageScopedValueRef> query) {
    return getScopedValue<T, _PageQueryValue<T>>(
      (ref) => _PageQueryValue<T>(
        query: query,
        ref: this.ref,
        listen: query.listen,
        autoDisposeWhenUnreferenced: query.autoDisposeWhenUnreferenced,
      ),
      listen: query.listen,
      name: query.queryName,
    );
  }
}

@immutable
class _PageQueryValue<T> extends RelatableScopedValue<T, PageScopedValueRef> {
  const _PageQueryValue({
    required this.query,
    required PageScopedValueRef ref,
    this.listen = false,
    this.autoDisposeWhenUnreferenced = false,
  }) : super(ref: ref);

  final ScopedQueryBase<T, PageScopedValueRef> query;
  final bool listen;
  final bool autoDisposeWhenUnreferenced;

  @override
  RelatableScopedValueState<T, PageScopedValueRef,
          RelatableScopedValue<T, PageScopedValueRef>>
      createState() => _QueryValueState<T>();
}

class _QueryValueState<T> extends RelatableScopedValueState<T,
    PageScopedValueRef, _PageQueryValue<T>> {
  _QueryValueState();

  late T _value;
  late T Function() _callback;

  @override
  bool get autoDisposeWhenUnreferenced => value.autoDisposeWhenUnreferenced;

  @override
  void initValue() {
    super.initValue();
    _callback = value.query(ref);
    _value = _callback();
    if (!value.query.listen) {
      return;
    }
    final val = _value;
    if (val is Listenable) {
      val.addListener(_handledOnUpdate);
    }
  }

  @override
  void didUpdateDescendant() {
    super.didUpdateDescendant();
    final oldVal = _value;
    if (value.query.listen && oldVal is Listenable) {
      oldVal.removeListener(_handledOnUpdate);
    }
    _value = _callback();
    final newVal = _value;
    if (value.query.listen && newVal is Listenable) {
      newVal.addListener(_handledOnUpdate);
    }
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    if (!value.query.listen) {
      return;
    }
    final val = _value;
    if (val is Listenable) {
      val.removeListener(_handledOnUpdate);
      if (val is ChangeNotifier) {
        val.dispose();
      }
    }
  }

  @override
  T build() => _value;
}
