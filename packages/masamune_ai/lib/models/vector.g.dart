// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VectorModel _$VectorModelFromJson(Map<String, dynamic> json) => _VectorModel(
      agentId: json['agentId'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] == null
          ? const ModelTimestamp.now()
          : ModelTimestamp.fromJson(json['createdAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VectorModelToJson(_VectorModel instance) =>
    <String, dynamic>{
      'agentId': instance.agentId,
      'content': instance.content,
      'createdAt': instance.createdAt,
    };
