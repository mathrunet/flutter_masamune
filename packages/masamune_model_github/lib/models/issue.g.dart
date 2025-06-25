// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IssueModel _$IssueModelFromJson(Map<String, dynamic> json) => _IssueModel(
      title: json['title'] as String? ?? "",
      body: json['body'] as String? ?? "",
      state: json['state'] as String? ?? "open",
      id: (json['id'] as num?)?.toInt(),
      number: (json['number'] as num?)?.toInt(),
      user: json['user'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const <Map<String, dynamic>>[],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      closedAt: json['closedAt'] as String?,
    );

Map<String, dynamic> _$IssueModelToJson(_IssueModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'state': instance.state,
      'id': instance.id,
      'number': instance.number,
      'user': instance.user,
      'labels': instance.labels,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'closedAt': instance.closedAt,
    };
