// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GithubContentModel _$GithubContentModelFromJson(Map<String, dynamic> json) =>
    _GithubContentModel(
      name: json['name'] as String?,
      path: json['path'] as String?,
      content: json['content'] as String?,
      sha: json['sha'] as String?,
      type: json['type'] as String?,
      encoding: json['encoding'] as String?,
      patch: json['patch'] as String?,
      status: json['status'] as String?,
      committer: json['committer'] == null
          ? null
          : ModelRefBase<GithubUserModel>.fromJson(
              json['committer'] as Map<String, dynamic>),
      size: (json['size'] as num?)?.toInt() ?? 0,
      additionsCount: (json['additionsCount'] as num?)?.toInt() ?? 0,
      deletionsCount: (json['deletionsCount'] as num?)?.toInt() ?? 0,
      changesCount: (json['changesCount'] as num?)?.toInt() ?? 0,
      rawUrl: json['rawUrl'] == null
          ? null
          : ModelUri.fromJson(json['rawUrl'] as Map<String, dynamic>),
      blobUrl: json['blobUrl'] == null
          ? null
          : ModelUri.fromJson(json['blobUrl'] as Map<String, dynamic>),
      htmlUrl: json['htmlUrl'] == null
          ? null
          : ModelUri.fromJson(json['htmlUrl'] as Map<String, dynamic>),
      gitUrl: json['gitUrl'] == null
          ? null
          : ModelUri.fromJson(json['gitUrl'] as Map<String, dynamic>),
      downloadUrl: json['downloadUrl'] == null
          ? null
          : ModelUri.fromJson(json['downloadUrl'] as Map<String, dynamic>),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => GithubContentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      fromServer: json['fromServer'] as bool? ?? false,
    );

Map<String, dynamic> _$GithubContentModelToJson(_GithubContentModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'content': instance.content,
      'sha': instance.sha,
      'type': instance.type,
      'encoding': instance.encoding,
      'patch': instance.patch,
      'status': instance.status,
      'committer': instance.committer,
      'size': instance.size,
      'additionsCount': instance.additionsCount,
      'deletionsCount': instance.deletionsCount,
      'changesCount': instance.changesCount,
      'rawUrl': instance.rawUrl,
      'blobUrl': instance.blobUrl,
      'htmlUrl': instance.htmlUrl,
      'gitUrl': instance.gitUrl,
      'downloadUrl': instance.downloadUrl,
      'children': instance.children,
      'fromServer': instance.fromServer,
    };
