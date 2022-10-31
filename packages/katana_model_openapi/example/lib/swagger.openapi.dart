// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: prefer_initializing_formals, unnecessary_brace_in_string_interps, invalid_annotation_target, require_trailing_commas

import 'package:freezed_annotation/freezed_annotation.dart';

part 'swagger.openapi.freezed.dart';
part 'swagger.openapi.g.dart';

@freezed
class Empty with _$Empty {
  const factory Empty() = _Empty;

  factory Empty.fromJson(Map<String, Object?> json) => _$EmptyFromJson(json);
}

@freezed
class Error with _$Error {
  const factory Error({@JsonKey(name: "errors") ErrorErrors? errors}) = _Error;

  factory Error.fromJson(Map<String, Object?> json) => _$ErrorFromJson(json);
}

@freezed
class CompanyRecord with _$CompanyRecord {
  const factory CompanyRecord({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "owner") String? owner,
    @JsonKey(name: "zip") String? zip,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "address2") String? address2,
    @JsonKey(name: "address3") String? address3,
    @JsonKey(name: "address4") String? address4,
    @JsonKey(name: "tel") String? tel,
    @JsonKey(name: "email") String? email,
  }) = _CompanyRecord;

  factory CompanyRecord.fromJson(Map<String, Object?> json) =>
      _$CompanyRecordFromJson(json);
}

@freezed
class OfficeRecord with _$OfficeRecord {
  const factory OfficeRecord({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_company_id") int? mCompanyId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "owner") String? owner,
    @JsonKey(name: "zip") String? zip,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "address2") String? address2,
    @JsonKey(name: "address3") String? address3,
    @JsonKey(name: "address4") String? address4,
    @JsonKey(name: "tel") String? tel,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "edgelimit") int? edgelimit,
    @JsonKey(name: "intdash_tenant_id") String? intdashTenantId,
    @JsonKey(name: "crm_flg") Object? crmFlg,
    @Default([]) @JsonKey(name: "pivot") List<OfficeRecordPivot> pivot,
  }) = _OfficeRecord;

  factory OfficeRecord.fromJson(Map<String, Object?> json) =>
      _$OfficeRecordFromJson(json);
}

@freezed
class OfficePivotRecord with _$OfficePivotRecord {
  const factory OfficePivotRecord({
    @JsonKey(name: "m_company_user_id") int? mCompanyUserId,
    @JsonKey(name: "m_office_id") int? mOfficeId,
  }) = _OfficePivotRecord;

  factory OfficePivotRecord.fromJson(Map<String, Object?> json) =>
      _$OfficePivotRecordFromJson(json);
}

@freezed
class RoleRecord with _$RoleRecord {
  const factory RoleRecord({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "role_name") String? roleName,
    @Default([]) @JsonKey(name: "pivot") List<RoleRecordPivot> pivot,
    @Default([])
    @JsonKey(name: "permissions")
        List<RoleRecordPermissions> permissions,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _RoleRecord;

  factory RoleRecord.fromJson(Map<String, Object?> json) =>
      _$RoleRecordFromJson(json);
}

@freezed
class PermissionRecord with _$PermissionRecord {
  const factory PermissionRecord({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "permission_name") String? permissionName,
    @Default([]) @JsonKey(name: "pivot") List<PermissionRecordPivot> pivot,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _PermissionRecord;

  factory PermissionRecord.fromJson(Map<String, Object?> json) =>
      _$PermissionRecordFromJson(json);
}

@freezed
class RolePivotRecord with _$RolePivotRecord {
  const factory RolePivotRecord({
    @JsonKey(name: "m_login_account_id") int? mLoginAccountId,
    @JsonKey(name: "m_role_id") int? mRoleId,
  }) = _RolePivotRecord;

  factory RolePivotRecord.fromJson(Map<String, Object?> json) =>
      _$RolePivotRecordFromJson(json);
}

@freezed
class PermissionPivotRecord with _$PermissionPivotRecord {
  const factory PermissionPivotRecord({
    @JsonKey(name: "m_role_id") int? mRoleId,
    @JsonKey(name: "m_permission_id") int? mPermissionId,
  }) = _PermissionPivotRecord;

  factory PermissionPivotRecord.fromJson(Map<String, Object?> json) =>
      _$PermissionPivotRecordFromJson(json);
}

@freezed
class MemberSearchRecordGet with _$MemberSearchRecordGet {
  const factory MemberSearchRecordGet({
    @JsonKey(name: "current_page") int? currentPage,
    @JsonKey(name: "last_page") int? lastPage,
    @JsonKey(name: "per_page") int? perPage,
    @JsonKey(name: "from") int? from,
    @JsonKey(name: "to") int? to,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "first_page_url") String? firstPageUrl,
    @JsonKey(name: "prev_page_url") String? prevPageUrl,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "last_page_url") String? lastPageUrl,
    @JsonKey(name: "path") String? path,
    @Default([]) @JsonKey(name: "data") List<MemberSearchRecordGetData> data,
  }) = _MemberSearchRecordGet;

  factory MemberSearchRecordGet.fromJson(Map<String, Object?> json) =>
      _$MemberSearchRecordGetFromJson(json);
}

@freezed
class MemberRecordGet with _$MemberRecordGet {
  const factory MemberRecordGet({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_office_id") int? mOfficeId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "name_kana") String? nameKana,
    @JsonKey(name: "gender") int? gender,
    @JsonKey(name: "birth_date") String? birthDate,
    @JsonKey(name: "height") num? height,
    @JsonKey(name: "weight") num? weight,
    @Default([])
    @JsonKey(name: "member_edges")
        List<MemberRecordGetMemberEdges> memberEdges,
    @Default([])
    @JsonKey(name: "member_links")
        List<MemberRecordGetMemberLinks> memberLinks,
    @Default([])
    @JsonKey(name: "record_measurement_sessions")
        List<MemberRecordGetRecordMeasurementSessions>
            recordMeasurementSessions,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "deleted_at") String? deletedAt,
  }) = _MemberRecordGet;

  factory MemberRecordGet.fromJson(Map<String, Object?> json) =>
      _$MemberRecordGetFromJson(json);
}

@freezed
class MemberEdge with _$MemberEdge {
  const factory MemberEdge({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "edge_uuid") String? edgeUuid,
  }) = _MemberEdge;

  factory MemberEdge.fromJson(Map<String, Object?> json) =>
      _$MemberEdgeFromJson(json);
}

@freezed
class MemberEdgeUsage with _$MemberEdgeUsage {
  const factory MemberEdgeUsage({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "edge_uuid") String? edgeUuid,
    @JsonKey(name: "member") MemberRecordGet? member,
  }) = _MemberEdgeUsage;

  factory MemberEdgeUsage.fromJson(Map<String, Object?> json) =>
      _$MemberEdgeUsageFromJson(json);
}

@freezed
class OfficePost with _$OfficePost {
  const factory OfficePost({
    @JsonKey(name: "m_company_id") required int mCompanyId,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "owner") String? owner,
    @JsonKey(name: "zip") int? zip,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "address2") String? address2,
    @JsonKey(name: "address3") String? address3,
    @JsonKey(name: "address4") String? address4,
    @JsonKey(name: "tel") String? tel,
    @JsonKey(name: "email") required String email,
    @JsonKey(name: "edgelimit") int? edgelimit,
    @JsonKey(name: "crm_flg") int? crmFlg,
    @JsonKey(name: "plan") int? plan,
    @JsonKey(name: "term_start") String? termStart,
    @JsonKey(name: "term_end") String? termEnd,
  }) = _OfficePost;

  factory OfficePost.fromJson(Map<String, Object?> json) =>
      _$OfficePostFromJson(json);
}

@freezed
class OfficeGet with _$OfficeGet {
  const factory OfficeGet({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_company_id") required int mCompanyId,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "owner") String? owner,
    @JsonKey(name: "zip") int? zip,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "address2") String? address2,
    @JsonKey(name: "address3") String? address3,
    @JsonKey(name: "address4") String? address4,
    @JsonKey(name: "tel") String? tel,
    @JsonKey(name: "email") required String email,
    @JsonKey(name: "edgelimit") int? edgelimit,
    @JsonKey(name: "intdash_tenant_id") String? intdashTenantId,
    @JsonKey(name: "crm_flg") int? crmFlg,
    @JsonKey(name: "plan") int? plan,
    @JsonKey(name: "term_start") String? termStart,
    @JsonKey(name: "term_end") String? termEnd,
  }) = _OfficeGet;

  factory OfficeGet.fromJson(Map<String, Object?> json) =>
      _$OfficeGetFromJson(json);
}

@freezed
class OfficePut with _$OfficePut {
  const factory OfficePut({
    @JsonKey(name: "m_company_id") required int mCompanyId,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "owner") String? owner,
    @JsonKey(name: "zip") int? zip,
    @JsonKey(name: "address1") String? address1,
    @JsonKey(name: "address2") String? address2,
    @JsonKey(name: "address3") String? address3,
    @JsonKey(name: "address4") String? address4,
    @JsonKey(name: "tel") String? tel,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "edgelimit") int? edgelimit,
    @JsonKey(name: "intdash_tenant_id") String? intdashTenantId,
    @JsonKey(name: "crm_flg") int? crmFlg,
    @JsonKey(name: "plan") int? plan,
    @JsonKey(name: "term_start") String? termStart,
    @JsonKey(name: "term_end") String? termEnd,
  }) = _OfficePut;

  factory OfficePut.fromJson(Map<String, Object?> json) =>
      _$OfficePutFromJson(json);
}

@freezed
class MemberRecordPost with _$MemberRecordPost {
  const factory MemberRecordPost({
    @JsonKey(name: "m_office_id") required int mOfficeId,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "name_kana") required String nameKana,
    @JsonKey(name: "gender") int? gender,
    @JsonKey(name: "birth_date") String? birthDate,
    @JsonKey(name: "height") num? height,
    @JsonKey(name: "weight") num? weight,
  }) = _MemberRecordPost;

  factory MemberRecordPost.fromJson(Map<String, Object?> json) =>
      _$MemberRecordPostFromJson(json);
}

@freezed
class MemberLinkGet with _$MemberLinkGet {
  const factory MemberLinkGet({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "link_service") int? linkService,
    @JsonKey(name: "link_data") MemberLinkGetLinkData? linkData,
  }) = _MemberLinkGet;

  factory MemberLinkGet.fromJson(Map<String, Object?> json) =>
      _$MemberLinkGetFromJson(json);
}

@freezed
class MemberLinkPost with _$MemberLinkPost {
  const factory MemberLinkPost({
    @JsonKey(name: "link_service") required int linkService,
    @JsonKey(name: "link_data") required MemberLinkPostLinkData linkData,
  }) = _MemberLinkPost;

  factory MemberLinkPost.fromJson(Map<String, Object?> json) =>
      _$MemberLinkPostFromJson(json);
}

@freezed
class MemberLinkPut with _$MemberLinkPut {
  const factory MemberLinkPut({
    @JsonKey(name: "link_service") required int linkService,
    @JsonKey(name: "link_data") required MemberLinkPutLinkData linkData,
  }) = _MemberLinkPut;

  factory MemberLinkPut.fromJson(Map<String, Object?> json) =>
      _$MemberLinkPutFromJson(json);
}

@freezed
class MemberRecordPut with _$MemberRecordPut {
  const factory MemberRecordPut({
    @JsonKey(name: "m_office_id") int? mOfficeId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "name_kana") String? nameKana,
    @JsonKey(name: "gender") int? gender,
    @JsonKey(name: "birth_date") String? birthDate,
    @JsonKey(name: "height") num? height,
    @JsonKey(name: "weight") num? weight,
  }) = _MemberRecordPut;

  factory MemberRecordPut.fromJson(Map<String, Object?> json) =>
      _$MemberRecordPutFromJson(json);
}

@freezed
class LoginAccountRecord with _$LoginAccountRecord {
  const factory LoginAccountRecord({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "firebase_id") String? firebaseId,
    @JsonKey(name: "account_type") String? accountType,
    @JsonKey(name: "account_id") int? accountId,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "account") AccountRecord? account,
    @JsonKey(name: "roles") RoleRecord? roles,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _LoginAccountRecord;

  factory LoginAccountRecord.fromJson(Map<String, Object?> json) =>
      _$LoginAccountRecordFromJson(json);
}

@freezed
class AccountRecord with _$AccountRecord {
  const factory AccountRecord({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_company_id") int? mCompanyId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "company") CompanyRecord? company,
    @Default([]) @JsonKey(name: "offices") List<OfficeRecord> offices,
  }) = _AccountRecord;

  factory AccountRecord.fromJson(Map<String, Object?> json) =>
      _$AccountRecordFromJson(json);
}

@freezed
class RecordDataBlankPost with _$RecordDataBlankPost {
  const factory RecordDataBlankPost(
      {@JsonKey(name: "m_member_id") int? mMemberId}) = _RecordDataBlankPost;

  factory RecordDataBlankPost.fromJson(Map<String, Object?> json) =>
      _$RecordDataBlankPostFromJson(json);
}

@freezed
class RecordDataBlank with _$RecordDataBlank {
  const factory RecordDataBlank({
    @JsonKey(name: "record_data_id") String? recordDataId,
    @JsonKey(name: "intdash_mesurement_uuid") String? intdashMesurementUuid,
  }) = _RecordDataBlank;

  factory RecordDataBlank.fromJson(Map<String, Object?> json) =>
      _$RecordDataBlankFromJson(json);
}

@freezed
class RecordMeasurementSearchGet with _$RecordMeasurementSearchGet {
  const factory RecordMeasurementSearchGet({
    @JsonKey(name: "current_page") int? currentPage,
    @JsonKey(name: "last_page") int? lastPage,
    @JsonKey(name: "per_page") int? perPage,
    @JsonKey(name: "from") int? from,
    @JsonKey(name: "to") int? to,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "first_page_url") String? firstPageUrl,
    @JsonKey(name: "prev_page_url") String? prevPageUrl,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "last_page_url") String? lastPageUrl,
    @JsonKey(name: "path") String? path,
    @Default([])
    @JsonKey(name: "data")
        List<RecordMeasurementSearchGetData> data,
  }) = _RecordMeasurementSearchGet;

  factory RecordMeasurementSearchGet.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementSearchGetFromJson(json);
}

@freezed
class RecordMeasurementSessionSearchGet
    with _$RecordMeasurementSessionSearchGet {
  const factory RecordMeasurementSessionSearchGet({
    @JsonKey(name: "current_page") int? currentPage,
    @JsonKey(name: "last_page") int? lastPage,
    @JsonKey(name: "per_page") int? perPage,
    @JsonKey(name: "from") int? from,
    @JsonKey(name: "to") int? to,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "first_page_url") String? firstPageUrl,
    @JsonKey(name: "prev_page_url") String? prevPageUrl,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "last_page_url") String? lastPageUrl,
    @JsonKey(name: "path") String? path,
    @Default([])
    @JsonKey(name: "data")
        List<RecordMeasurementSessionSearchGetData> data,
  }) = _RecordMeasurementSessionSearchGet;

  factory RecordMeasurementSessionSearchGet.fromJson(
          Map<String, Object?> json) =>
      _$RecordMeasurementSessionSearchGetFromJson(json);
}

@freezed
class RecordDataGet with _$RecordDataGet {
  const factory RecordDataGet({
    @JsonKey(name: "record_data_id") String? recordDataId,
    @JsonKey(name: "intdash_mesurement_uuid") String? intdashMesurementUuid,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "intdash_measurement_uuid") String? intdashMeasurementUuid,
    @JsonKey(name: "record_datetime_from") String? recordDatetimeFrom,
    @JsonKey(name: "record_datetime_to") String? recordDatetimeTo,
    @JsonKey(name: "record_name") String? recordName,
    @JsonKey(name: "pace") num? pace,
    @JsonKey(name: "distance") num? distance,
    @JsonKey(name: "gait_type") int? gaitType,
    @JsonKey(name: "foot_strike_l") num? footStrikeL,
    @JsonKey(name: "foot_strike_r") num? footStrikeR,
    @JsonKey(name: "pronation_l") num? pronationL,
    @JsonKey(name: "pronation_r") num? pronationR,
    @JsonKey(name: "stride_l") num? strideL,
    @JsonKey(name: "stride_r") num? strideR,
    @JsonKey(name: "cadence_l") num? cadenceL,
    @JsonKey(name: "cadence_r") num? cadenceR,
    @JsonKey(name: "landing_time_l") num? landingTimeL,
    @JsonKey(name: "landing_time_r") num? landingTimeR,
    @JsonKey(name: "stride_height_l") num? strideHeightL,
    @JsonKey(name: "stride_height_r") num? strideHeightR,
    @JsonKey(name: "landing_force_l") num? landingForceL,
    @JsonKey(name: "landing_force_r") num? landingForceR,
    @JsonKey(name: "swing_phase_duration_l") num? swingPhaseDurationL,
    @JsonKey(name: "swing_phase_duration_r") num? swingPhaseDurationR,
    @JsonKey(name: "toe_off_angle_l") num? toeOffAngleL,
    @JsonKey(name: "toe_off_angle_r") num? toeOffAngleR,
    @JsonKey(name: "cyclic_stride_file_l") String? cyclicStrideFileL,
    @JsonKey(name: "cyclic_stride_file_r") String? cyclicStrideFileR,
    @JsonKey(name: "gait_analysis_file_l") String? gaitAnalysisFileL,
    @JsonKey(name: "gait_analysis_file_r") String? gaitAnalysisFileR,
    @JsonKey(name: "gaitanalysis_status") num? gaitanalysisStatus,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "deleted_at") String? deletedAt,
    @Default([]) @JsonKey(name: "tags") List<RecordDataGetTags> tags,
  }) = _RecordDataGet;

  factory RecordDataGet.fromJson(Map<String, Object?> json) =>
      _$RecordDataGetFromJson(json);
}

@freezed
class RecordMeasurementPost with _$RecordMeasurementPost {
  const factory RecordMeasurementPost({
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "edge_uuid") String? edgeUuid,
    @JsonKey(name: "record_name") String? recordName,
    @JsonKey(name: "intdash_measurement_uuid") String? intdashMeasurementUuid,
    @Default([])
    @JsonKey(name: "record_core")
        List<RecordMeasurementPostRecordCore> recordCore,
  }) = _RecordMeasurementPost;

  factory RecordMeasurementPost.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementPostFromJson(json);
}

@freezed
class RecordMeasurementPut with _$RecordMeasurementPut {
  const factory RecordMeasurementPut({
    @JsonKey(name: "record_data_id") String? recordDataId,
    @JsonKey(name: "intdash_measurement_uuid") String? intdashMeasurementUuid,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "record_datetime_from") String? recordDatetimeFrom,
    @JsonKey(name: "record_datetime_to") String? recordDatetimeTo,
    @JsonKey(name: "record_name") String? recordName,
  }) = _RecordMeasurementPut;

  factory RecordMeasurementPut.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementPutFromJson(json);
}

@freezed
class RecordCorePost with _$RecordCorePost {
  const factory RecordCorePost({
    @JsonKey(name: "core_type") int? coreType,
    @JsonKey(name: "core_version") String? coreVersion,
    @JsonKey(name: "firmware_version") String? firmwareVersion,
    @JsonKey(name: "m_measurement_part_id") int? mMeasurementPartId,
    @JsonKey(name: "intdash_measurement_channel")
        int? intdashMeasurementChannel,
    @JsonKey(name: "m_device_id") int? mDeviceId,
  }) = _RecordCorePost;

  factory RecordCorePost.fromJson(Map<String, Object?> json) =>
      _$RecordCorePostFromJson(json);
}

@freezed
class RecordCoreGet with _$RecordCoreGet {
  const factory RecordCoreGet({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "core_type") int? coreType,
    @JsonKey(name: "core_version") String? coreVersion,
    @JsonKey(name: "firmware_version") String? firmwareVersion,
    @JsonKey(name: "m_device_id") int? mDeviceId,
    @JsonKey(name: "t_record_measurement_id") int? tRecordMeasurementId,
    @JsonKey(name: "m_measurement_part_id") int? mMeasurementPartId,
    @JsonKey(name: "intdash_measurement_channel")
        int? intdashMeasurementChannel,
    @JsonKey(name: "t_record_gait_analysis_id") int? tRecordGaitAnalysisId,
    @JsonKey(name: "record_gait_analysis")
        RecordGaitAnalysisGet? recordGaitAnalysis,
  }) = _RecordCoreGet;

  factory RecordCoreGet.fromJson(Map<String, Object?> json) =>
      _$RecordCoreGetFromJson(json);
}

@freezed
class RecordMeasurementGet with _$RecordMeasurementGet {
  const factory RecordMeasurementGet({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "record_data_id") String? recordDataId,
    @JsonKey(name: "intdash_measurement_uuid") String? intdashMeasurementUuid,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "record_datetime_from") String? recordDatetimeFrom,
    @JsonKey(name: "record_datetime_to") String? recordDatetimeTo,
    @JsonKey(name: "record_name") String? recordName,
    @Default([])
    @JsonKey(name: "record_core")
        List<RecordMeasurementGetRecordCore> recordCore,
    @JsonKey(name: "analysis_data") AnalysisData? analysisData,
    @Default([]) @JsonKey(name: "tags") List<RecordMeasurementGetTags> tags,
  }) = _RecordMeasurementGet;

  factory RecordMeasurementGet.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementGetFromJson(json);
}

@freezed
class RecordGaitAnalysisPost with _$RecordGaitAnalysisPost {
  const factory RecordGaitAnalysisPost({
    @Default([]) @JsonKey(name: "t_record_core_id") List<int> tRecordCoreId,
    @JsonKey(name: "gait_analysis") RecordGaitAnalysisPostDetail? gaitAnalysis,
  }) = _RecordGaitAnalysisPost;

  factory RecordGaitAnalysisPost.fromJson(Map<String, Object?> json) =>
      _$RecordGaitAnalysisPostFromJson(json);
}

@freezed
class MemberListDelete with _$MemberListDelete {
  const factory MemberListDelete(
      {@Default([]) @JsonKey(name: "ids") List<int> ids}) = _MemberListDelete;

  factory MemberListDelete.fromJson(Map<String, Object?> json) =>
      _$MemberListDeleteFromJson(json);
}

@freezed
class RecordMeasurementListDelete with _$RecordMeasurementListDelete {
  const factory RecordMeasurementListDelete(
          {@Default([]) @JsonKey(name: "ids") List<int> ids}) =
      _RecordMeasurementListDelete;

  factory RecordMeasurementListDelete.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementListDeleteFromJson(json);
}

@freezed
class RecordGaitAnalysisPostDetail with _$RecordGaitAnalysisPostDetail {
  const factory RecordGaitAnalysisPostDetail({
    @JsonKey(name: "pace") num? pace,
    @JsonKey(name: "distance") num? distance,
    @JsonKey(name: "gait_type") int? gaitType,
    @JsonKey(name: "foot_strike_l") num? footStrikeL,
    @JsonKey(name: "foot_strike_r") num? footStrikeR,
    @JsonKey(name: "pronation_l") num? pronationL,
    @JsonKey(name: "pronation_r") num? pronationR,
    @JsonKey(name: "stride_l") num? strideL,
    @JsonKey(name: "stride_r") num? strideR,
    @JsonKey(name: "cadence_l") num? cadenceL,
    @JsonKey(name: "cadence_r") num? cadenceR,
    @JsonKey(name: "landing_time_l") num? landingTimeL,
    @JsonKey(name: "landing_time_r") num? landingTimeR,
    @JsonKey(name: "stride_height_l") num? strideHeightL,
    @JsonKey(name: "stride_height_r") num? strideHeightR,
    @JsonKey(name: "landing_force_l") num? landingForceL,
    @JsonKey(name: "landing_force_r") num? landingForceR,
    @JsonKey(name: "swing_phase_duration_l") num? swingPhaseDurationL,
    @JsonKey(name: "swing_phase_duration_r") num? swingPhaseDurationR,
    @JsonKey(name: "toe_off_angle_l") num? toeOffAngleL,
    @JsonKey(name: "toe_off_angle_r") num? toeOffAngleR,
    @JsonKey(name: "cyclic_stride_file_l") String? cyclicStrideFileL,
    @JsonKey(name: "cyclic_stride_file_r") String? cyclicStrideFileR,
    @JsonKey(name: "gait_analysis_file_l") String? gaitAnalysisFileL,
    @JsonKey(name: "gait_analysis_file_r") String? gaitAnalysisFileR,
    @JsonKey(name: "gaitanalysis_status") num? gaitanalysisStatus,
  }) = _RecordGaitAnalysisPostDetail;

  factory RecordGaitAnalysisPostDetail.fromJson(Map<String, Object?> json) =>
      _$RecordGaitAnalysisPostDetailFromJson(json);
}

@freezed
class RecordGaitAnalysisGet with _$RecordGaitAnalysisGet {
  const factory RecordGaitAnalysisGet({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "pace") num? pace,
    @JsonKey(name: "distance") num? distance,
    @JsonKey(name: "gait_type") int? gaitType,
    @JsonKey(name: "foot_strike_l") num? footStrikeL,
    @JsonKey(name: "foot_strike_r") num? footStrikeR,
    @JsonKey(name: "pronation_l") num? pronationL,
    @JsonKey(name: "pronation_r") num? pronationR,
    @JsonKey(name: "stride_l") num? strideL,
    @JsonKey(name: "stride_r") num? strideR,
    @JsonKey(name: "cadence_l") num? cadenceL,
    @JsonKey(name: "cadence_r") num? cadenceR,
    @JsonKey(name: "landing_time_l") num? landingTimeL,
    @JsonKey(name: "landing_time_r") num? landingTimeR,
    @JsonKey(name: "stride_height_l") num? strideHeightL,
    @JsonKey(name: "stride_height_r") num? strideHeightR,
    @JsonKey(name: "landing_force_l") num? landingForceL,
    @JsonKey(name: "landing_force_r") num? landingForceR,
    @JsonKey(name: "swing_phase_duration_l") num? swingPhaseDurationL,
    @JsonKey(name: "swing_phase_duration_r") num? swingPhaseDurationR,
    @JsonKey(name: "toe_off_angle_l") num? toeOffAngleL,
    @JsonKey(name: "toe_off_angle_r") num? toeOffAngleR,
    @JsonKey(name: "cyclic_stride_file_l") String? cyclicStrideFileL,
    @JsonKey(name: "cyclic_stride_file_r") String? cyclicStrideFileR,
    @JsonKey(name: "gait_analysis_file_l") String? gaitAnalysisFileL,
    @JsonKey(name: "gait_analysis_file_r") String? gaitAnalysisFileR,
    @JsonKey(name: "gaitanalysis_status") num? gaitanalysisStatus,
  }) = _RecordGaitAnalysisGet;

  factory RecordGaitAnalysisGet.fromJson(Map<String, Object?> json) =>
      _$RecordGaitAnalysisGetFromJson(json);
}

@freezed
class RecordAnalysisPost with _$RecordAnalysisPost {
  const factory RecordAnalysisPost({
    @JsonKey(name: "analysis") int? analysis,
    @JsonKey(name: "status") int? status,
  }) = _RecordAnalysisPost;

  factory RecordAnalysisPost.fromJson(Map<String, Object?> json) =>
      _$RecordAnalysisPostFromJson(json);
}

@freezed
class RecordAnalysisGet with _$RecordAnalysisGet {
  const factory RecordAnalysisGet({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "t_record_measurement_id") int? tRecordMeasurementId,
    @JsonKey(name: "analysis") int? analysis,
    @JsonKey(name: "status") int? status,
  }) = _RecordAnalysisGet;

  factory RecordAnalysisGet.fromJson(Map<String, Object?> json) =>
      _$RecordAnalysisGetFromJson(json);
}

@freezed
class RecordDataPut with _$RecordDataPut {
  const factory RecordDataPut({
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "intdash_measurement_uuid") String? intdashMeasurementUuid,
    @JsonKey(name: "record_datetime_from") String? recordDatetimeFrom,
    @JsonKey(name: "record_datetime_to") String? recordDatetimeTo,
    @JsonKey(name: "record_name") String? recordName,
    @JsonKey(name: "pace") num? pace,
    @JsonKey(name: "distance") num? distance,
    @JsonKey(name: "gait_type") int? gaitType,
    @JsonKey(name: "foot_strike_l") num? footStrikeL,
    @JsonKey(name: "foot_strike_r") num? footStrikeR,
    @JsonKey(name: "pronation_l") num? pronationL,
    @JsonKey(name: "pronation_r") num? pronationR,
    @JsonKey(name: "stride_l") num? strideL,
    @JsonKey(name: "stride_r") num? strideR,
    @JsonKey(name: "cadence_l") num? cadenceL,
    @JsonKey(name: "cadence_r") num? cadenceR,
    @JsonKey(name: "landing_time_l") num? landingTimeL,
    @JsonKey(name: "landing_time_r") num? landingTimeR,
    @JsonKey(name: "stride_height_l") num? strideHeightL,
    @JsonKey(name: "stride_height_r") num? strideHeightR,
    @JsonKey(name: "landing_force_l") num? landingForceL,
    @JsonKey(name: "landing_force_r") num? landingForceR,
    @JsonKey(name: "swing_phase_duration_l") num? swingPhaseDurationL,
    @JsonKey(name: "swing_phase_duration_r") num? swingPhaseDurationR,
    @JsonKey(name: "toe_off_angle_l") num? toeOffAngleL,
    @JsonKey(name: "toe_off_angle_r") num? toeOffAngleR,
    @JsonKey(name: "cyclic_stride_file_l") String? cyclicStrideFileL,
    @JsonKey(name: "cyclic_stride_file_r") String? cyclicStrideFileR,
    @JsonKey(name: "gait_analysis_file_l") String? gaitAnalysisFileL,
    @JsonKey(name: "gait_analysis_file_r") String? gaitAnalysisFileR,
    @JsonKey(name: "gaitanalysis_status") num? gaitanalysisStatus,
  }) = _RecordDataPut;

  factory RecordDataPut.fromJson(Map<String, Object?> json) =>
      _$RecordDataPutFromJson(json);
}

@freezed
class NoteSearchGet with _$NoteSearchGet {
  const factory NoteSearchGet({
    @JsonKey(name: "current_page") int? currentPage,
    @JsonKey(name: "last_page") int? lastPage,
    @JsonKey(name: "per_page") int? perPage,
    @JsonKey(name: "from") int? from,
    @JsonKey(name: "to") int? to,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "first_page_url") String? firstPageUrl,
    @JsonKey(name: "prev_page_url") String? prevPageUrl,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "last_page_url") String? lastPageUrl,
    @JsonKey(name: "path") String? path,
    @Default([]) @JsonKey(name: "data") List<NoteSearchGetData> data,
  }) = _NoteSearchGet;

  factory NoteSearchGet.fromJson(Map<String, Object?> json) =>
      _$NoteSearchGetFromJson(json);
}

@freezed
class NoteGet with _$NoteGet {
  const factory NoteGet({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _NoteGet;

  factory NoteGet.fromJson(Map<String, Object?> json) =>
      _$NoteGetFromJson(json);
}

@freezed
class NotePost with _$NotePost {
  const factory NotePost({@JsonKey(name: "note") String? note}) = _NotePost;

  factory NotePost.fromJson(Map<String, Object?> json) =>
      _$NotePostFromJson(json);
}

@freezed
class NotePut with _$NotePut {
  const factory NotePut({@JsonKey(name: "note") String? note}) = _NotePut;

  factory NotePut.fromJson(Map<String, Object?> json) =>
      _$NotePutFromJson(json);
}

@freezed
class TagGet with _$TagGet {
  const factory TagGet({
    @JsonKey(name: "current_page") int? currentPage,
    @JsonKey(name: "last_page") int? lastPage,
    @JsonKey(name: "per_page") int? perPage,
    @JsonKey(name: "from") int? from,
    @JsonKey(name: "to") int? to,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "first_page_url") String? firstPageUrl,
    @JsonKey(name: "prev_page_url") String? prevPageUrl,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "last_page_url") String? lastPageUrl,
    @JsonKey(name: "path") String? path,
    @Default([]) @JsonKey(name: "data") List<TagGetData> data,
  }) = _TagGet;

  factory TagGet.fromJson(Map<String, Object?> json) => _$TagGetFromJson(json);
}

@freezed
class TagGetData with _$TagGetData {
  const factory TagGetData({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_office_id") int? mOfficeId,
    @JsonKey(name: "tag_name") String? tagName,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _TagGetData;

  factory TagGetData.fromJson(Map<String, Object?> json) =>
      _$TagGetDataFromJson(json);
}

@freezed
class TagPost with _$TagPost {
  const factory TagPost({
    @JsonKey(name: "m_office_id") int? mOfficeId,
    @JsonKey(name: "tag_name") String? tagName,
  }) = _TagPost;

  factory TagPost.fromJson(Map<String, Object?> json) =>
      _$TagPostFromJson(json);
}

@freezed
class TagPut with _$TagPut {
  const factory TagPut({@JsonKey(name: "tag_name") String? tagName}) = _TagPut;

  factory TagPut.fromJson(Map<String, Object?> json) => _$TagPutFromJson(json);
}

@freezed
class TagSetPost with _$TagSetPost {
  const factory TagSetPost({
    @JsonKey(name: "t_record_measurement_sessions_id")
        int? tRecordMeasurementSessionsId,
    @Default([]) @JsonKey(name: "m_tag_id") List<int> mTagId,
  }) = _TagSetPost;

  factory TagSetPost.fromJson(Map<String, Object?> json) =>
      _$TagSetPostFromJson(json);
}

@freezed
class RecordMeasurementSessionTagSetPost
    with _$RecordMeasurementSessionTagSetPost {
  const factory RecordMeasurementSessionTagSetPost({
    @JsonKey(name: "t_record_measurement_id") int? tRecordMeasurementId,
    @Default([]) @JsonKey(name: "m_tag_id") List<int> mTagId,
  }) = _RecordMeasurementSessionTagSetPost;

  factory RecordMeasurementSessionTagSetPost.fromJson(
          Map<String, Object?> json) =>
      _$RecordMeasurementSessionTagSetPostFromJson(json);
}

@freezed
class GaitAnalysisPost with _$GaitAnalysisPost {
  const factory GaitAnalysisPost({
    @JsonKey(name: "type") required String type,
    @JsonKey(name: "url") required String url,
    @JsonKey(name: "t_record_core_id") required List<int> tRecordCoreId,
    @JsonKey(name: "t_record_measurement_id") int? tRecordMeasurementId,
    @JsonKey(name: "m_member_id") required int mMemberId,
    @JsonKey(name: "m_office_id") int? mOfficeId,
    @JsonKey(name: "measurement_uuid") required String measurementUuid,
    @JsonKey(name: "edge_token") String? edgeToken,
    @JsonKey(name: "src_edge_uuid") String? srcEdgeUuid,
    @JsonKey(name: "dest_edge_uuid") String? destEdgeUuid,
    @JsonKey(name: "nats_server") String? natsServer,
    @JsonKey(name: "nats_user") String? natsUser,
    @JsonKey(name: "nats_pass") String? natsPass,
    @JsonKey(name: "side") required String side,
    @JsonKey(name: "height") num? height,
    @JsonKey(name: "mass") num? mass,
    @JsonKey(name: "channel") int? channel,
    @JsonKey(name: "left_channel") int? leftChannel,
    @JsonKey(name: "right_channel") int? rightChannel,
    @JsonKey(name: "path") String? path,
    @JsonKey(name: "left_path") String? leftPath,
    @JsonKey(name: "right_path") String? rightPath,
  }) = _GaitAnalysisPost;

  factory GaitAnalysisPost.fromJson(Map<String, Object?> json) =>
      _$GaitAnalysisPostFromJson(json);
}

@freezed
class GaitAnalysisStatusPost with _$GaitAnalysisStatusPost {
  const factory GaitAnalysisStatusPost(
          {@JsonKey(name: "executionArn") required String executionArn}) =
      _GaitAnalysisStatusPost;

  factory GaitAnalysisStatusPost.fromJson(Map<String, Object?> json) =>
      _$GaitAnalysisStatusPostFromJson(json);
}

@freezed
class GaitAnalysisStatus with _$GaitAnalysisStatus {
  const factory GaitAnalysisStatus({
    @JsonKey(name: "executionArn") String? executionArn,
    @JsonKey(name: "input") String? input,
    @JsonKey(name: "inputDetails") GaitAnalysisStatusInputDetails? inputDetails,
    @JsonKey(name: "output") String? output,
    @JsonKey(name: "outputDetails")
        GaitAnalysisStatusOutputDetails? outputDetails,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "startDate") num? startDate,
    @JsonKey(name: "stateMachineArn") String? stateMachineArn,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "stopDate") num? stopDate,
    @JsonKey(name: "traceHeader") String? traceHeader,
  }) = _GaitAnalysisStatus;

  factory GaitAnalysisStatus.fromJson(Map<String, Object?> json) =>
      _$GaitAnalysisStatusFromJson(json);
}

@freezed
class TfPosePost with _$TfPosePost {
  const factory TfPosePost({
    @JsonKey(name: "url") required String url,
    @JsonKey(name: "uuid") required String uuid,
    @JsonKey(name: "edge_token") required String edgeToken,
  }) = _TfPosePost;

  factory TfPosePost.fromJson(Map<String, Object?> json) =>
      _$TfPosePostFromJson(json);
}

@freezed
class EdgeAvailableGet with _$EdgeAvailableGet {
  const factory EdgeAvailableGet({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "edge_uuid") String? edgeUuid,
    @JsonKey(name: "intdash_measurement_uuid") String? intdashMeasurementUuid,
    @JsonKey(name: "start_datetime") String? startDatetime,
    @JsonKey(name: "end_datetime") String? endDatetime,
    @JsonKey(name: "batch_end_flg") num? batchEndFlg,
  }) = _EdgeAvailableGet;

  factory EdgeAvailableGet.fromJson(Map<String, Object?> json) =>
      _$EdgeAvailableGetFromJson(json);
}

@freezed
class EdgeAvailablePost with _$EdgeAvailablePost {
  const factory EdgeAvailablePost({
    @JsonKey(name: "edge_uuid") required String edgeUuid,
    @JsonKey(name: "intdash_measurement_uuid")
        required String intdashMeasurementUuid,
    @JsonKey(name: "start_datetime") String? startDatetime,
    @JsonKey(name: "end_datetime") String? endDatetime,
    @JsonKey(name: "batch_end_flg") num? batchEndFlg,
  }) = _EdgeAvailablePost;

  factory EdgeAvailablePost.fromJson(Map<String, Object?> json) =>
      _$EdgeAvailablePostFromJson(json);
}

@freezed
class EdgeAvailablePut with _$EdgeAvailablePut {
  const factory EdgeAvailablePut({
    @JsonKey(name: "edge_uuid") required String edgeUuid,
    @JsonKey(name: "intdash_measurement_uuid")
        required String intdashMeasurementUuid,
    @JsonKey(name: "start_datetime") String? startDatetime,
    @JsonKey(name: "end_datetime") String? endDatetime,
    @JsonKey(name: "batch_end_flg") num? batchEndFlg,
  }) = _EdgeAvailablePut;

  factory EdgeAvailablePut.fromJson(Map<String, Object?> json) =>
      _$EdgeAvailablePutFromJson(json);
}

@freezed
class OfficeIntdashUserGet with _$OfficeIntdashUserGet {
  const factory OfficeIntdashUserGet({
    @JsonKey(name: "current_page") int? currentPage,
    @JsonKey(name: "last_page") int? lastPage,
    @JsonKey(name: "per_page") int? perPage,
    @JsonKey(name: "from") int? from,
    @JsonKey(name: "to") int? to,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "first_page_url") String? firstPageUrl,
    @JsonKey(name: "prev_page_url") String? prevPageUrl,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "last_page_url") String? lastPageUrl,
    @JsonKey(name: "path") String? path,
    @Default([]) @JsonKey(name: "data") List<OfficeIntdashUserGetData> data,
  }) = _OfficeIntdashUserGet;

  factory OfficeIntdashUserGet.fromJson(Map<String, Object?> json) =>
      _$OfficeIntdashUserGetFromJson(json);
}

@freezed
class OfficeIntdashUser with _$OfficeIntdashUser {
  const factory OfficeIntdashUser({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_office_id") int? mOfficeId,
    @JsonKey(name: "uuid") String? uuid,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "api_token") String? apiToken,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _OfficeIntdashUser;

  factory OfficeIntdashUser.fromJson(Map<String, Object?> json) =>
      _$OfficeIntdashUserFromJson(json);
}

@freezed
class RuleRecord with _$RuleRecord {
  const factory RuleRecord({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "m_indicator_id") int? mIndicatorId,
    @JsonKey(name: "rule") String? rule,
    @JsonKey(name: "priority") int? priority,
    @JsonKey(name: "indicator") RuleIndicatorRecord? indicator,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _RuleRecord;

  factory RuleRecord.fromJson(Map<String, Object?> json) =>
      _$RuleRecordFromJson(json);
}

@freezed
class RuleIndicatorRecord with _$RuleIndicatorRecord {
  const factory RuleIndicatorRecord({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _RuleIndicatorRecord;

  factory RuleIndicatorRecord.fromJson(Map<String, Object?> json) =>
      _$RuleIndicatorRecordFromJson(json);
}

@freezed
class RuleMessageRecord with _$RuleMessageRecord {
  const factory RuleMessageRecord({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_rule_id") int? mRuleId,
    @JsonKey(name: "m_communication_type_id") int? mCommunicationTypeId,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "rule") RuleRecord? rule,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _RuleMessageRecord;

  factory RuleMessageRecord.fromJson(Map<String, Object?> json) =>
      _$RuleMessageRecordFromJson(json);
}

@freezed
class CommunicationTypeRecord with _$CommunicationTypeRecord {
  const factory CommunicationTypeRecord({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _CommunicationTypeRecord;

  factory CommunicationTypeRecord.fromJson(Map<String, Object?> json) =>
      _$CommunicationTypeRecordFromJson(json);
}

@freezed
class NoticeGet with _$NoticeGet {
  const factory NoticeGet({
    @JsonKey(name: "current_page") int? currentPage,
    @JsonKey(name: "last_page") int? lastPage,
    @JsonKey(name: "per_page") int? perPage,
    @JsonKey(name: "from") int? from,
    @JsonKey(name: "to") int? to,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "path") String? path,
    @Default([]) @JsonKey(name: "data") List<NoticeGetData> data,
  }) = _NoticeGet;

  factory NoticeGet.fromJson(Map<String, Object?> json) =>
      _$NoticeGetFromJson(json);
}

@freezed
class NoticePut with _$NoticePut {
  const factory NoticePut({
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "m_rule_id") int? mRuleId,
    @JsonKey(name: "m_rule_message_id") int? mRuleMessageId,
    @JsonKey(name: "noticed") bool? noticed,
  }) = _NoticePut;

  factory NoticePut.fromJson(Map<String, Object?> json) =>
      _$NoticePutFromJson(json);
}

@freezed
class RecordMeasurementSessionGet with _$RecordMeasurementSessionGet {
  const factory RecordMeasurementSessionGet({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "record_measurement_session_uuid")
        String? recordMeasurementSessionUuid,
    @JsonKey(name: "measurement_type") int? measurementType,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "comment_advise") String? commentAdvise,
    @JsonKey(name: "comment_result") String? commentResult,
    @JsonKey(name: "analysis_summary_data")
        AnalysisSummaryData? analysisSummaryData,
    @Default([])
    @JsonKey(name: "record_measurement")
        List<RecordMeasurementSessionGetRecordMeasurement> recordMeasurement,
  }) = _RecordMeasurementSessionGet;

  factory RecordMeasurementSessionGet.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementSessionGetFromJson(json);
}

@freezed
class RecordMeasurementSessionPost with _$RecordMeasurementSessionPost {
  const factory RecordMeasurementSessionPost({
    @JsonKey(name: "record_measurement_session_uuid")
        required String recordMeasurementSessionUuid,
    @JsonKey(name: "measurement_type") required int measurementType,
    @JsonKey(name: "m_member_id") required int mMemberId,
    @JsonKey(name: "comment_advise") String? commentAdvise,
    @JsonKey(name: "comment_result") String? commentResult,
  }) = _RecordMeasurementSessionPost;

  factory RecordMeasurementSessionPost.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementSessionPostFromJson(json);
}

@freezed
class AnalysisData with _$AnalysisData {
  const factory AnalysisData({
    @JsonKey(name: "record_data_id") String? recordDataId,
    @JsonKey(name: "analysis_type") int? analysisType,
    @JsonKey(name: "pace") num? pace,
    @JsonKey(name: "distance") num? distance,
    @JsonKey(name: "gait_type") int? gaitType,
    @JsonKey(name: "foot_strike_l") num? footStrikeL,
    @JsonKey(name: "foot_strike_r") num? footStrikeR,
    @JsonKey(name: "pronation_l") num? pronationL,
    @JsonKey(name: "pronation_r") num? pronationR,
    @JsonKey(name: "stride_l") num? strideL,
    @JsonKey(name: "stride_r") num? strideR,
    @JsonKey(name: "cadence_l") num? cadenceL,
    @JsonKey(name: "cadence_r") num? cadenceR,
    @JsonKey(name: "landing_time_l") num? landingTimeL,
    @JsonKey(name: "landing_time_r") num? landingTimeR,
    @JsonKey(name: "stride_height_l") num? strideHeightL,
    @JsonKey(name: "stride_height_r") num? strideHeightR,
    @JsonKey(name: "landing_force_l") num? landingForceL,
    @JsonKey(name: "landing_force_r") num? landingForceR,
    @JsonKey(name: "swing_phase_duration_l") num? swingPhaseDurationL,
    @JsonKey(name: "swing_phase_duration_r") num? swingPhaseDurationR,
    @JsonKey(name: "toe_off_angle_l") num? toeOffAngleL,
    @JsonKey(name: "toe_off_angle_r") num? toeOffAngleR,
    @JsonKey(name: "cyclic_stride_file_l") String? cyclicStrideFileL,
    @JsonKey(name: "cyclic_stride_file_r") String? cyclicStrideFileR,
    @JsonKey(name: "gait_analysis_file_l") String? gaitAnalysisFileL,
    @JsonKey(name: "gait_analysis_file_r") String? gaitAnalysisFileR,
    @JsonKey(name: "gaitanalysis_status") num? gaitanalysisStatus,
  }) = _AnalysisData;

  factory AnalysisData.fromJson(Map<String, Object?> json) =>
      _$AnalysisDataFromJson(json);
}

@freezed
class AnalysisSummaryData with _$AnalysisSummaryData {
  const factory AnalysisSummaryData({
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "sort_id") String? sortId,
    @JsonKey(name: "aggregate_type") String? aggregateType,
    @JsonKey(name: "aggregate_conds") String? aggregateConds,
    @JsonKey(name: "measurement_type") int? measurementType,
    @JsonKey(name: "record_from") String? recordFrom,
    @JsonKey(name: "record_to") String? recordTo,
    @JsonKey(name: "gait_type") int? gaitType,
    @JsonKey(name: "pace") SummaryStandard? pace,
    @JsonKey(name: "distance") SummaryStandard? distance,
    @JsonKey(name: "foot_strike_l") SummaryStandard? footStrikeL,
    @JsonKey(name: "foot_strike_r") SummaryStandard? footStrikeR,
    @JsonKey(name: "pronation_l") SummaryStandard? pronationL,
    @JsonKey(name: "pronation_r") SummaryStandard? pronationR,
    @JsonKey(name: "stride_l") SummaryStandard? strideL,
    @JsonKey(name: "stride_r") SummaryStandard? strideR,
    @JsonKey(name: "cadence_l") SummaryStandard? cadenceL,
    @JsonKey(name: "cadence_r") SummaryStandard? cadenceR,
    @JsonKey(name: "landing_time_l") SummaryStandard? landingTimeL,
    @JsonKey(name: "landing_time_r") SummaryStandard? landingTimeR,
    @JsonKey(name: "stride_height_l") SummaryStandard? strideHeightL,
    @JsonKey(name: "stride_height_r") SummaryStandard? strideHeightR,
    @JsonKey(name: "landing_force_l") SummaryStandard? landingForceL,
    @JsonKey(name: "landing_force_r") SummaryStandard? landingForceR,
    @JsonKey(name: "swing_phase_duration_l")
        SummaryStandard? swingPhaseDurationL,
    @JsonKey(name: "swing_phase_duration_r")
        SummaryStandard? swingPhaseDurationR,
    @JsonKey(name: "toe_off_angle_l") SummaryStandard? toeOffAngleL,
    @JsonKey(name: "toe_off_angle_r") SummaryStandard? toeOffAngleR,
    @JsonKey(name: "summmary_datetime") String? summmaryDatetime,
  }) = _AnalysisSummaryData;

  factory AnalysisSummaryData.fromJson(Map<String, Object?> json) =>
      _$AnalysisSummaryDataFromJson(json);
}

@freezed
class SummaryStandard with _$SummaryStandard {
  const factory SummaryStandard({
    @JsonKey(name: "avg") num? avg,
    @JsonKey(name: "max") num? max,
    @JsonKey(name: "min") num? min,
    @JsonKey(name: "med") num? med,
  }) = _SummaryStandard;

  factory SummaryStandard.fromJson(Map<String, Object?> json) =>
      _$SummaryStandardFromJson(json);
}

@freezed
class ErrorErrors with _$ErrorErrors {
  const factory ErrorErrors() = _ErrorErrors;

  factory ErrorErrors.fromJson(Map<String, Object?> json) =>
      _$ErrorErrorsFromJson(json);
}

@freezed
class OfficeRecordPivot with _$OfficeRecordPivot {
  const factory OfficeRecordPivot({
    @JsonKey(name: "m_company_user_id") int? mCompanyUserId,
    @JsonKey(name: "m_office_id") int? mOfficeId,
  }) = _OfficeRecordPivot;

  factory OfficeRecordPivot.fromJson(Map<String, Object?> json) =>
      _$OfficeRecordPivotFromJson(json);
}

@freezed
class RoleRecordPivot with _$RoleRecordPivot {
  const factory RoleRecordPivot({
    @JsonKey(name: "m_login_account_id") int? mLoginAccountId,
    @JsonKey(name: "m_role_id") int? mRoleId,
  }) = _RoleRecordPivot;

  factory RoleRecordPivot.fromJson(Map<String, Object?> json) =>
      _$RoleRecordPivotFromJson(json);
}

@freezed
class RoleRecordPermissions with _$RoleRecordPermissions {
  const factory RoleRecordPermissions({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "permission_name") String? permissionName,
    @Default([]) @JsonKey(name: "pivot") List<PermissionRecordPivot> pivot,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _RoleRecordPermissions;

  factory RoleRecordPermissions.fromJson(Map<String, Object?> json) =>
      _$RoleRecordPermissionsFromJson(json);
}

@freezed
class PermissionRecordPivot with _$PermissionRecordPivot {
  const factory PermissionRecordPivot({
    @JsonKey(name: "m_role_id") int? mRoleId,
    @JsonKey(name: "m_permission_id") int? mPermissionId,
  }) = _PermissionRecordPivot;

  factory PermissionRecordPivot.fromJson(Map<String, Object?> json) =>
      _$PermissionRecordPivotFromJson(json);
}

@freezed
class MemberSearchRecordGetData with _$MemberSearchRecordGetData {
  const factory MemberSearchRecordGetData({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_office_id") int? mOfficeId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "name_kana") String? nameKana,
    @JsonKey(name: "gender") int? gender,
    @JsonKey(name: "birth_date") String? birthDate,
    @JsonKey(name: "height") num? height,
    @JsonKey(name: "weight") num? weight,
    @Default([])
    @JsonKey(name: "member_edges")
        List<MemberRecordGetMemberEdges> memberEdges,
    @Default([])
    @JsonKey(name: "member_links")
        List<MemberRecordGetMemberLinks> memberLinks,
    @Default([])
    @JsonKey(name: "record_measurement_sessions")
        List<MemberRecordGetRecordMeasurementSessions>
            recordMeasurementSessions,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "deleted_at") String? deletedAt,
  }) = _MemberSearchRecordGetData;

  factory MemberSearchRecordGetData.fromJson(Map<String, Object?> json) =>
      _$MemberSearchRecordGetDataFromJson(json);
}

@freezed
class MemberRecordGetMemberEdges with _$MemberRecordGetMemberEdges {
  const factory MemberRecordGetMemberEdges({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "edge_uuid") String? edgeUuid,
  }) = _MemberRecordGetMemberEdges;

  factory MemberRecordGetMemberEdges.fromJson(Map<String, Object?> json) =>
      _$MemberRecordGetMemberEdgesFromJson(json);
}

@freezed
class MemberRecordGetMemberLinks with _$MemberRecordGetMemberLinks {
  const factory MemberRecordGetMemberLinks({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "link_service") int? linkService,
    @JsonKey(name: "link_data") MemberLinkGetLinkData? linkData,
  }) = _MemberRecordGetMemberLinks;

  factory MemberRecordGetMemberLinks.fromJson(Map<String, Object?> json) =>
      _$MemberRecordGetMemberLinksFromJson(json);
}

@freezed
class MemberRecordGetRecordMeasurementSessions
    with _$MemberRecordGetRecordMeasurementSessions {
  const factory MemberRecordGetRecordMeasurementSessions({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "record_measurement_session_uuid")
        String? recordMeasurementSessionUuid,
    @JsonKey(name: "measurement_type") int? measurementType,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "comment_advise") String? commentAdvise,
    @JsonKey(name: "comment_result") String? commentResult,
    @JsonKey(name: "analysis_summary_data")
        AnalysisSummaryData? analysisSummaryData,
    @Default([])
    @JsonKey(name: "record_measurement")
        List<RecordMeasurementSessionGetRecordMeasurement> recordMeasurement,
  }) = _MemberRecordGetRecordMeasurementSessions;

  factory MemberRecordGetRecordMeasurementSessions.fromJson(
          Map<String, Object?> json) =>
      _$MemberRecordGetRecordMeasurementSessionsFromJson(json);
}

@freezed
class MemberLinkGetLinkData with _$MemberLinkGetLinkData {
  const factory MemberLinkGetLinkData({
    @JsonKey(name: "data_lake_token") String? dataLakeToken,
    @JsonKey(name: "data_lake_refresh_token") String? dataLakeRefreshToken,
    @JsonKey(name: "orphe_id") String? orpheId,
    @JsonKey(name: "tenant_id") String? tenantId,
  }) = _MemberLinkGetLinkData;

  factory MemberLinkGetLinkData.fromJson(Map<String, Object?> json) =>
      _$MemberLinkGetLinkDataFromJson(json);
}

@freezed
class MemberLinkPostLinkData with _$MemberLinkPostLinkData {
  const factory MemberLinkPostLinkData({
    @JsonKey(name: "data_lake_token") String? dataLakeToken,
    @JsonKey(name: "data_lake_refresh_token") String? dataLakeRefreshToken,
    @JsonKey(name: "orphe_id") String? orpheId,
    @JsonKey(name: "tenant_id") String? tenantId,
  }) = _MemberLinkPostLinkData;

  factory MemberLinkPostLinkData.fromJson(Map<String, Object?> json) =>
      _$MemberLinkPostLinkDataFromJson(json);
}

@freezed
class MemberLinkPutLinkData with _$MemberLinkPutLinkData {
  const factory MemberLinkPutLinkData({
    @JsonKey(name: "data_lake_token") String? dataLakeToken,
    @JsonKey(name: "data_lake_refresh_token") String? dataLakeRefreshToken,
    @JsonKey(name: "orphe_id") String? orpheId,
    @JsonKey(name: "tenant_id") String? tenantId,
  }) = _MemberLinkPutLinkData;

  factory MemberLinkPutLinkData.fromJson(Map<String, Object?> json) =>
      _$MemberLinkPutLinkDataFromJson(json);
}

@freezed
class RecordMeasurementSearchGetData with _$RecordMeasurementSearchGetData {
  const factory RecordMeasurementSearchGetData({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "record_data_id") String? recordDataId,
    @JsonKey(name: "intdash_measurement_uuid") String? intdashMeasurementUuid,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "record_datetime_from") String? recordDatetimeFrom,
    @JsonKey(name: "record_datetime_to") String? recordDatetimeTo,
    @JsonKey(name: "record_name") String? recordName,
    @Default([])
    @JsonKey(name: "record_core")
        List<RecordMeasurementGetRecordCore> recordCore,
    @JsonKey(name: "analysis_data") AnalysisData? analysisData,
    @Default([]) @JsonKey(name: "tags") List<RecordMeasurementGetTags> tags,
  }) = _RecordMeasurementSearchGetData;

  factory RecordMeasurementSearchGetData.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementSearchGetDataFromJson(json);
}

@freezed
class RecordMeasurementSessionSearchGetData
    with _$RecordMeasurementSessionSearchGetData {
  const factory RecordMeasurementSessionSearchGetData({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "record_measurement_session_uuid")
        String? recordMeasurementSessionUuid,
    @JsonKey(name: "measurement_type") int? measurementType,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "comment_advise") String? commentAdvise,
    @JsonKey(name: "comment_result") String? commentResult,
    @JsonKey(name: "analysis_summary_data")
        AnalysisSummaryData? analysisSummaryData,
    @Default([])
    @JsonKey(name: "record_measurement")
        List<RecordMeasurementSessionGetRecordMeasurement> recordMeasurement,
  }) = _RecordMeasurementSessionSearchGetData;

  factory RecordMeasurementSessionSearchGetData.fromJson(
          Map<String, Object?> json) =>
      _$RecordMeasurementSessionSearchGetDataFromJson(json);
}

@freezed
class RecordDataGetTags with _$RecordDataGetTags {
  const factory RecordDataGetTags({
    @JsonKey(name: "current_page") int? currentPage,
    @JsonKey(name: "last_page") int? lastPage,
    @JsonKey(name: "per_page") int? perPage,
    @JsonKey(name: "from") int? from,
    @JsonKey(name: "to") int? to,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "first_page_url") String? firstPageUrl,
    @JsonKey(name: "prev_page_url") String? prevPageUrl,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "last_page_url") String? lastPageUrl,
    @JsonKey(name: "path") String? path,
    @Default([]) @JsonKey(name: "data") List<TagGetData> data,
  }) = _RecordDataGetTags;

  factory RecordDataGetTags.fromJson(Map<String, Object?> json) =>
      _$RecordDataGetTagsFromJson(json);
}

@freezed
class RecordMeasurementPostRecordCore with _$RecordMeasurementPostRecordCore {
  const factory RecordMeasurementPostRecordCore({
    @JsonKey(name: "core_type") int? coreType,
    @JsonKey(name: "core_version") String? coreVersion,
    @JsonKey(name: "firmware_version") String? firmwareVersion,
    @JsonKey(name: "m_measurement_part_id") int? mMeasurementPartId,
    @JsonKey(name: "intdash_measurement_channel")
        int? intdashMeasurementChannel,
    @JsonKey(name: "m_device_id") int? mDeviceId,
  }) = _RecordMeasurementPostRecordCore;

  factory RecordMeasurementPostRecordCore.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementPostRecordCoreFromJson(json);
}

@freezed
class RecordMeasurementGetRecordCore with _$RecordMeasurementGetRecordCore {
  const factory RecordMeasurementGetRecordCore({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "core_type") int? coreType,
    @JsonKey(name: "core_version") String? coreVersion,
    @JsonKey(name: "firmware_version") String? firmwareVersion,
    @JsonKey(name: "m_device_id") int? mDeviceId,
    @JsonKey(name: "t_record_measurement_id") int? tRecordMeasurementId,
    @JsonKey(name: "m_measurement_part_id") int? mMeasurementPartId,
    @JsonKey(name: "intdash_measurement_channel")
        int? intdashMeasurementChannel,
    @JsonKey(name: "t_record_gait_analysis_id") int? tRecordGaitAnalysisId,
    @JsonKey(name: "record_gait_analysis")
        RecordGaitAnalysisGet? recordGaitAnalysis,
  }) = _RecordMeasurementGetRecordCore;

  factory RecordMeasurementGetRecordCore.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementGetRecordCoreFromJson(json);
}

@freezed
class RecordMeasurementGetTags with _$RecordMeasurementGetTags {
  const factory RecordMeasurementGetTags({
    @JsonKey(name: "current_page") int? currentPage,
    @JsonKey(name: "last_page") int? lastPage,
    @JsonKey(name: "per_page") int? perPage,
    @JsonKey(name: "from") int? from,
    @JsonKey(name: "to") int? to,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "first_page_url") String? firstPageUrl,
    @JsonKey(name: "prev_page_url") String? prevPageUrl,
    @JsonKey(name: "next_page_url") String? nextPageUrl,
    @JsonKey(name: "last_page_url") String? lastPageUrl,
    @JsonKey(name: "path") String? path,
    @Default([]) @JsonKey(name: "data") List<TagGetData> data,
  }) = _RecordMeasurementGetTags;

  factory RecordMeasurementGetTags.fromJson(Map<String, Object?> json) =>
      _$RecordMeasurementGetTagsFromJson(json);
}

@freezed
class NoteSearchGetData with _$NoteSearchGetData {
  const factory NoteSearchGetData({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "note") String? note,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _NoteSearchGetData;

  factory NoteSearchGetData.fromJson(Map<String, Object?> json) =>
      _$NoteSearchGetDataFromJson(json);
}

@freezed
class GaitAnalysisStatusInputDetails with _$GaitAnalysisStatusInputDetails {
  const factory GaitAnalysisStatusInputDetails(
          {@JsonKey(name: "included") bool? included}) =
      _GaitAnalysisStatusInputDetails;

  factory GaitAnalysisStatusInputDetails.fromJson(Map<String, Object?> json) =>
      _$GaitAnalysisStatusInputDetailsFromJson(json);
}

@freezed
class GaitAnalysisStatusOutputDetails with _$GaitAnalysisStatusOutputDetails {
  const factory GaitAnalysisStatusOutputDetails(
          {@JsonKey(name: "included") bool? included}) =
      _GaitAnalysisStatusOutputDetails;

  factory GaitAnalysisStatusOutputDetails.fromJson(Map<String, Object?> json) =>
      _$GaitAnalysisStatusOutputDetailsFromJson(json);
}

@freezed
class OfficeIntdashUserGetData with _$OfficeIntdashUserGetData {
  const factory OfficeIntdashUserGetData({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "m_office_id") int? mOfficeId,
    @JsonKey(name: "uuid") String? uuid,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "api_token") String? apiToken,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _OfficeIntdashUserGetData;

  factory OfficeIntdashUserGetData.fromJson(Map<String, Object?> json) =>
      _$OfficeIntdashUserGetDataFromJson(json);
}

@freezed
class NoticeGetData with _$NoticeGetData {
  const factory NoticeGetData({
    @JsonKey(name: "member") MemberRecordGet? member,
    @JsonKey(name: "rule_message") RuleMessageRecord? ruleMessage,
    @JsonKey(name: "noticed") bool? noticed,
  }) = _NoticeGetData;

  factory NoticeGetData.fromJson(Map<String, Object?> json) =>
      _$NoticeGetDataFromJson(json);
}

@freezed
class RecordMeasurementSessionGetRecordMeasurement
    with _$RecordMeasurementSessionGetRecordMeasurement {
  const factory RecordMeasurementSessionGetRecordMeasurement({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "record_data_id") String? recordDataId,
    @JsonKey(name: "intdash_measurement_uuid") String? intdashMeasurementUuid,
    @JsonKey(name: "m_member_id") int? mMemberId,
    @JsonKey(name: "record_datetime_from") String? recordDatetimeFrom,
    @JsonKey(name: "record_datetime_to") String? recordDatetimeTo,
    @JsonKey(name: "record_name") String? recordName,
    @Default([])
    @JsonKey(name: "record_core")
        List<RecordMeasurementGetRecordCore> recordCore,
    @JsonKey(name: "analysis_data") AnalysisData? analysisData,
    @Default([]) @JsonKey(name: "tags") List<RecordMeasurementGetTags> tags,
  }) = _RecordMeasurementSessionGetRecordMeasurement;

  factory RecordMeasurementSessionGetRecordMeasurement.fromJson(
          Map<String, Object?> json) =>
      _$RecordMeasurementSessionGetRecordMeasurementFromJson(json);
}
