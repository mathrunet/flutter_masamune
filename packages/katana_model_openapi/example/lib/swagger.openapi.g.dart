// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.openapi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Empty _$$_EmptyFromJson(Map<String, dynamic> json) => _$_Empty();

Map<String, dynamic> _$$_EmptyToJson(_$_Empty instance) => <String, dynamic>{};

_$_Error _$$_ErrorFromJson(Map<String, dynamic> json) => _$_Error(
      errors: json['errors'] == null
          ? null
          : ErrorErrors.fromJson(json['errors'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ErrorToJson(_$_Error instance) => <String, dynamic>{
      'errors': instance.errors,
    };

_$_CompanyRecord _$$_CompanyRecordFromJson(Map<String, dynamic> json) =>
    _$_CompanyRecord(
      id: json['id'] as int,
      name: json['name'] as String,
      owner: json['owner'] as String?,
      zip: json['zip'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      address3: json['address3'] as String?,
      address4: json['address4'] as String?,
      tel: json['tel'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$_CompanyRecordToJson(_$_CompanyRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'owner': instance.owner,
      'zip': instance.zip,
      'address1': instance.address1,
      'address2': instance.address2,
      'address3': instance.address3,
      'address4': instance.address4,
      'tel': instance.tel,
      'email': instance.email,
    };

_$_OfficeRecord _$$_OfficeRecordFromJson(Map<String, dynamic> json) =>
    _$_OfficeRecord(
      id: json['id'] as int?,
      mCompanyId: json['m_company_id'] as int?,
      name: json['name'] as String?,
      owner: json['owner'] as String?,
      zip: json['zip'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      address3: json['address3'] as String?,
      address4: json['address4'] as String?,
      tel: json['tel'] as String?,
      email: json['email'] as String?,
      edgelimit: json['edgelimit'] as int?,
      intdashTenantId: json['intdash_tenant_id'] as String?,
      crmFlg: json['crm_flg'],
      pivot: (json['pivot'] as List<dynamic>?)
              ?.map(
                  (e) => OfficeRecordPivot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_OfficeRecordToJson(_$_OfficeRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_company_id': instance.mCompanyId,
      'name': instance.name,
      'owner': instance.owner,
      'zip': instance.zip,
      'address1': instance.address1,
      'address2': instance.address2,
      'address3': instance.address3,
      'address4': instance.address4,
      'tel': instance.tel,
      'email': instance.email,
      'edgelimit': instance.edgelimit,
      'intdash_tenant_id': instance.intdashTenantId,
      'crm_flg': instance.crmFlg,
      'pivot': instance.pivot,
    };

_$_OfficePivotRecord _$$_OfficePivotRecordFromJson(Map<String, dynamic> json) =>
    _$_OfficePivotRecord(
      mCompanyUserId: json['m_company_user_id'] as int?,
      mOfficeId: json['m_office_id'] as int?,
    );

Map<String, dynamic> _$$_OfficePivotRecordToJson(
        _$_OfficePivotRecord instance) =>
    <String, dynamic>{
      'm_company_user_id': instance.mCompanyUserId,
      'm_office_id': instance.mOfficeId,
    };

_$_RoleRecord _$$_RoleRecordFromJson(Map<String, dynamic> json) =>
    _$_RoleRecord(
      id: json['id'] as int?,
      roleName: json['role_name'] as String?,
      pivot: (json['pivot'] as List<dynamic>?)
              ?.map((e) => RoleRecordPivot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) =>
                  RoleRecordPermissions.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_RoleRecordToJson(_$_RoleRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role_name': instance.roleName,
      'pivot': instance.pivot,
      'permissions': instance.permissions,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_PermissionRecord _$$_PermissionRecordFromJson(Map<String, dynamic> json) =>
    _$_PermissionRecord(
      id: json['id'] as int?,
      permissionName: json['permission_name'] as String?,
      pivot: (json['pivot'] as List<dynamic>?)
              ?.map((e) =>
                  PermissionRecordPivot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_PermissionRecordToJson(_$_PermissionRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'permission_name': instance.permissionName,
      'pivot': instance.pivot,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_RolePivotRecord _$$_RolePivotRecordFromJson(Map<String, dynamic> json) =>
    _$_RolePivotRecord(
      mLoginAccountId: json['m_login_account_id'] as int?,
      mRoleId: json['m_role_id'] as int?,
    );

Map<String, dynamic> _$$_RolePivotRecordToJson(_$_RolePivotRecord instance) =>
    <String, dynamic>{
      'm_login_account_id': instance.mLoginAccountId,
      'm_role_id': instance.mRoleId,
    };

_$_PermissionPivotRecord _$$_PermissionPivotRecordFromJson(
        Map<String, dynamic> json) =>
    _$_PermissionPivotRecord(
      mRoleId: json['m_role_id'] as int?,
      mPermissionId: json['m_permission_id'] as int?,
    );

Map<String, dynamic> _$$_PermissionPivotRecordToJson(
        _$_PermissionPivotRecord instance) =>
    <String, dynamic>{
      'm_role_id': instance.mRoleId,
      'm_permission_id': instance.mPermissionId,
    };

_$_MemberSearchRecordGet _$$_MemberSearchRecordGetFromJson(
        Map<String, dynamic> json) =>
    _$_MemberSearchRecordGet(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
      firstPageUrl: json['first_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
      lastPageUrl: json['last_page_url'] as String?,
      path: json['path'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) =>
                  MemberSearchRecordGetData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_MemberSearchRecordGetToJson(
        _$_MemberSearchRecordGet instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'first_page_url': instance.firstPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'next_page_url': instance.nextPageUrl,
      'last_page_url': instance.lastPageUrl,
      'path': instance.path,
      'data': instance.data,
    };

_$_MemberRecordGet _$$_MemberRecordGetFromJson(Map<String, dynamic> json) =>
    _$_MemberRecordGet(
      id: json['id'] as int?,
      mOfficeId: json['m_office_id'] as int?,
      name: json['name'] as String?,
      nameKana: json['name_kana'] as String?,
      gender: json['gender'] as int?,
      birthDate: json['birth_date'] as String?,
      height: json['height'] as num?,
      weight: json['weight'] as num?,
      memberEdges: (json['member_edges'] as List<dynamic>?)
              ?.map((e) => MemberRecordGetMemberEdges.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      memberLinks: (json['member_links'] as List<dynamic>?)
              ?.map((e) => MemberRecordGetMemberLinks.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      recordMeasurementSessions: (json['record_measurement_sessions']
                  as List<dynamic>?)
              ?.map((e) => MemberRecordGetRecordMeasurementSessions.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );

Map<String, dynamic> _$$_MemberRecordGetToJson(_$_MemberRecordGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_office_id': instance.mOfficeId,
      'name': instance.name,
      'name_kana': instance.nameKana,
      'gender': instance.gender,
      'birth_date': instance.birthDate,
      'height': instance.height,
      'weight': instance.weight,
      'member_edges': instance.memberEdges,
      'member_links': instance.memberLinks,
      'record_measurement_sessions': instance.recordMeasurementSessions,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
    };

_$_MemberEdge _$$_MemberEdgeFromJson(Map<String, dynamic> json) =>
    _$_MemberEdge(
      id: json['id'] as int?,
      mMemberId: json['m_member_id'] as int?,
      edgeUuid: json['edge_uuid'] as String?,
    );

Map<String, dynamic> _$$_MemberEdgeToJson(_$_MemberEdge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_member_id': instance.mMemberId,
      'edge_uuid': instance.edgeUuid,
    };

_$_MemberEdgeUsage _$$_MemberEdgeUsageFromJson(Map<String, dynamic> json) =>
    _$_MemberEdgeUsage(
      id: json['id'] as int?,
      mMemberId: json['m_member_id'] as int?,
      edgeUuid: json['edge_uuid'] as String?,
      member: json['member'] == null
          ? null
          : MemberRecordGet.fromJson(json['member'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_MemberEdgeUsageToJson(_$_MemberEdgeUsage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_member_id': instance.mMemberId,
      'edge_uuid': instance.edgeUuid,
      'member': instance.member,
    };

_$_OfficePost _$$_OfficePostFromJson(Map<String, dynamic> json) =>
    _$_OfficePost(
      mCompanyId: json['m_company_id'] as int,
      name: json['name'] as String,
      owner: json['owner'] as String?,
      zip: json['zip'] as int?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      address3: json['address3'] as String?,
      address4: json['address4'] as String?,
      tel: json['tel'] as String?,
      email: json['email'] as String,
      edgelimit: json['edgelimit'] as int?,
      crmFlg: json['crm_flg'] as int?,
      plan: json['plan'] as int?,
      termStart: json['term_start'] as String?,
      termEnd: json['term_end'] as String?,
    );

Map<String, dynamic> _$$_OfficePostToJson(_$_OfficePost instance) =>
    <String, dynamic>{
      'm_company_id': instance.mCompanyId,
      'name': instance.name,
      'owner': instance.owner,
      'zip': instance.zip,
      'address1': instance.address1,
      'address2': instance.address2,
      'address3': instance.address3,
      'address4': instance.address4,
      'tel': instance.tel,
      'email': instance.email,
      'edgelimit': instance.edgelimit,
      'crm_flg': instance.crmFlg,
      'plan': instance.plan,
      'term_start': instance.termStart,
      'term_end': instance.termEnd,
    };

_$_OfficeGet _$$_OfficeGetFromJson(Map<String, dynamic> json) => _$_OfficeGet(
      id: json['id'] as int?,
      mCompanyId: json['m_company_id'] as int,
      name: json['name'] as String,
      owner: json['owner'] as String?,
      zip: json['zip'] as int?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      address3: json['address3'] as String?,
      address4: json['address4'] as String?,
      tel: json['tel'] as String?,
      email: json['email'] as String,
      edgelimit: json['edgelimit'] as int?,
      intdashTenantId: json['intdash_tenant_id'] as String?,
      crmFlg: json['crm_flg'] as int?,
      plan: json['plan'] as int?,
      termStart: json['term_start'] as String?,
      termEnd: json['term_end'] as String?,
    );

Map<String, dynamic> _$$_OfficeGetToJson(_$_OfficeGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_company_id': instance.mCompanyId,
      'name': instance.name,
      'owner': instance.owner,
      'zip': instance.zip,
      'address1': instance.address1,
      'address2': instance.address2,
      'address3': instance.address3,
      'address4': instance.address4,
      'tel': instance.tel,
      'email': instance.email,
      'edgelimit': instance.edgelimit,
      'intdash_tenant_id': instance.intdashTenantId,
      'crm_flg': instance.crmFlg,
      'plan': instance.plan,
      'term_start': instance.termStart,
      'term_end': instance.termEnd,
    };

_$_OfficePut _$$_OfficePutFromJson(Map<String, dynamic> json) => _$_OfficePut(
      mCompanyId: json['m_company_id'] as int,
      name: json['name'] as String,
      owner: json['owner'] as String?,
      zip: json['zip'] as int?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      address3: json['address3'] as String?,
      address4: json['address4'] as String?,
      tel: json['tel'] as String?,
      email: json['email'] as String?,
      edgelimit: json['edgelimit'] as int?,
      intdashTenantId: json['intdash_tenant_id'] as String?,
      crmFlg: json['crm_flg'] as int?,
      plan: json['plan'] as int?,
      termStart: json['term_start'] as String?,
      termEnd: json['term_end'] as String?,
    );

Map<String, dynamic> _$$_OfficePutToJson(_$_OfficePut instance) =>
    <String, dynamic>{
      'm_company_id': instance.mCompanyId,
      'name': instance.name,
      'owner': instance.owner,
      'zip': instance.zip,
      'address1': instance.address1,
      'address2': instance.address2,
      'address3': instance.address3,
      'address4': instance.address4,
      'tel': instance.tel,
      'email': instance.email,
      'edgelimit': instance.edgelimit,
      'intdash_tenant_id': instance.intdashTenantId,
      'crm_flg': instance.crmFlg,
      'plan': instance.plan,
      'term_start': instance.termStart,
      'term_end': instance.termEnd,
    };

_$_MemberRecordPost _$$_MemberRecordPostFromJson(Map<String, dynamic> json) =>
    _$_MemberRecordPost(
      mOfficeId: json['m_office_id'] as int,
      name: json['name'] as String,
      nameKana: json['name_kana'] as String,
      gender: json['gender'] as int?,
      birthDate: json['birth_date'] as String?,
      height: json['height'] as num?,
      weight: json['weight'] as num?,
    );

Map<String, dynamic> _$$_MemberRecordPostToJson(_$_MemberRecordPost instance) =>
    <String, dynamic>{
      'm_office_id': instance.mOfficeId,
      'name': instance.name,
      'name_kana': instance.nameKana,
      'gender': instance.gender,
      'birth_date': instance.birthDate,
      'height': instance.height,
      'weight': instance.weight,
    };

_$_MemberLinkGet _$$_MemberLinkGetFromJson(Map<String, dynamic> json) =>
    _$_MemberLinkGet(
      id: json['id'] as int?,
      linkService: json['link_service'] as int?,
      linkData: json['link_data'] == null
          ? null
          : MemberLinkGetLinkData.fromJson(
              json['link_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_MemberLinkGetToJson(_$_MemberLinkGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'link_service': instance.linkService,
      'link_data': instance.linkData,
    };

_$_MemberLinkPost _$$_MemberLinkPostFromJson(Map<String, dynamic> json) =>
    _$_MemberLinkPost(
      linkService: json['link_service'] as int,
      linkData: MemberLinkPostLinkData.fromJson(
          json['link_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_MemberLinkPostToJson(_$_MemberLinkPost instance) =>
    <String, dynamic>{
      'link_service': instance.linkService,
      'link_data': instance.linkData,
    };

_$_MemberLinkPut _$$_MemberLinkPutFromJson(Map<String, dynamic> json) =>
    _$_MemberLinkPut(
      linkService: json['link_service'] as int,
      linkData: MemberLinkPutLinkData.fromJson(
          json['link_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_MemberLinkPutToJson(_$_MemberLinkPut instance) =>
    <String, dynamic>{
      'link_service': instance.linkService,
      'link_data': instance.linkData,
    };

_$_MemberRecordPut _$$_MemberRecordPutFromJson(Map<String, dynamic> json) =>
    _$_MemberRecordPut(
      mOfficeId: json['m_office_id'] as int?,
      name: json['name'] as String?,
      nameKana: json['name_kana'] as String?,
      gender: json['gender'] as int?,
      birthDate: json['birth_date'] as String?,
      height: json['height'] as num?,
      weight: json['weight'] as num?,
    );

Map<String, dynamic> _$$_MemberRecordPutToJson(_$_MemberRecordPut instance) =>
    <String, dynamic>{
      'm_office_id': instance.mOfficeId,
      'name': instance.name,
      'name_kana': instance.nameKana,
      'gender': instance.gender,
      'birth_date': instance.birthDate,
      'height': instance.height,
      'weight': instance.weight,
    };

_$_LoginAccountRecord _$$_LoginAccountRecordFromJson(
        Map<String, dynamic> json) =>
    _$_LoginAccountRecord(
      id: json['id'] as int?,
      firebaseId: json['firebase_id'] as String?,
      accountType: json['account_type'] as String?,
      accountId: json['account_id'] as int?,
      email: json['email'] as String?,
      account: json['account'] == null
          ? null
          : AccountRecord.fromJson(json['account'] as Map<String, dynamic>),
      roles: json['roles'] == null
          ? null
          : RoleRecord.fromJson(json['roles'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_LoginAccountRecordToJson(
        _$_LoginAccountRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firebase_id': instance.firebaseId,
      'account_type': instance.accountType,
      'account_id': instance.accountId,
      'email': instance.email,
      'account': instance.account,
      'roles': instance.roles,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_AccountRecord _$$_AccountRecordFromJson(Map<String, dynamic> json) =>
    _$_AccountRecord(
      id: json['id'] as int?,
      mCompanyId: json['m_company_id'] as int?,
      name: json['name'] as String?,
      company: json['company'] == null
          ? null
          : CompanyRecord.fromJson(json['company'] as Map<String, dynamic>),
      offices: (json['offices'] as List<dynamic>?)
              ?.map((e) => OfficeRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_AccountRecordToJson(_$_AccountRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_company_id': instance.mCompanyId,
      'name': instance.name,
      'company': instance.company,
      'offices': instance.offices,
    };

_$_RecordDataBlankPost _$$_RecordDataBlankPostFromJson(
        Map<String, dynamic> json) =>
    _$_RecordDataBlankPost(
      mMemberId: json['m_member_id'] as int?,
    );

Map<String, dynamic> _$$_RecordDataBlankPostToJson(
        _$_RecordDataBlankPost instance) =>
    <String, dynamic>{
      'm_member_id': instance.mMemberId,
    };

_$_RecordDataBlank _$$_RecordDataBlankFromJson(Map<String, dynamic> json) =>
    _$_RecordDataBlank(
      recordDataId: json['record_data_id'] as String?,
      intdashMesurementUuid: json['intdash_mesurement_uuid'] as String?,
    );

Map<String, dynamic> _$$_RecordDataBlankToJson(_$_RecordDataBlank instance) =>
    <String, dynamic>{
      'record_data_id': instance.recordDataId,
      'intdash_mesurement_uuid': instance.intdashMesurementUuid,
    };

_$_RecordMeasurementSearchGet _$$_RecordMeasurementSearchGetFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementSearchGet(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
      firstPageUrl: json['first_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
      lastPageUrl: json['last_page_url'] as String?,
      path: json['path'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => RecordMeasurementSearchGetData.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_RecordMeasurementSearchGetToJson(
        _$_RecordMeasurementSearchGet instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'first_page_url': instance.firstPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'next_page_url': instance.nextPageUrl,
      'last_page_url': instance.lastPageUrl,
      'path': instance.path,
      'data': instance.data,
    };

_$_RecordMeasurementSessionSearchGet
    _$$_RecordMeasurementSessionSearchGetFromJson(Map<String, dynamic> json) =>
        _$_RecordMeasurementSessionSearchGet(
          currentPage: json['current_page'] as int?,
          lastPage: json['last_page'] as int?,
          perPage: json['per_page'] as int?,
          from: json['from'] as int?,
          to: json['to'] as int?,
          total: json['total'] as int?,
          firstPageUrl: json['first_page_url'] as String?,
          prevPageUrl: json['prev_page_url'] as String?,
          nextPageUrl: json['next_page_url'] as String?,
          lastPageUrl: json['last_page_url'] as String?,
          path: json['path'] as String?,
          data: (json['data'] as List<dynamic>?)
                  ?.map((e) => RecordMeasurementSessionSearchGetData.fromJson(
                      e as Map<String, dynamic>))
                  .toList() ??
              const [],
        );

Map<String, dynamic> _$$_RecordMeasurementSessionSearchGetToJson(
        _$_RecordMeasurementSessionSearchGet instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'first_page_url': instance.firstPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'next_page_url': instance.nextPageUrl,
      'last_page_url': instance.lastPageUrl,
      'path': instance.path,
      'data': instance.data,
    };

_$_RecordDataGet _$$_RecordDataGetFromJson(Map<String, dynamic> json) =>
    _$_RecordDataGet(
      recordDataId: json['record_data_id'] as String?,
      intdashMesurementUuid: json['intdash_mesurement_uuid'] as String?,
      mMemberId: json['m_member_id'] as int?,
      intdashMeasurementUuid: json['intdash_measurement_uuid'] as String?,
      recordDatetimeFrom: json['record_datetime_from'] as String?,
      recordDatetimeTo: json['record_datetime_to'] as String?,
      recordName: json['record_name'] as String?,
      pace: json['pace'] as num?,
      distance: json['distance'] as num?,
      gaitType: json['gait_type'] as int?,
      footStrikeL: json['foot_strike_l'] as num?,
      footStrikeR: json['foot_strike_r'] as num?,
      pronationL: json['pronation_l'] as num?,
      pronationR: json['pronation_r'] as num?,
      strideL: json['stride_l'] as num?,
      strideR: json['stride_r'] as num?,
      cadenceL: json['cadence_l'] as num?,
      cadenceR: json['cadence_r'] as num?,
      landingTimeL: json['landing_time_l'] as num?,
      landingTimeR: json['landing_time_r'] as num?,
      strideHeightL: json['stride_height_l'] as num?,
      strideHeightR: json['stride_height_r'] as num?,
      landingForceL: json['landing_force_l'] as num?,
      landingForceR: json['landing_force_r'] as num?,
      swingPhaseDurationL: json['swing_phase_duration_l'] as num?,
      swingPhaseDurationR: json['swing_phase_duration_r'] as num?,
      toeOffAngleL: json['toe_off_angle_l'] as num?,
      toeOffAngleR: json['toe_off_angle_r'] as num?,
      cyclicStrideFileL: json['cyclic_stride_file_l'] as String?,
      cyclicStrideFileR: json['cyclic_stride_file_r'] as String?,
      gaitAnalysisFileL: json['gait_analysis_file_l'] as String?,
      gaitAnalysisFileR: json['gait_analysis_file_r'] as String?,
      gaitanalysisStatus: json['gaitanalysis_status'] as num?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map(
                  (e) => RecordDataGetTags.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_RecordDataGetToJson(_$_RecordDataGet instance) =>
    <String, dynamic>{
      'record_data_id': instance.recordDataId,
      'intdash_mesurement_uuid': instance.intdashMesurementUuid,
      'm_member_id': instance.mMemberId,
      'intdash_measurement_uuid': instance.intdashMeasurementUuid,
      'record_datetime_from': instance.recordDatetimeFrom,
      'record_datetime_to': instance.recordDatetimeTo,
      'record_name': instance.recordName,
      'pace': instance.pace,
      'distance': instance.distance,
      'gait_type': instance.gaitType,
      'foot_strike_l': instance.footStrikeL,
      'foot_strike_r': instance.footStrikeR,
      'pronation_l': instance.pronationL,
      'pronation_r': instance.pronationR,
      'stride_l': instance.strideL,
      'stride_r': instance.strideR,
      'cadence_l': instance.cadenceL,
      'cadence_r': instance.cadenceR,
      'landing_time_l': instance.landingTimeL,
      'landing_time_r': instance.landingTimeR,
      'stride_height_l': instance.strideHeightL,
      'stride_height_r': instance.strideHeightR,
      'landing_force_l': instance.landingForceL,
      'landing_force_r': instance.landingForceR,
      'swing_phase_duration_l': instance.swingPhaseDurationL,
      'swing_phase_duration_r': instance.swingPhaseDurationR,
      'toe_off_angle_l': instance.toeOffAngleL,
      'toe_off_angle_r': instance.toeOffAngleR,
      'cyclic_stride_file_l': instance.cyclicStrideFileL,
      'cyclic_stride_file_r': instance.cyclicStrideFileR,
      'gait_analysis_file_l': instance.gaitAnalysisFileL,
      'gait_analysis_file_r': instance.gaitAnalysisFileR,
      'gaitanalysis_status': instance.gaitanalysisStatus,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'tags': instance.tags,
    };

_$_RecordMeasurementPost _$$_RecordMeasurementPostFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementPost(
      mMemberId: json['m_member_id'] as int?,
      edgeUuid: json['edge_uuid'] as String?,
      recordName: json['record_name'] as String?,
      intdashMeasurementUuid: json['intdash_measurement_uuid'] as String?,
      recordCore: (json['record_core'] as List<dynamic>?)
              ?.map((e) => RecordMeasurementPostRecordCore.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_RecordMeasurementPostToJson(
        _$_RecordMeasurementPost instance) =>
    <String, dynamic>{
      'm_member_id': instance.mMemberId,
      'edge_uuid': instance.edgeUuid,
      'record_name': instance.recordName,
      'intdash_measurement_uuid': instance.intdashMeasurementUuid,
      'record_core': instance.recordCore,
    };

_$_RecordMeasurementPut _$$_RecordMeasurementPutFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementPut(
      recordDataId: json['record_data_id'] as String?,
      intdashMeasurementUuid: json['intdash_measurement_uuid'] as String?,
      mMemberId: json['m_member_id'] as int?,
      recordDatetimeFrom: json['record_datetime_from'] as String?,
      recordDatetimeTo: json['record_datetime_to'] as String?,
      recordName: json['record_name'] as String?,
    );

Map<String, dynamic> _$$_RecordMeasurementPutToJson(
        _$_RecordMeasurementPut instance) =>
    <String, dynamic>{
      'record_data_id': instance.recordDataId,
      'intdash_measurement_uuid': instance.intdashMeasurementUuid,
      'm_member_id': instance.mMemberId,
      'record_datetime_from': instance.recordDatetimeFrom,
      'record_datetime_to': instance.recordDatetimeTo,
      'record_name': instance.recordName,
    };

_$_RecordCorePost _$$_RecordCorePostFromJson(Map<String, dynamic> json) =>
    _$_RecordCorePost(
      coreType: json['core_type'] as int?,
      coreVersion: json['core_version'] as String?,
      firmwareVersion: json['firmware_version'] as String?,
      mMeasurementPartId: json['m_measurement_part_id'] as int?,
      intdashMeasurementChannel: json['intdash_measurement_channel'] as int?,
      mDeviceId: json['m_device_id'] as int?,
    );

Map<String, dynamic> _$$_RecordCorePostToJson(_$_RecordCorePost instance) =>
    <String, dynamic>{
      'core_type': instance.coreType,
      'core_version': instance.coreVersion,
      'firmware_version': instance.firmwareVersion,
      'm_measurement_part_id': instance.mMeasurementPartId,
      'intdash_measurement_channel': instance.intdashMeasurementChannel,
      'm_device_id': instance.mDeviceId,
    };

_$_RecordCoreGet _$$_RecordCoreGetFromJson(Map<String, dynamic> json) =>
    _$_RecordCoreGet(
      id: json['id'] as int?,
      coreType: json['core_type'] as int?,
      coreVersion: json['core_version'] as String?,
      firmwareVersion: json['firmware_version'] as String?,
      mDeviceId: json['m_device_id'] as int?,
      tRecordMeasurementId: json['t_record_measurement_id'] as int?,
      mMeasurementPartId: json['m_measurement_part_id'] as int?,
      intdashMeasurementChannel: json['intdash_measurement_channel'] as int?,
      tRecordGaitAnalysisId: json['t_record_gait_analysis_id'] as int?,
      recordGaitAnalysis: json['record_gait_analysis'] == null
          ? null
          : RecordGaitAnalysisGet.fromJson(
              json['record_gait_analysis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_RecordCoreGetToJson(_$_RecordCoreGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'core_type': instance.coreType,
      'core_version': instance.coreVersion,
      'firmware_version': instance.firmwareVersion,
      'm_device_id': instance.mDeviceId,
      't_record_measurement_id': instance.tRecordMeasurementId,
      'm_measurement_part_id': instance.mMeasurementPartId,
      'intdash_measurement_channel': instance.intdashMeasurementChannel,
      't_record_gait_analysis_id': instance.tRecordGaitAnalysisId,
      'record_gait_analysis': instance.recordGaitAnalysis,
    };

_$_RecordMeasurementGet _$$_RecordMeasurementGetFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementGet(
      id: json['id'] as int?,
      recordDataId: json['record_data_id'] as String?,
      intdashMeasurementUuid: json['intdash_measurement_uuid'] as String?,
      mMemberId: json['m_member_id'] as int?,
      recordDatetimeFrom: json['record_datetime_from'] as String?,
      recordDatetimeTo: json['record_datetime_to'] as String?,
      recordName: json['record_name'] as String?,
      recordCore: (json['record_core'] as List<dynamic>?)
              ?.map((e) => RecordMeasurementGetRecordCore.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      analysisData: json['analysis_data'] == null
          ? null
          : AnalysisData.fromJson(
              json['analysis_data'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) =>
                  RecordMeasurementGetTags.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_RecordMeasurementGetToJson(
        _$_RecordMeasurementGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'record_data_id': instance.recordDataId,
      'intdash_measurement_uuid': instance.intdashMeasurementUuid,
      'm_member_id': instance.mMemberId,
      'record_datetime_from': instance.recordDatetimeFrom,
      'record_datetime_to': instance.recordDatetimeTo,
      'record_name': instance.recordName,
      'record_core': instance.recordCore,
      'analysis_data': instance.analysisData,
      'tags': instance.tags,
    };

_$_RecordGaitAnalysisPost _$$_RecordGaitAnalysisPostFromJson(
        Map<String, dynamic> json) =>
    _$_RecordGaitAnalysisPost(
      tRecordCoreId: (json['t_record_core_id'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      gaitAnalysis: json['gait_analysis'] == null
          ? null
          : RecordGaitAnalysisPostDetail.fromJson(
              json['gait_analysis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_RecordGaitAnalysisPostToJson(
        _$_RecordGaitAnalysisPost instance) =>
    <String, dynamic>{
      't_record_core_id': instance.tRecordCoreId,
      'gait_analysis': instance.gaitAnalysis,
    };

_$_MemberListDelete _$$_MemberListDeleteFromJson(Map<String, dynamic> json) =>
    _$_MemberListDelete(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          const [],
    );

Map<String, dynamic> _$$_MemberListDeleteToJson(_$_MemberListDelete instance) =>
    <String, dynamic>{
      'ids': instance.ids,
    };

_$_RecordMeasurementListDelete _$$_RecordMeasurementListDeleteFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementListDelete(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          const [],
    );

Map<String, dynamic> _$$_RecordMeasurementListDeleteToJson(
        _$_RecordMeasurementListDelete instance) =>
    <String, dynamic>{
      'ids': instance.ids,
    };

_$_RecordGaitAnalysisPostDetail _$$_RecordGaitAnalysisPostDetailFromJson(
        Map<String, dynamic> json) =>
    _$_RecordGaitAnalysisPostDetail(
      pace: json['pace'] as num?,
      distance: json['distance'] as num?,
      gaitType: json['gait_type'] as int?,
      footStrikeL: json['foot_strike_l'] as num?,
      footStrikeR: json['foot_strike_r'] as num?,
      pronationL: json['pronation_l'] as num?,
      pronationR: json['pronation_r'] as num?,
      strideL: json['stride_l'] as num?,
      strideR: json['stride_r'] as num?,
      cadenceL: json['cadence_l'] as num?,
      cadenceR: json['cadence_r'] as num?,
      landingTimeL: json['landing_time_l'] as num?,
      landingTimeR: json['landing_time_r'] as num?,
      strideHeightL: json['stride_height_l'] as num?,
      strideHeightR: json['stride_height_r'] as num?,
      landingForceL: json['landing_force_l'] as num?,
      landingForceR: json['landing_force_r'] as num?,
      swingPhaseDurationL: json['swing_phase_duration_l'] as num?,
      swingPhaseDurationR: json['swing_phase_duration_r'] as num?,
      toeOffAngleL: json['toe_off_angle_l'] as num?,
      toeOffAngleR: json['toe_off_angle_r'] as num?,
      cyclicStrideFileL: json['cyclic_stride_file_l'] as String?,
      cyclicStrideFileR: json['cyclic_stride_file_r'] as String?,
      gaitAnalysisFileL: json['gait_analysis_file_l'] as String?,
      gaitAnalysisFileR: json['gait_analysis_file_r'] as String?,
      gaitanalysisStatus: json['gaitanalysis_status'] as num?,
    );

Map<String, dynamic> _$$_RecordGaitAnalysisPostDetailToJson(
        _$_RecordGaitAnalysisPostDetail instance) =>
    <String, dynamic>{
      'pace': instance.pace,
      'distance': instance.distance,
      'gait_type': instance.gaitType,
      'foot_strike_l': instance.footStrikeL,
      'foot_strike_r': instance.footStrikeR,
      'pronation_l': instance.pronationL,
      'pronation_r': instance.pronationR,
      'stride_l': instance.strideL,
      'stride_r': instance.strideR,
      'cadence_l': instance.cadenceL,
      'cadence_r': instance.cadenceR,
      'landing_time_l': instance.landingTimeL,
      'landing_time_r': instance.landingTimeR,
      'stride_height_l': instance.strideHeightL,
      'stride_height_r': instance.strideHeightR,
      'landing_force_l': instance.landingForceL,
      'landing_force_r': instance.landingForceR,
      'swing_phase_duration_l': instance.swingPhaseDurationL,
      'swing_phase_duration_r': instance.swingPhaseDurationR,
      'toe_off_angle_l': instance.toeOffAngleL,
      'toe_off_angle_r': instance.toeOffAngleR,
      'cyclic_stride_file_l': instance.cyclicStrideFileL,
      'cyclic_stride_file_r': instance.cyclicStrideFileR,
      'gait_analysis_file_l': instance.gaitAnalysisFileL,
      'gait_analysis_file_r': instance.gaitAnalysisFileR,
      'gaitanalysis_status': instance.gaitanalysisStatus,
    };

_$_RecordGaitAnalysisGet _$$_RecordGaitAnalysisGetFromJson(
        Map<String, dynamic> json) =>
    _$_RecordGaitAnalysisGet(
      id: json['id'] as int?,
      pace: json['pace'] as num?,
      distance: json['distance'] as num?,
      gaitType: json['gait_type'] as int?,
      footStrikeL: json['foot_strike_l'] as num?,
      footStrikeR: json['foot_strike_r'] as num?,
      pronationL: json['pronation_l'] as num?,
      pronationR: json['pronation_r'] as num?,
      strideL: json['stride_l'] as num?,
      strideR: json['stride_r'] as num?,
      cadenceL: json['cadence_l'] as num?,
      cadenceR: json['cadence_r'] as num?,
      landingTimeL: json['landing_time_l'] as num?,
      landingTimeR: json['landing_time_r'] as num?,
      strideHeightL: json['stride_height_l'] as num?,
      strideHeightR: json['stride_height_r'] as num?,
      landingForceL: json['landing_force_l'] as num?,
      landingForceR: json['landing_force_r'] as num?,
      swingPhaseDurationL: json['swing_phase_duration_l'] as num?,
      swingPhaseDurationR: json['swing_phase_duration_r'] as num?,
      toeOffAngleL: json['toe_off_angle_l'] as num?,
      toeOffAngleR: json['toe_off_angle_r'] as num?,
      cyclicStrideFileL: json['cyclic_stride_file_l'] as String?,
      cyclicStrideFileR: json['cyclic_stride_file_r'] as String?,
      gaitAnalysisFileL: json['gait_analysis_file_l'] as String?,
      gaitAnalysisFileR: json['gait_analysis_file_r'] as String?,
      gaitanalysisStatus: json['gaitanalysis_status'] as num?,
    );

Map<String, dynamic> _$$_RecordGaitAnalysisGetToJson(
        _$_RecordGaitAnalysisGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pace': instance.pace,
      'distance': instance.distance,
      'gait_type': instance.gaitType,
      'foot_strike_l': instance.footStrikeL,
      'foot_strike_r': instance.footStrikeR,
      'pronation_l': instance.pronationL,
      'pronation_r': instance.pronationR,
      'stride_l': instance.strideL,
      'stride_r': instance.strideR,
      'cadence_l': instance.cadenceL,
      'cadence_r': instance.cadenceR,
      'landing_time_l': instance.landingTimeL,
      'landing_time_r': instance.landingTimeR,
      'stride_height_l': instance.strideHeightL,
      'stride_height_r': instance.strideHeightR,
      'landing_force_l': instance.landingForceL,
      'landing_force_r': instance.landingForceR,
      'swing_phase_duration_l': instance.swingPhaseDurationL,
      'swing_phase_duration_r': instance.swingPhaseDurationR,
      'toe_off_angle_l': instance.toeOffAngleL,
      'toe_off_angle_r': instance.toeOffAngleR,
      'cyclic_stride_file_l': instance.cyclicStrideFileL,
      'cyclic_stride_file_r': instance.cyclicStrideFileR,
      'gait_analysis_file_l': instance.gaitAnalysisFileL,
      'gait_analysis_file_r': instance.gaitAnalysisFileR,
      'gaitanalysis_status': instance.gaitanalysisStatus,
    };

_$_RecordAnalysisPost _$$_RecordAnalysisPostFromJson(
        Map<String, dynamic> json) =>
    _$_RecordAnalysisPost(
      analysis: json['analysis'] as int?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$$_RecordAnalysisPostToJson(
        _$_RecordAnalysisPost instance) =>
    <String, dynamic>{
      'analysis': instance.analysis,
      'status': instance.status,
    };

_$_RecordAnalysisGet _$$_RecordAnalysisGetFromJson(Map<String, dynamic> json) =>
    _$_RecordAnalysisGet(
      id: json['id'] as int?,
      tRecordMeasurementId: json['t_record_measurement_id'] as int?,
      analysis: json['analysis'] as int?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$$_RecordAnalysisGetToJson(
        _$_RecordAnalysisGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      't_record_measurement_id': instance.tRecordMeasurementId,
      'analysis': instance.analysis,
      'status': instance.status,
    };

_$_RecordDataPut _$$_RecordDataPutFromJson(Map<String, dynamic> json) =>
    _$_RecordDataPut(
      mMemberId: json['m_member_id'] as int?,
      intdashMeasurementUuid: json['intdash_measurement_uuid'] as String?,
      recordDatetimeFrom: json['record_datetime_from'] as String?,
      recordDatetimeTo: json['record_datetime_to'] as String?,
      recordName: json['record_name'] as String?,
      pace: json['pace'] as num?,
      distance: json['distance'] as num?,
      gaitType: json['gait_type'] as int?,
      footStrikeL: json['foot_strike_l'] as num?,
      footStrikeR: json['foot_strike_r'] as num?,
      pronationL: json['pronation_l'] as num?,
      pronationR: json['pronation_r'] as num?,
      strideL: json['stride_l'] as num?,
      strideR: json['stride_r'] as num?,
      cadenceL: json['cadence_l'] as num?,
      cadenceR: json['cadence_r'] as num?,
      landingTimeL: json['landing_time_l'] as num?,
      landingTimeR: json['landing_time_r'] as num?,
      strideHeightL: json['stride_height_l'] as num?,
      strideHeightR: json['stride_height_r'] as num?,
      landingForceL: json['landing_force_l'] as num?,
      landingForceR: json['landing_force_r'] as num?,
      swingPhaseDurationL: json['swing_phase_duration_l'] as num?,
      swingPhaseDurationR: json['swing_phase_duration_r'] as num?,
      toeOffAngleL: json['toe_off_angle_l'] as num?,
      toeOffAngleR: json['toe_off_angle_r'] as num?,
      cyclicStrideFileL: json['cyclic_stride_file_l'] as String?,
      cyclicStrideFileR: json['cyclic_stride_file_r'] as String?,
      gaitAnalysisFileL: json['gait_analysis_file_l'] as String?,
      gaitAnalysisFileR: json['gait_analysis_file_r'] as String?,
      gaitanalysisStatus: json['gaitanalysis_status'] as num?,
    );

Map<String, dynamic> _$$_RecordDataPutToJson(_$_RecordDataPut instance) =>
    <String, dynamic>{
      'm_member_id': instance.mMemberId,
      'intdash_measurement_uuid': instance.intdashMeasurementUuid,
      'record_datetime_from': instance.recordDatetimeFrom,
      'record_datetime_to': instance.recordDatetimeTo,
      'record_name': instance.recordName,
      'pace': instance.pace,
      'distance': instance.distance,
      'gait_type': instance.gaitType,
      'foot_strike_l': instance.footStrikeL,
      'foot_strike_r': instance.footStrikeR,
      'pronation_l': instance.pronationL,
      'pronation_r': instance.pronationR,
      'stride_l': instance.strideL,
      'stride_r': instance.strideR,
      'cadence_l': instance.cadenceL,
      'cadence_r': instance.cadenceR,
      'landing_time_l': instance.landingTimeL,
      'landing_time_r': instance.landingTimeR,
      'stride_height_l': instance.strideHeightL,
      'stride_height_r': instance.strideHeightR,
      'landing_force_l': instance.landingForceL,
      'landing_force_r': instance.landingForceR,
      'swing_phase_duration_l': instance.swingPhaseDurationL,
      'swing_phase_duration_r': instance.swingPhaseDurationR,
      'toe_off_angle_l': instance.toeOffAngleL,
      'toe_off_angle_r': instance.toeOffAngleR,
      'cyclic_stride_file_l': instance.cyclicStrideFileL,
      'cyclic_stride_file_r': instance.cyclicStrideFileR,
      'gait_analysis_file_l': instance.gaitAnalysisFileL,
      'gait_analysis_file_r': instance.gaitAnalysisFileR,
      'gaitanalysis_status': instance.gaitanalysisStatus,
    };

_$_NoteSearchGet _$$_NoteSearchGetFromJson(Map<String, dynamic> json) =>
    _$_NoteSearchGet(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
      firstPageUrl: json['first_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
      lastPageUrl: json['last_page_url'] as String?,
      path: json['path'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map(
                  (e) => NoteSearchGetData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_NoteSearchGetToJson(_$_NoteSearchGet instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'first_page_url': instance.firstPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'next_page_url': instance.nextPageUrl,
      'last_page_url': instance.lastPageUrl,
      'path': instance.path,
      'data': instance.data,
    };

_$_NoteGet _$$_NoteGetFromJson(Map<String, dynamic> json) => _$_NoteGet(
      id: json['id'] as int?,
      mMemberId: json['m_member_id'] as int?,
      note: json['note'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_NoteGetToJson(_$_NoteGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_member_id': instance.mMemberId,
      'note': instance.note,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_NotePost _$$_NotePostFromJson(Map<String, dynamic> json) => _$_NotePost(
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$_NotePostToJson(_$_NotePost instance) =>
    <String, dynamic>{
      'note': instance.note,
    };

_$_NotePut _$$_NotePutFromJson(Map<String, dynamic> json) => _$_NotePut(
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$_NotePutToJson(_$_NotePut instance) =>
    <String, dynamic>{
      'note': instance.note,
    };

_$_TagGet _$$_TagGetFromJson(Map<String, dynamic> json) => _$_TagGet(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
      firstPageUrl: json['first_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
      lastPageUrl: json['last_page_url'] as String?,
      path: json['path'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TagGetData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_TagGetToJson(_$_TagGet instance) => <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'first_page_url': instance.firstPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'next_page_url': instance.nextPageUrl,
      'last_page_url': instance.lastPageUrl,
      'path': instance.path,
      'data': instance.data,
    };

_$_TagGetData _$$_TagGetDataFromJson(Map<String, dynamic> json) =>
    _$_TagGetData(
      id: json['id'] as int?,
      mOfficeId: json['m_office_id'] as int?,
      tagName: json['tag_name'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_TagGetDataToJson(_$_TagGetData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_office_id': instance.mOfficeId,
      'tag_name': instance.tagName,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_TagPost _$$_TagPostFromJson(Map<String, dynamic> json) => _$_TagPost(
      mOfficeId: json['m_office_id'] as int?,
      tagName: json['tag_name'] as String?,
    );

Map<String, dynamic> _$$_TagPostToJson(_$_TagPost instance) =>
    <String, dynamic>{
      'm_office_id': instance.mOfficeId,
      'tag_name': instance.tagName,
    };

_$_TagPut _$$_TagPutFromJson(Map<String, dynamic> json) => _$_TagPut(
      tagName: json['tag_name'] as String?,
    );

Map<String, dynamic> _$$_TagPutToJson(_$_TagPut instance) => <String, dynamic>{
      'tag_name': instance.tagName,
    };

_$_TagSetPost _$$_TagSetPostFromJson(Map<String, dynamic> json) =>
    _$_TagSetPost(
      tRecordMeasurementSessionsId:
          json['t_record_measurement_sessions_id'] as int?,
      mTagId:
          (json['m_tag_id'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              const [],
    );

Map<String, dynamic> _$$_TagSetPostToJson(_$_TagSetPost instance) =>
    <String, dynamic>{
      't_record_measurement_sessions_id': instance.tRecordMeasurementSessionsId,
      'm_tag_id': instance.mTagId,
    };

_$_RecordMeasurementSessionTagSetPost
    _$$_RecordMeasurementSessionTagSetPostFromJson(Map<String, dynamic> json) =>
        _$_RecordMeasurementSessionTagSetPost(
          tRecordMeasurementId: json['t_record_measurement_id'] as int?,
          mTagId: (json['m_tag_id'] as List<dynamic>?)
                  ?.map((e) => e as int)
                  .toList() ??
              const [],
        );

Map<String, dynamic> _$$_RecordMeasurementSessionTagSetPostToJson(
        _$_RecordMeasurementSessionTagSetPost instance) =>
    <String, dynamic>{
      't_record_measurement_id': instance.tRecordMeasurementId,
      'm_tag_id': instance.mTagId,
    };

_$_GaitAnalysisPost _$$_GaitAnalysisPostFromJson(Map<String, dynamic> json) =>
    _$_GaitAnalysisPost(
      type: json['type'] as String,
      url: json['url'] as String,
      tRecordCoreId: (json['t_record_core_id'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      tRecordMeasurementId: json['t_record_measurement_id'] as int?,
      mMemberId: json['m_member_id'] as int,
      mOfficeId: json['m_office_id'] as int?,
      measurementUuid: json['measurement_uuid'] as String,
      edgeToken: json['edge_token'] as String?,
      srcEdgeUuid: json['src_edge_uuid'] as String?,
      destEdgeUuid: json['dest_edge_uuid'] as String?,
      natsServer: json['nats_server'] as String?,
      natsUser: json['nats_user'] as String?,
      natsPass: json['nats_pass'] as String?,
      side: json['side'] as String,
      height: json['height'] as num?,
      mass: json['mass'] as num?,
      channel: json['channel'] as int?,
      leftChannel: json['left_channel'] as int?,
      rightChannel: json['right_channel'] as int?,
      path: json['path'] as String?,
      leftPath: json['left_path'] as String?,
      rightPath: json['right_path'] as String?,
    );

Map<String, dynamic> _$$_GaitAnalysisPostToJson(_$_GaitAnalysisPost instance) =>
    <String, dynamic>{
      'type': instance.type,
      'url': instance.url,
      't_record_core_id': instance.tRecordCoreId,
      't_record_measurement_id': instance.tRecordMeasurementId,
      'm_member_id': instance.mMemberId,
      'm_office_id': instance.mOfficeId,
      'measurement_uuid': instance.measurementUuid,
      'edge_token': instance.edgeToken,
      'src_edge_uuid': instance.srcEdgeUuid,
      'dest_edge_uuid': instance.destEdgeUuid,
      'nats_server': instance.natsServer,
      'nats_user': instance.natsUser,
      'nats_pass': instance.natsPass,
      'side': instance.side,
      'height': instance.height,
      'mass': instance.mass,
      'channel': instance.channel,
      'left_channel': instance.leftChannel,
      'right_channel': instance.rightChannel,
      'path': instance.path,
      'left_path': instance.leftPath,
      'right_path': instance.rightPath,
    };

_$_GaitAnalysisStatusPost _$$_GaitAnalysisStatusPostFromJson(
        Map<String, dynamic> json) =>
    _$_GaitAnalysisStatusPost(
      executionArn: json['executionArn'] as String,
    );

Map<String, dynamic> _$$_GaitAnalysisStatusPostToJson(
        _$_GaitAnalysisStatusPost instance) =>
    <String, dynamic>{
      'executionArn': instance.executionArn,
    };

_$_GaitAnalysisStatus _$$_GaitAnalysisStatusFromJson(
        Map<String, dynamic> json) =>
    _$_GaitAnalysisStatus(
      executionArn: json['executionArn'] as String?,
      input: json['input'] as String?,
      inputDetails: json['inputDetails'] == null
          ? null
          : GaitAnalysisStatusInputDetails.fromJson(
              json['inputDetails'] as Map<String, dynamic>),
      output: json['output'] as String?,
      outputDetails: json['outputDetails'] == null
          ? null
          : GaitAnalysisStatusOutputDetails.fromJson(
              json['outputDetails'] as Map<String, dynamic>),
      name: json['name'] as String?,
      startDate: json['startDate'] as num?,
      stateMachineArn: json['stateMachineArn'] as String?,
      status: json['status'] as String?,
      stopDate: json['stopDate'] as num?,
      traceHeader: json['traceHeader'] as String?,
    );

Map<String, dynamic> _$$_GaitAnalysisStatusToJson(
        _$_GaitAnalysisStatus instance) =>
    <String, dynamic>{
      'executionArn': instance.executionArn,
      'input': instance.input,
      'inputDetails': instance.inputDetails,
      'output': instance.output,
      'outputDetails': instance.outputDetails,
      'name': instance.name,
      'startDate': instance.startDate,
      'stateMachineArn': instance.stateMachineArn,
      'status': instance.status,
      'stopDate': instance.stopDate,
      'traceHeader': instance.traceHeader,
    };

_$_TfPosePost _$$_TfPosePostFromJson(Map<String, dynamic> json) =>
    _$_TfPosePost(
      url: json['url'] as String,
      uuid: json['uuid'] as String,
      edgeToken: json['edge_token'] as String,
    );

Map<String, dynamic> _$$_TfPosePostToJson(_$_TfPosePost instance) =>
    <String, dynamic>{
      'url': instance.url,
      'uuid': instance.uuid,
      'edge_token': instance.edgeToken,
    };

_$_EdgeAvailableGet _$$_EdgeAvailableGetFromJson(Map<String, dynamic> json) =>
    _$_EdgeAvailableGet(
      id: json['id'] as int?,
      edgeUuid: json['edge_uuid'] as String?,
      intdashMeasurementUuid: json['intdash_measurement_uuid'] as String?,
      startDatetime: json['start_datetime'] as String?,
      endDatetime: json['end_datetime'] as String?,
      batchEndFlg: json['batch_end_flg'] as num?,
    );

Map<String, dynamic> _$$_EdgeAvailableGetToJson(_$_EdgeAvailableGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'edge_uuid': instance.edgeUuid,
      'intdash_measurement_uuid': instance.intdashMeasurementUuid,
      'start_datetime': instance.startDatetime,
      'end_datetime': instance.endDatetime,
      'batch_end_flg': instance.batchEndFlg,
    };

_$_EdgeAvailablePost _$$_EdgeAvailablePostFromJson(Map<String, dynamic> json) =>
    _$_EdgeAvailablePost(
      edgeUuid: json['edge_uuid'] as String,
      intdashMeasurementUuid: json['intdash_measurement_uuid'] as String,
      startDatetime: json['start_datetime'] as String?,
      endDatetime: json['end_datetime'] as String?,
      batchEndFlg: json['batch_end_flg'] as num?,
    );

Map<String, dynamic> _$$_EdgeAvailablePostToJson(
        _$_EdgeAvailablePost instance) =>
    <String, dynamic>{
      'edge_uuid': instance.edgeUuid,
      'intdash_measurement_uuid': instance.intdashMeasurementUuid,
      'start_datetime': instance.startDatetime,
      'end_datetime': instance.endDatetime,
      'batch_end_flg': instance.batchEndFlg,
    };

_$_EdgeAvailablePut _$$_EdgeAvailablePutFromJson(Map<String, dynamic> json) =>
    _$_EdgeAvailablePut(
      edgeUuid: json['edge_uuid'] as String,
      intdashMeasurementUuid: json['intdash_measurement_uuid'] as String,
      startDatetime: json['start_datetime'] as String?,
      endDatetime: json['end_datetime'] as String?,
      batchEndFlg: json['batch_end_flg'] as num?,
    );

Map<String, dynamic> _$$_EdgeAvailablePutToJson(_$_EdgeAvailablePut instance) =>
    <String, dynamic>{
      'edge_uuid': instance.edgeUuid,
      'intdash_measurement_uuid': instance.intdashMeasurementUuid,
      'start_datetime': instance.startDatetime,
      'end_datetime': instance.endDatetime,
      'batch_end_flg': instance.batchEndFlg,
    };

_$_OfficeIntdashUserGet _$$_OfficeIntdashUserGetFromJson(
        Map<String, dynamic> json) =>
    _$_OfficeIntdashUserGet(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
      firstPageUrl: json['first_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
      lastPageUrl: json['last_page_url'] as String?,
      path: json['path'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) =>
                  OfficeIntdashUserGetData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_OfficeIntdashUserGetToJson(
        _$_OfficeIntdashUserGet instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'first_page_url': instance.firstPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'next_page_url': instance.nextPageUrl,
      'last_page_url': instance.lastPageUrl,
      'path': instance.path,
      'data': instance.data,
    };

_$_OfficeIntdashUser _$$_OfficeIntdashUserFromJson(Map<String, dynamic> json) =>
    _$_OfficeIntdashUser(
      id: json['id'] as int?,
      mOfficeId: json['m_office_id'] as int?,
      uuid: json['uuid'] as String?,
      name: json['name'] as String?,
      apiToken: json['api_token'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_OfficeIntdashUserToJson(
        _$_OfficeIntdashUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_office_id': instance.mOfficeId,
      'uuid': instance.uuid,
      'name': instance.name,
      'api_token': instance.apiToken,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_RuleRecord _$$_RuleRecordFromJson(Map<String, dynamic> json) =>
    _$_RuleRecord(
      id: json['id'] as int?,
      name: json['name'] as String?,
      mIndicatorId: json['m_indicator_id'] as int?,
      rule: json['rule'] as String?,
      priority: json['priority'] as int?,
      indicator: json['indicator'] == null
          ? null
          : RuleIndicatorRecord.fromJson(
              json['indicator'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_RuleRecordToJson(_$_RuleRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'm_indicator_id': instance.mIndicatorId,
      'rule': instance.rule,
      'priority': instance.priority,
      'indicator': instance.indicator,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_RuleIndicatorRecord _$$_RuleIndicatorRecordFromJson(
        Map<String, dynamic> json) =>
    _$_RuleIndicatorRecord(
      id: json['id'] as int?,
      name: json['name'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_RuleIndicatorRecordToJson(
        _$_RuleIndicatorRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_RuleMessageRecord _$$_RuleMessageRecordFromJson(Map<String, dynamic> json) =>
    _$_RuleMessageRecord(
      id: json['id'] as int?,
      mRuleId: json['m_rule_id'] as int?,
      mCommunicationTypeId: json['m_communication_type_id'] as int?,
      message: json['message'] as String?,
      rule: json['rule'] == null
          ? null
          : RuleRecord.fromJson(json['rule'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_RuleMessageRecordToJson(
        _$_RuleMessageRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_rule_id': instance.mRuleId,
      'm_communication_type_id': instance.mCommunicationTypeId,
      'message': instance.message,
      'rule': instance.rule,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_CommunicationTypeRecord _$$_CommunicationTypeRecordFromJson(
        Map<String, dynamic> json) =>
    _$_CommunicationTypeRecord(
      id: json['id'] as int?,
      name: json['name'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_CommunicationTypeRecordToJson(
        _$_CommunicationTypeRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_NoticeGet _$$_NoticeGetFromJson(Map<String, dynamic> json) => _$_NoticeGet(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
      path: json['path'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => NoticeGetData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_NoticeGetToJson(_$_NoticeGet instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'path': instance.path,
      'data': instance.data,
    };

_$_NoticePut _$$_NoticePutFromJson(Map<String, dynamic> json) => _$_NoticePut(
      mMemberId: json['m_member_id'] as int?,
      mRuleId: json['m_rule_id'] as int?,
      mRuleMessageId: json['m_rule_message_id'] as int?,
      noticed: json['noticed'] as bool?,
    );

Map<String, dynamic> _$$_NoticePutToJson(_$_NoticePut instance) =>
    <String, dynamic>{
      'm_member_id': instance.mMemberId,
      'm_rule_id': instance.mRuleId,
      'm_rule_message_id': instance.mRuleMessageId,
      'noticed': instance.noticed,
    };

_$_RecordMeasurementSessionGet _$$_RecordMeasurementSessionGetFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementSessionGet(
      id: json['id'] as int?,
      recordMeasurementSessionUuid:
          json['record_measurement_session_uuid'] as String?,
      measurementType: json['measurement_type'] as int?,
      mMemberId: json['m_member_id'] as int?,
      commentAdvise: json['comment_advise'] as String?,
      commentResult: json['comment_result'] as String?,
      analysisSummaryData: json['analysis_summary_data'] == null
          ? null
          : AnalysisSummaryData.fromJson(
              json['analysis_summary_data'] as Map<String, dynamic>),
      recordMeasurement: (json['record_measurement'] as List<dynamic>?)
              ?.map((e) =>
                  RecordMeasurementSessionGetRecordMeasurement.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_RecordMeasurementSessionGetToJson(
        _$_RecordMeasurementSessionGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'record_measurement_session_uuid': instance.recordMeasurementSessionUuid,
      'measurement_type': instance.measurementType,
      'm_member_id': instance.mMemberId,
      'comment_advise': instance.commentAdvise,
      'comment_result': instance.commentResult,
      'analysis_summary_data': instance.analysisSummaryData,
      'record_measurement': instance.recordMeasurement,
    };

_$_RecordMeasurementSessionPost _$$_RecordMeasurementSessionPostFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementSessionPost(
      recordMeasurementSessionUuid:
          json['record_measurement_session_uuid'] as String,
      measurementType: json['measurement_type'] as int,
      mMemberId: json['m_member_id'] as int,
      commentAdvise: json['comment_advise'] as String?,
      commentResult: json['comment_result'] as String?,
    );

Map<String, dynamic> _$$_RecordMeasurementSessionPostToJson(
        _$_RecordMeasurementSessionPost instance) =>
    <String, dynamic>{
      'record_measurement_session_uuid': instance.recordMeasurementSessionUuid,
      'measurement_type': instance.measurementType,
      'm_member_id': instance.mMemberId,
      'comment_advise': instance.commentAdvise,
      'comment_result': instance.commentResult,
    };

_$_AnalysisData _$$_AnalysisDataFromJson(Map<String, dynamic> json) =>
    _$_AnalysisData(
      recordDataId: json['record_data_id'] as String?,
      analysisType: json['analysis_type'] as int?,
      pace: json['pace'] as num?,
      distance: json['distance'] as num?,
      gaitType: json['gait_type'] as int?,
      footStrikeL: json['foot_strike_l'] as num?,
      footStrikeR: json['foot_strike_r'] as num?,
      pronationL: json['pronation_l'] as num?,
      pronationR: json['pronation_r'] as num?,
      strideL: json['stride_l'] as num?,
      strideR: json['stride_r'] as num?,
      cadenceL: json['cadence_l'] as num?,
      cadenceR: json['cadence_r'] as num?,
      landingTimeL: json['landing_time_l'] as num?,
      landingTimeR: json['landing_time_r'] as num?,
      strideHeightL: json['stride_height_l'] as num?,
      strideHeightR: json['stride_height_r'] as num?,
      landingForceL: json['landing_force_l'] as num?,
      landingForceR: json['landing_force_r'] as num?,
      swingPhaseDurationL: json['swing_phase_duration_l'] as num?,
      swingPhaseDurationR: json['swing_phase_duration_r'] as num?,
      toeOffAngleL: json['toe_off_angle_l'] as num?,
      toeOffAngleR: json['toe_off_angle_r'] as num?,
      cyclicStrideFileL: json['cyclic_stride_file_l'] as String?,
      cyclicStrideFileR: json['cyclic_stride_file_r'] as String?,
      gaitAnalysisFileL: json['gait_analysis_file_l'] as String?,
      gaitAnalysisFileR: json['gait_analysis_file_r'] as String?,
      gaitanalysisStatus: json['gaitanalysis_status'] as num?,
    );

Map<String, dynamic> _$$_AnalysisDataToJson(_$_AnalysisData instance) =>
    <String, dynamic>{
      'record_data_id': instance.recordDataId,
      'analysis_type': instance.analysisType,
      'pace': instance.pace,
      'distance': instance.distance,
      'gait_type': instance.gaitType,
      'foot_strike_l': instance.footStrikeL,
      'foot_strike_r': instance.footStrikeR,
      'pronation_l': instance.pronationL,
      'pronation_r': instance.pronationR,
      'stride_l': instance.strideL,
      'stride_r': instance.strideR,
      'cadence_l': instance.cadenceL,
      'cadence_r': instance.cadenceR,
      'landing_time_l': instance.landingTimeL,
      'landing_time_r': instance.landingTimeR,
      'stride_height_l': instance.strideHeightL,
      'stride_height_r': instance.strideHeightR,
      'landing_force_l': instance.landingForceL,
      'landing_force_r': instance.landingForceR,
      'swing_phase_duration_l': instance.swingPhaseDurationL,
      'swing_phase_duration_r': instance.swingPhaseDurationR,
      'toe_off_angle_l': instance.toeOffAngleL,
      'toe_off_angle_r': instance.toeOffAngleR,
      'cyclic_stride_file_l': instance.cyclicStrideFileL,
      'cyclic_stride_file_r': instance.cyclicStrideFileR,
      'gait_analysis_file_l': instance.gaitAnalysisFileL,
      'gait_analysis_file_r': instance.gaitAnalysisFileR,
      'gaitanalysis_status': instance.gaitanalysisStatus,
    };

_$_AnalysisSummaryData _$$_AnalysisSummaryDataFromJson(
        Map<String, dynamic> json) =>
    _$_AnalysisSummaryData(
      mMemberId: json['m_member_id'] as int?,
      sortId: json['sort_id'] as String?,
      aggregateType: json['aggregate_type'] as String?,
      aggregateConds: json['aggregate_conds'] as String?,
      measurementType: json['measurement_type'] as int?,
      recordFrom: json['record_from'] as String?,
      recordTo: json['record_to'] as String?,
      gaitType: json['gait_type'] as int?,
      pace: json['pace'] == null
          ? null
          : SummaryStandard.fromJson(json['pace'] as Map<String, dynamic>),
      distance: json['distance'] == null
          ? null
          : SummaryStandard.fromJson(json['distance'] as Map<String, dynamic>),
      footStrikeL: json['foot_strike_l'] == null
          ? null
          : SummaryStandard.fromJson(
              json['foot_strike_l'] as Map<String, dynamic>),
      footStrikeR: json['foot_strike_r'] == null
          ? null
          : SummaryStandard.fromJson(
              json['foot_strike_r'] as Map<String, dynamic>),
      pronationL: json['pronation_l'] == null
          ? null
          : SummaryStandard.fromJson(
              json['pronation_l'] as Map<String, dynamic>),
      pronationR: json['pronation_r'] == null
          ? null
          : SummaryStandard.fromJson(
              json['pronation_r'] as Map<String, dynamic>),
      strideL: json['stride_l'] == null
          ? null
          : SummaryStandard.fromJson(json['stride_l'] as Map<String, dynamic>),
      strideR: json['stride_r'] == null
          ? null
          : SummaryStandard.fromJson(json['stride_r'] as Map<String, dynamic>),
      cadenceL: json['cadence_l'] == null
          ? null
          : SummaryStandard.fromJson(json['cadence_l'] as Map<String, dynamic>),
      cadenceR: json['cadence_r'] == null
          ? null
          : SummaryStandard.fromJson(json['cadence_r'] as Map<String, dynamic>),
      landingTimeL: json['landing_time_l'] == null
          ? null
          : SummaryStandard.fromJson(
              json['landing_time_l'] as Map<String, dynamic>),
      landingTimeR: json['landing_time_r'] == null
          ? null
          : SummaryStandard.fromJson(
              json['landing_time_r'] as Map<String, dynamic>),
      strideHeightL: json['stride_height_l'] == null
          ? null
          : SummaryStandard.fromJson(
              json['stride_height_l'] as Map<String, dynamic>),
      strideHeightR: json['stride_height_r'] == null
          ? null
          : SummaryStandard.fromJson(
              json['stride_height_r'] as Map<String, dynamic>),
      landingForceL: json['landing_force_l'] == null
          ? null
          : SummaryStandard.fromJson(
              json['landing_force_l'] as Map<String, dynamic>),
      landingForceR: json['landing_force_r'] == null
          ? null
          : SummaryStandard.fromJson(
              json['landing_force_r'] as Map<String, dynamic>),
      swingPhaseDurationL: json['swing_phase_duration_l'] == null
          ? null
          : SummaryStandard.fromJson(
              json['swing_phase_duration_l'] as Map<String, dynamic>),
      swingPhaseDurationR: json['swing_phase_duration_r'] == null
          ? null
          : SummaryStandard.fromJson(
              json['swing_phase_duration_r'] as Map<String, dynamic>),
      toeOffAngleL: json['toe_off_angle_l'] == null
          ? null
          : SummaryStandard.fromJson(
              json['toe_off_angle_l'] as Map<String, dynamic>),
      toeOffAngleR: json['toe_off_angle_r'] == null
          ? null
          : SummaryStandard.fromJson(
              json['toe_off_angle_r'] as Map<String, dynamic>),
      summmaryDatetime: json['summmary_datetime'] as String?,
    );

Map<String, dynamic> _$$_AnalysisSummaryDataToJson(
        _$_AnalysisSummaryData instance) =>
    <String, dynamic>{
      'm_member_id': instance.mMemberId,
      'sort_id': instance.sortId,
      'aggregate_type': instance.aggregateType,
      'aggregate_conds': instance.aggregateConds,
      'measurement_type': instance.measurementType,
      'record_from': instance.recordFrom,
      'record_to': instance.recordTo,
      'gait_type': instance.gaitType,
      'pace': instance.pace,
      'distance': instance.distance,
      'foot_strike_l': instance.footStrikeL,
      'foot_strike_r': instance.footStrikeR,
      'pronation_l': instance.pronationL,
      'pronation_r': instance.pronationR,
      'stride_l': instance.strideL,
      'stride_r': instance.strideR,
      'cadence_l': instance.cadenceL,
      'cadence_r': instance.cadenceR,
      'landing_time_l': instance.landingTimeL,
      'landing_time_r': instance.landingTimeR,
      'stride_height_l': instance.strideHeightL,
      'stride_height_r': instance.strideHeightR,
      'landing_force_l': instance.landingForceL,
      'landing_force_r': instance.landingForceR,
      'swing_phase_duration_l': instance.swingPhaseDurationL,
      'swing_phase_duration_r': instance.swingPhaseDurationR,
      'toe_off_angle_l': instance.toeOffAngleL,
      'toe_off_angle_r': instance.toeOffAngleR,
      'summmary_datetime': instance.summmaryDatetime,
    };

_$_SummaryStandard _$$_SummaryStandardFromJson(Map<String, dynamic> json) =>
    _$_SummaryStandard(
      avg: json['avg'] as num?,
      max: json['max'] as num?,
      min: json['min'] as num?,
      med: json['med'] as num?,
    );

Map<String, dynamic> _$$_SummaryStandardToJson(_$_SummaryStandard instance) =>
    <String, dynamic>{
      'avg': instance.avg,
      'max': instance.max,
      'min': instance.min,
      'med': instance.med,
    };

_$_ErrorErrors _$$_ErrorErrorsFromJson(Map<String, dynamic> json) =>
    _$_ErrorErrors();

Map<String, dynamic> _$$_ErrorErrorsToJson(_$_ErrorErrors instance) =>
    <String, dynamic>{};

_$_OfficeRecordPivot _$$_OfficeRecordPivotFromJson(Map<String, dynamic> json) =>
    _$_OfficeRecordPivot(
      mCompanyUserId: json['m_company_user_id'] as int?,
      mOfficeId: json['m_office_id'] as int?,
    );

Map<String, dynamic> _$$_OfficeRecordPivotToJson(
        _$_OfficeRecordPivot instance) =>
    <String, dynamic>{
      'm_company_user_id': instance.mCompanyUserId,
      'm_office_id': instance.mOfficeId,
    };

_$_RoleRecordPivot _$$_RoleRecordPivotFromJson(Map<String, dynamic> json) =>
    _$_RoleRecordPivot(
      mLoginAccountId: json['m_login_account_id'] as int?,
      mRoleId: json['m_role_id'] as int?,
    );

Map<String, dynamic> _$$_RoleRecordPivotToJson(_$_RoleRecordPivot instance) =>
    <String, dynamic>{
      'm_login_account_id': instance.mLoginAccountId,
      'm_role_id': instance.mRoleId,
    };

_$_RoleRecordPermissions _$$_RoleRecordPermissionsFromJson(
        Map<String, dynamic> json) =>
    _$_RoleRecordPermissions(
      id: json['id'] as int?,
      permissionName: json['permission_name'] as String?,
      pivot: (json['pivot'] as List<dynamic>?)
              ?.map((e) =>
                  PermissionRecordPivot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_RoleRecordPermissionsToJson(
        _$_RoleRecordPermissions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'permission_name': instance.permissionName,
      'pivot': instance.pivot,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_PermissionRecordPivot _$$_PermissionRecordPivotFromJson(
        Map<String, dynamic> json) =>
    _$_PermissionRecordPivot(
      mRoleId: json['m_role_id'] as int?,
      mPermissionId: json['m_permission_id'] as int?,
    );

Map<String, dynamic> _$$_PermissionRecordPivotToJson(
        _$_PermissionRecordPivot instance) =>
    <String, dynamic>{
      'm_role_id': instance.mRoleId,
      'm_permission_id': instance.mPermissionId,
    };

_$_MemberSearchRecordGetData _$$_MemberSearchRecordGetDataFromJson(
        Map<String, dynamic> json) =>
    _$_MemberSearchRecordGetData(
      id: json['id'] as int?,
      mOfficeId: json['m_office_id'] as int?,
      name: json['name'] as String?,
      nameKana: json['name_kana'] as String?,
      gender: json['gender'] as int?,
      birthDate: json['birth_date'] as String?,
      height: json['height'] as num?,
      weight: json['weight'] as num?,
      memberEdges: (json['member_edges'] as List<dynamic>?)
              ?.map((e) => MemberRecordGetMemberEdges.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      memberLinks: (json['member_links'] as List<dynamic>?)
              ?.map((e) => MemberRecordGetMemberLinks.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      recordMeasurementSessions: (json['record_measurement_sessions']
                  as List<dynamic>?)
              ?.map((e) => MemberRecordGetRecordMeasurementSessions.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );

Map<String, dynamic> _$$_MemberSearchRecordGetDataToJson(
        _$_MemberSearchRecordGetData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_office_id': instance.mOfficeId,
      'name': instance.name,
      'name_kana': instance.nameKana,
      'gender': instance.gender,
      'birth_date': instance.birthDate,
      'height': instance.height,
      'weight': instance.weight,
      'member_edges': instance.memberEdges,
      'member_links': instance.memberLinks,
      'record_measurement_sessions': instance.recordMeasurementSessions,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
    };

_$_MemberRecordGetMemberEdges _$$_MemberRecordGetMemberEdgesFromJson(
        Map<String, dynamic> json) =>
    _$_MemberRecordGetMemberEdges(
      id: json['id'] as int?,
      mMemberId: json['m_member_id'] as int?,
      edgeUuid: json['edge_uuid'] as String?,
    );

Map<String, dynamic> _$$_MemberRecordGetMemberEdgesToJson(
        _$_MemberRecordGetMemberEdges instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_member_id': instance.mMemberId,
      'edge_uuid': instance.edgeUuid,
    };

_$_MemberRecordGetMemberLinks _$$_MemberRecordGetMemberLinksFromJson(
        Map<String, dynamic> json) =>
    _$_MemberRecordGetMemberLinks(
      id: json['id'] as int?,
      linkService: json['link_service'] as int?,
      linkData: json['link_data'] == null
          ? null
          : MemberLinkGetLinkData.fromJson(
              json['link_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_MemberRecordGetMemberLinksToJson(
        _$_MemberRecordGetMemberLinks instance) =>
    <String, dynamic>{
      'id': instance.id,
      'link_service': instance.linkService,
      'link_data': instance.linkData,
    };

_$_MemberRecordGetRecordMeasurementSessions
    _$$_MemberRecordGetRecordMeasurementSessionsFromJson(
            Map<String, dynamic> json) =>
        _$_MemberRecordGetRecordMeasurementSessions(
          id: json['id'] as int?,
          recordMeasurementSessionUuid:
              json['record_measurement_session_uuid'] as String?,
          measurementType: json['measurement_type'] as int?,
          mMemberId: json['m_member_id'] as int?,
          commentAdvise: json['comment_advise'] as String?,
          commentResult: json['comment_result'] as String?,
          analysisSummaryData: json['analysis_summary_data'] == null
              ? null
              : AnalysisSummaryData.fromJson(
                  json['analysis_summary_data'] as Map<String, dynamic>),
          recordMeasurement: (json['record_measurement'] as List<dynamic>?)
                  ?.map((e) =>
                      RecordMeasurementSessionGetRecordMeasurement.fromJson(
                          e as Map<String, dynamic>))
                  .toList() ??
              const [],
        );

Map<String, dynamic> _$$_MemberRecordGetRecordMeasurementSessionsToJson(
        _$_MemberRecordGetRecordMeasurementSessions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'record_measurement_session_uuid': instance.recordMeasurementSessionUuid,
      'measurement_type': instance.measurementType,
      'm_member_id': instance.mMemberId,
      'comment_advise': instance.commentAdvise,
      'comment_result': instance.commentResult,
      'analysis_summary_data': instance.analysisSummaryData,
      'record_measurement': instance.recordMeasurement,
    };

_$_MemberLinkGetLinkData _$$_MemberLinkGetLinkDataFromJson(
        Map<String, dynamic> json) =>
    _$_MemberLinkGetLinkData(
      dataLakeToken: json['data_lake_token'] as String?,
      dataLakeRefreshToken: json['data_lake_refresh_token'] as String?,
      orpheId: json['orphe_id'] as String?,
      tenantId: json['tenant_id'] as String?,
    );

Map<String, dynamic> _$$_MemberLinkGetLinkDataToJson(
        _$_MemberLinkGetLinkData instance) =>
    <String, dynamic>{
      'data_lake_token': instance.dataLakeToken,
      'data_lake_refresh_token': instance.dataLakeRefreshToken,
      'orphe_id': instance.orpheId,
      'tenant_id': instance.tenantId,
    };

_$_MemberLinkPostLinkData _$$_MemberLinkPostLinkDataFromJson(
        Map<String, dynamic> json) =>
    _$_MemberLinkPostLinkData(
      dataLakeToken: json['data_lake_token'] as String?,
      dataLakeRefreshToken: json['data_lake_refresh_token'] as String?,
      orpheId: json['orphe_id'] as String?,
      tenantId: json['tenant_id'] as String?,
    );

Map<String, dynamic> _$$_MemberLinkPostLinkDataToJson(
        _$_MemberLinkPostLinkData instance) =>
    <String, dynamic>{
      'data_lake_token': instance.dataLakeToken,
      'data_lake_refresh_token': instance.dataLakeRefreshToken,
      'orphe_id': instance.orpheId,
      'tenant_id': instance.tenantId,
    };

_$_MemberLinkPutLinkData _$$_MemberLinkPutLinkDataFromJson(
        Map<String, dynamic> json) =>
    _$_MemberLinkPutLinkData(
      dataLakeToken: json['data_lake_token'] as String?,
      dataLakeRefreshToken: json['data_lake_refresh_token'] as String?,
      orpheId: json['orphe_id'] as String?,
      tenantId: json['tenant_id'] as String?,
    );

Map<String, dynamic> _$$_MemberLinkPutLinkDataToJson(
        _$_MemberLinkPutLinkData instance) =>
    <String, dynamic>{
      'data_lake_token': instance.dataLakeToken,
      'data_lake_refresh_token': instance.dataLakeRefreshToken,
      'orphe_id': instance.orpheId,
      'tenant_id': instance.tenantId,
    };

_$_RecordMeasurementSearchGetData _$$_RecordMeasurementSearchGetDataFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementSearchGetData(
      id: json['id'] as int?,
      recordDataId: json['record_data_id'] as String?,
      intdashMeasurementUuid: json['intdash_measurement_uuid'] as String?,
      mMemberId: json['m_member_id'] as int?,
      recordDatetimeFrom: json['record_datetime_from'] as String?,
      recordDatetimeTo: json['record_datetime_to'] as String?,
      recordName: json['record_name'] as String?,
      recordCore: (json['record_core'] as List<dynamic>?)
              ?.map((e) => RecordMeasurementGetRecordCore.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      analysisData: json['analysis_data'] == null
          ? null
          : AnalysisData.fromJson(
              json['analysis_data'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) =>
                  RecordMeasurementGetTags.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_RecordMeasurementSearchGetDataToJson(
        _$_RecordMeasurementSearchGetData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'record_data_id': instance.recordDataId,
      'intdash_measurement_uuid': instance.intdashMeasurementUuid,
      'm_member_id': instance.mMemberId,
      'record_datetime_from': instance.recordDatetimeFrom,
      'record_datetime_to': instance.recordDatetimeTo,
      'record_name': instance.recordName,
      'record_core': instance.recordCore,
      'analysis_data': instance.analysisData,
      'tags': instance.tags,
    };

_$_RecordMeasurementSessionSearchGetData
    _$$_RecordMeasurementSessionSearchGetDataFromJson(
            Map<String, dynamic> json) =>
        _$_RecordMeasurementSessionSearchGetData(
          id: json['id'] as int?,
          recordMeasurementSessionUuid:
              json['record_measurement_session_uuid'] as String?,
          measurementType: json['measurement_type'] as int?,
          mMemberId: json['m_member_id'] as int?,
          commentAdvise: json['comment_advise'] as String?,
          commentResult: json['comment_result'] as String?,
          analysisSummaryData: json['analysis_summary_data'] == null
              ? null
              : AnalysisSummaryData.fromJson(
                  json['analysis_summary_data'] as Map<String, dynamic>),
          recordMeasurement: (json['record_measurement'] as List<dynamic>?)
                  ?.map((e) =>
                      RecordMeasurementSessionGetRecordMeasurement.fromJson(
                          e as Map<String, dynamic>))
                  .toList() ??
              const [],
        );

Map<String, dynamic> _$$_RecordMeasurementSessionSearchGetDataToJson(
        _$_RecordMeasurementSessionSearchGetData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'record_measurement_session_uuid': instance.recordMeasurementSessionUuid,
      'measurement_type': instance.measurementType,
      'm_member_id': instance.mMemberId,
      'comment_advise': instance.commentAdvise,
      'comment_result': instance.commentResult,
      'analysis_summary_data': instance.analysisSummaryData,
      'record_measurement': instance.recordMeasurement,
    };

_$_RecordDataGetTags _$$_RecordDataGetTagsFromJson(Map<String, dynamic> json) =>
    _$_RecordDataGetTags(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
      firstPageUrl: json['first_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
      lastPageUrl: json['last_page_url'] as String?,
      path: json['path'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TagGetData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_RecordDataGetTagsToJson(
        _$_RecordDataGetTags instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'first_page_url': instance.firstPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'next_page_url': instance.nextPageUrl,
      'last_page_url': instance.lastPageUrl,
      'path': instance.path,
      'data': instance.data,
    };

_$_RecordMeasurementPostRecordCore _$$_RecordMeasurementPostRecordCoreFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementPostRecordCore(
      coreType: json['core_type'] as int?,
      coreVersion: json['core_version'] as String?,
      firmwareVersion: json['firmware_version'] as String?,
      mMeasurementPartId: json['m_measurement_part_id'] as int?,
      intdashMeasurementChannel: json['intdash_measurement_channel'] as int?,
      mDeviceId: json['m_device_id'] as int?,
    );

Map<String, dynamic> _$$_RecordMeasurementPostRecordCoreToJson(
        _$_RecordMeasurementPostRecordCore instance) =>
    <String, dynamic>{
      'core_type': instance.coreType,
      'core_version': instance.coreVersion,
      'firmware_version': instance.firmwareVersion,
      'm_measurement_part_id': instance.mMeasurementPartId,
      'intdash_measurement_channel': instance.intdashMeasurementChannel,
      'm_device_id': instance.mDeviceId,
    };

_$_RecordMeasurementGetRecordCore _$$_RecordMeasurementGetRecordCoreFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementGetRecordCore(
      id: json['id'] as int?,
      coreType: json['core_type'] as int?,
      coreVersion: json['core_version'] as String?,
      firmwareVersion: json['firmware_version'] as String?,
      mDeviceId: json['m_device_id'] as int?,
      tRecordMeasurementId: json['t_record_measurement_id'] as int?,
      mMeasurementPartId: json['m_measurement_part_id'] as int?,
      intdashMeasurementChannel: json['intdash_measurement_channel'] as int?,
      tRecordGaitAnalysisId: json['t_record_gait_analysis_id'] as int?,
      recordGaitAnalysis: json['record_gait_analysis'] == null
          ? null
          : RecordGaitAnalysisGet.fromJson(
              json['record_gait_analysis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_RecordMeasurementGetRecordCoreToJson(
        _$_RecordMeasurementGetRecordCore instance) =>
    <String, dynamic>{
      'id': instance.id,
      'core_type': instance.coreType,
      'core_version': instance.coreVersion,
      'firmware_version': instance.firmwareVersion,
      'm_device_id': instance.mDeviceId,
      't_record_measurement_id': instance.tRecordMeasurementId,
      'm_measurement_part_id': instance.mMeasurementPartId,
      'intdash_measurement_channel': instance.intdashMeasurementChannel,
      't_record_gait_analysis_id': instance.tRecordGaitAnalysisId,
      'record_gait_analysis': instance.recordGaitAnalysis,
    };

_$_RecordMeasurementGetTags _$$_RecordMeasurementGetTagsFromJson(
        Map<String, dynamic> json) =>
    _$_RecordMeasurementGetTags(
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
      firstPageUrl: json['first_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
      lastPageUrl: json['last_page_url'] as String?,
      path: json['path'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TagGetData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_RecordMeasurementGetTagsToJson(
        _$_RecordMeasurementGetTags instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'from': instance.from,
      'to': instance.to,
      'total': instance.total,
      'first_page_url': instance.firstPageUrl,
      'prev_page_url': instance.prevPageUrl,
      'next_page_url': instance.nextPageUrl,
      'last_page_url': instance.lastPageUrl,
      'path': instance.path,
      'data': instance.data,
    };

_$_NoteSearchGetData _$$_NoteSearchGetDataFromJson(Map<String, dynamic> json) =>
    _$_NoteSearchGetData(
      id: json['id'] as int?,
      mMemberId: json['m_member_id'] as int?,
      note: json['note'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_NoteSearchGetDataToJson(
        _$_NoteSearchGetData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_member_id': instance.mMemberId,
      'note': instance.note,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_GaitAnalysisStatusInputDetails _$$_GaitAnalysisStatusInputDetailsFromJson(
        Map<String, dynamic> json) =>
    _$_GaitAnalysisStatusInputDetails(
      included: json['included'] as bool?,
    );

Map<String, dynamic> _$$_GaitAnalysisStatusInputDetailsToJson(
        _$_GaitAnalysisStatusInputDetails instance) =>
    <String, dynamic>{
      'included': instance.included,
    };

_$_GaitAnalysisStatusOutputDetails _$$_GaitAnalysisStatusOutputDetailsFromJson(
        Map<String, dynamic> json) =>
    _$_GaitAnalysisStatusOutputDetails(
      included: json['included'] as bool?,
    );

Map<String, dynamic> _$$_GaitAnalysisStatusOutputDetailsToJson(
        _$_GaitAnalysisStatusOutputDetails instance) =>
    <String, dynamic>{
      'included': instance.included,
    };

_$_OfficeIntdashUserGetData _$$_OfficeIntdashUserGetDataFromJson(
        Map<String, dynamic> json) =>
    _$_OfficeIntdashUserGetData(
      id: json['id'] as int?,
      mOfficeId: json['m_office_id'] as int?,
      uuid: json['uuid'] as String?,
      name: json['name'] as String?,
      apiToken: json['api_token'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$_OfficeIntdashUserGetDataToJson(
        _$_OfficeIntdashUserGetData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'm_office_id': instance.mOfficeId,
      'uuid': instance.uuid,
      'name': instance.name,
      'api_token': instance.apiToken,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$_NoticeGetData _$$_NoticeGetDataFromJson(Map<String, dynamic> json) =>
    _$_NoticeGetData(
      member: json['member'] == null
          ? null
          : MemberRecordGet.fromJson(json['member'] as Map<String, dynamic>),
      ruleMessage: json['rule_message'] == null
          ? null
          : RuleMessageRecord.fromJson(
              json['rule_message'] as Map<String, dynamic>),
      noticed: json['noticed'] as bool?,
    );

Map<String, dynamic> _$$_NoticeGetDataToJson(_$_NoticeGetData instance) =>
    <String, dynamic>{
      'member': instance.member,
      'rule_message': instance.ruleMessage,
      'noticed': instance.noticed,
    };

_$_RecordMeasurementSessionGetRecordMeasurement
    _$$_RecordMeasurementSessionGetRecordMeasurementFromJson(
            Map<String, dynamic> json) =>
        _$_RecordMeasurementSessionGetRecordMeasurement(
          id: json['id'] as int?,
          recordDataId: json['record_data_id'] as String?,
          intdashMeasurementUuid: json['intdash_measurement_uuid'] as String?,
          mMemberId: json['m_member_id'] as int?,
          recordDatetimeFrom: json['record_datetime_from'] as String?,
          recordDatetimeTo: json['record_datetime_to'] as String?,
          recordName: json['record_name'] as String?,
          recordCore: (json['record_core'] as List<dynamic>?)
                  ?.map((e) => RecordMeasurementGetRecordCore.fromJson(
                      e as Map<String, dynamic>))
                  .toList() ??
              const [],
          analysisData: json['analysis_data'] == null
              ? null
              : AnalysisData.fromJson(
                  json['analysis_data'] as Map<String, dynamic>),
          tags: (json['tags'] as List<dynamic>?)
                  ?.map((e) => RecordMeasurementGetTags.fromJson(
                      e as Map<String, dynamic>))
                  .toList() ??
              const [],
        );

Map<String, dynamic> _$$_RecordMeasurementSessionGetRecordMeasurementToJson(
        _$_RecordMeasurementSessionGetRecordMeasurement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'record_data_id': instance.recordDataId,
      'intdash_measurement_uuid': instance.intdashMeasurementUuid,
      'm_member_id': instance.mMemberId,
      'record_datetime_from': instance.recordDatetimeFrom,
      'record_datetime_to': instance.recordDatetimeTo,
      'record_name': instance.recordName,
      'record_core': instance.recordCore,
      'analysis_data': instance.analysisData,
      'tags': instance.tags,
    };
