// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_milestone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GithubMilestoneValue {
  int? get id;
  int? get number;
  String? get state;
  String? get title;
  String? get description;
  String? get nodeId;
  @refParam
  GithubUserModelRef? get creator;
  int get openIssuesCount;
  int get closedIssuesCount;
  ModelUri? get url;
  ModelUri? get htmlUrl;
  ModelUri? get labelsUrl;
  ModelTimestamp? get dueOn;
  ModelTimestamp? get closedAt;
  ModelTimestamp get createdAt;
  ModelTimestamp get updatedAt;

  /// Create a copy of GithubMilestoneValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GithubMilestoneValueCopyWith<GithubMilestoneValue> get copyWith =>
      _$GithubMilestoneValueCopyWithImpl<GithubMilestoneValue>(
          this as GithubMilestoneValue, _$identity);

  /// Serializes this GithubMilestoneValue to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GithubMilestoneValue &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.openIssuesCount, openIssuesCount) ||
                other.openIssuesCount == openIssuesCount) &&
            (identical(other.closedIssuesCount, closedIssuesCount) ||
                other.closedIssuesCount == closedIssuesCount) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.labelsUrl, labelsUrl) ||
                other.labelsUrl == labelsUrl) &&
            (identical(other.dueOn, dueOn) || other.dueOn == dueOn) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      number,
      state,
      title,
      description,
      nodeId,
      creator,
      openIssuesCount,
      closedIssuesCount,
      url,
      htmlUrl,
      labelsUrl,
      dueOn,
      closedAt,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'GithubMilestoneValue(id: $id, number: $number, state: $state, title: $title, description: $description, nodeId: $nodeId, creator: $creator, openIssuesCount: $openIssuesCount, closedIssuesCount: $closedIssuesCount, url: $url, htmlUrl: $htmlUrl, labelsUrl: $labelsUrl, dueOn: $dueOn, closedAt: $closedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $GithubMilestoneValueCopyWith<$Res> {
  factory $GithubMilestoneValueCopyWith(GithubMilestoneValue value,
          $Res Function(GithubMilestoneValue) _then) =
      _$GithubMilestoneValueCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      int? number,
      String? state,
      String? title,
      String? description,
      String? nodeId,
      @refParam GithubUserModelRef? creator,
      int openIssuesCount,
      int closedIssuesCount,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? labelsUrl,
      ModelTimestamp? dueOn,
      ModelTimestamp? closedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt});
}

/// @nodoc
class _$GithubMilestoneValueCopyWithImpl<$Res>
    implements $GithubMilestoneValueCopyWith<$Res> {
  _$GithubMilestoneValueCopyWithImpl(this._self, this._then);

  final GithubMilestoneValue _self;
  final $Res Function(GithubMilestoneValue) _then;

  /// Create a copy of GithubMilestoneValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? number = freezed,
    Object? state = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? nodeId = freezed,
    Object? creator = freezed,
    Object? openIssuesCount = null,
    Object? closedIssuesCount = null,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? labelsUrl = freezed,
    Object? dueOn = freezed,
    Object? closedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      creator: freezed == creator
          ? _self.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      openIssuesCount: null == openIssuesCount
          ? _self.openIssuesCount
          : openIssuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      closedIssuesCount: null == closedIssuesCount
          ? _self.closedIssuesCount
          : closedIssuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      labelsUrl: freezed == labelsUrl
          ? _self.labelsUrl
          : labelsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      dueOn: freezed == dueOn
          ? _self.dueOn
          : dueOn // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
    ));
  }
}

/// Adds pattern-matching-related methods to [GithubMilestoneValue].
extension GithubMilestoneValuePatterns on GithubMilestoneValue {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GithubMilestoneValue value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubMilestoneValue() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GithubMilestoneValue value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubMilestoneValue():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GithubMilestoneValue value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubMilestoneValue() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int? id,
            int? number,
            String? state,
            String? title,
            String? description,
            String? nodeId,
            @refParam GithubUserModelRef? creator,
            int openIssuesCount,
            int closedIssuesCount,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? labelsUrl,
            ModelTimestamp? dueOn,
            ModelTimestamp? closedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GithubMilestoneValue() when $default != null:
        return $default(
            _that.id,
            _that.number,
            _that.state,
            _that.title,
            _that.description,
            _that.nodeId,
            _that.creator,
            _that.openIssuesCount,
            _that.closedIssuesCount,
            _that.url,
            _that.htmlUrl,
            _that.labelsUrl,
            _that.dueOn,
            _that.closedAt,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int? id,
            int? number,
            String? state,
            String? title,
            String? description,
            String? nodeId,
            @refParam GithubUserModelRef? creator,
            int openIssuesCount,
            int closedIssuesCount,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? labelsUrl,
            ModelTimestamp? dueOn,
            ModelTimestamp? closedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubMilestoneValue():
        return $default(
            _that.id,
            _that.number,
            _that.state,
            _that.title,
            _that.description,
            _that.nodeId,
            _that.creator,
            _that.openIssuesCount,
            _that.closedIssuesCount,
            _that.url,
            _that.htmlUrl,
            _that.labelsUrl,
            _that.dueOn,
            _that.closedAt,
            _that.createdAt,
            _that.updatedAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int? id,
            int? number,
            String? state,
            String? title,
            String? description,
            String? nodeId,
            @refParam GithubUserModelRef? creator,
            int openIssuesCount,
            int closedIssuesCount,
            ModelUri? url,
            ModelUri? htmlUrl,
            ModelUri? labelsUrl,
            ModelTimestamp? dueOn,
            ModelTimestamp? closedAt,
            ModelTimestamp createdAt,
            ModelTimestamp updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GithubMilestoneValue() when $default != null:
        return $default(
            _that.id,
            _that.number,
            _that.state,
            _that.title,
            _that.description,
            _that.nodeId,
            _that.creator,
            _that.openIssuesCount,
            _that.closedIssuesCount,
            _that.url,
            _that.htmlUrl,
            _that.labelsUrl,
            _that.dueOn,
            _that.closedAt,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GithubMilestoneValue extends GithubMilestoneValue {
  const _GithubMilestoneValue(
      {this.id,
      this.number,
      this.state,
      this.title,
      this.description,
      this.nodeId,
      @refParam this.creator,
      this.openIssuesCount = 0,
      this.closedIssuesCount = 0,
      this.url,
      this.htmlUrl,
      this.labelsUrl,
      this.dueOn,
      this.closedAt,
      this.createdAt = const ModelTimestamp.now(),
      this.updatedAt = const ModelTimestamp.now()})
      : super._();
  factory _GithubMilestoneValue.fromJson(Map<String, dynamic> json) =>
      _$GithubMilestoneValueFromJson(json);

  @override
  final int? id;
  @override
  final int? number;
  @override
  final String? state;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? nodeId;
  @override
  @refParam
  final GithubUserModelRef? creator;
  @override
  @JsonKey()
  final int openIssuesCount;
  @override
  @JsonKey()
  final int closedIssuesCount;
  @override
  final ModelUri? url;
  @override
  final ModelUri? htmlUrl;
  @override
  final ModelUri? labelsUrl;
  @override
  final ModelTimestamp? dueOn;
  @override
  final ModelTimestamp? closedAt;
  @override
  @JsonKey()
  final ModelTimestamp createdAt;
  @override
  @JsonKey()
  final ModelTimestamp updatedAt;

  /// Create a copy of GithubMilestoneValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GithubMilestoneValueCopyWith<_GithubMilestoneValue> get copyWith =>
      __$GithubMilestoneValueCopyWithImpl<_GithubMilestoneValue>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GithubMilestoneValueToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GithubMilestoneValue &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.openIssuesCount, openIssuesCount) ||
                other.openIssuesCount == openIssuesCount) &&
            (identical(other.closedIssuesCount, closedIssuesCount) ||
                other.closedIssuesCount == closedIssuesCount) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.htmlUrl, htmlUrl) || other.htmlUrl == htmlUrl) &&
            (identical(other.labelsUrl, labelsUrl) ||
                other.labelsUrl == labelsUrl) &&
            (identical(other.dueOn, dueOn) || other.dueOn == dueOn) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      number,
      state,
      title,
      description,
      nodeId,
      creator,
      openIssuesCount,
      closedIssuesCount,
      url,
      htmlUrl,
      labelsUrl,
      dueOn,
      closedAt,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'GithubMilestoneValue(id: $id, number: $number, state: $state, title: $title, description: $description, nodeId: $nodeId, creator: $creator, openIssuesCount: $openIssuesCount, closedIssuesCount: $closedIssuesCount, url: $url, htmlUrl: $htmlUrl, labelsUrl: $labelsUrl, dueOn: $dueOn, closedAt: $closedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$GithubMilestoneValueCopyWith<$Res>
    implements $GithubMilestoneValueCopyWith<$Res> {
  factory _$GithubMilestoneValueCopyWith(_GithubMilestoneValue value,
          $Res Function(_GithubMilestoneValue) _then) =
      __$GithubMilestoneValueCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      int? number,
      String? state,
      String? title,
      String? description,
      String? nodeId,
      @refParam GithubUserModelRef? creator,
      int openIssuesCount,
      int closedIssuesCount,
      ModelUri? url,
      ModelUri? htmlUrl,
      ModelUri? labelsUrl,
      ModelTimestamp? dueOn,
      ModelTimestamp? closedAt,
      ModelTimestamp createdAt,
      ModelTimestamp updatedAt});
}

/// @nodoc
class __$GithubMilestoneValueCopyWithImpl<$Res>
    implements _$GithubMilestoneValueCopyWith<$Res> {
  __$GithubMilestoneValueCopyWithImpl(this._self, this._then);

  final _GithubMilestoneValue _self;
  final $Res Function(_GithubMilestoneValue) _then;

  /// Create a copy of GithubMilestoneValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? number = freezed,
    Object? state = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? nodeId = freezed,
    Object? creator = freezed,
    Object? openIssuesCount = null,
    Object? closedIssuesCount = null,
    Object? url = freezed,
    Object? htmlUrl = freezed,
    Object? labelsUrl = freezed,
    Object? dueOn = freezed,
    Object? closedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_GithubMilestoneValue(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      number: freezed == number
          ? _self.number
          : number // ignore: cast_nullable_to_non_nullable
              as int?,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      nodeId: freezed == nodeId
          ? _self.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String?,
      creator: freezed == creator
          ? _self.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as GithubUserModelRef?,
      openIssuesCount: null == openIssuesCount
          ? _self.openIssuesCount
          : openIssuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      closedIssuesCount: null == closedIssuesCount
          ? _self.closedIssuesCount
          : closedIssuesCount // ignore: cast_nullable_to_non_nullable
              as int,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      htmlUrl: freezed == htmlUrl
          ? _self.htmlUrl
          : htmlUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      labelsUrl: freezed == labelsUrl
          ? _self.labelsUrl
          : labelsUrl // ignore: cast_nullable_to_non_nullable
              as ModelUri?,
      dueOn: freezed == dueOn
          ? _self.dueOn
          : dueOn // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      closedAt: freezed == closedAt
          ? _self.closedAt
          : closedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as ModelTimestamp,
    ));
  }
}

// dart format on
