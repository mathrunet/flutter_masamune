// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubReactionValue _$GithubReactionValueFromJson(Map<String, dynamic> json) =>
    _GithubReactionValue(
      plusOne: (json['plusOne'] as num?)?.toInt(),
      minusOne: (json['minusOne'] as num?)?.toInt(),
      confused: (json['confused'] as num?)?.toInt(),
      eyes: (json['eyes'] as num?)?.toInt(),
      heart: (json['heart'] as num?)?.toInt(),
      hooray: (json['hooray'] as num?)?.toInt(),
      laugh: (json['laugh'] as num?)?.toInt(),
      rocket: (json['rocket'] as num?)?.toInt(),
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      url: json['url'] == null
          ? null
          : ModelUri.fromJson(json['url'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GithubReactionValueToJson(
        _GithubReactionValue instance) =>
    <String, dynamic>{
      'plusOne': instance.plusOne,
      'minusOne': instance.minusOne,
      'confused': instance.confused,
      'eyes': instance.eyes,
      'heart': instance.heart,
      'hooray': instance.hooray,
      'laugh': instance.laugh,
      'rocket': instance.rocket,
      'totalCount': instance.totalCount,
      'url': instance.url,
    };
