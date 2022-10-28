// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:katana_model_openapi/katana_model_openapi.dart';
// import 'package:katana_model_openapi_example/api-swagger.openapi.dart';

void main() {
  test("LoginAccount.decode", () {
    const json =
        """
{
  "id": 3,
  "firebase_id": "45kdsfhuasfk87668",
  "account_type": "App/Models/MCompanyUser",
  "account_id": 3,
  "email": "taro_yamamoto@aaa.com",
  "account": {
    "id": 3,
    "m_company_id": 3,
    "name": "ログイン者１",
    "company": {
      "id": 3,
      "name": "株式会社 〇〇フィットネス",
      "owner": "山本 太郎",
      "zip": "1110011",
      "address1": "13",
      "address2": "渋谷区渋谷",
      "address3": "1-1-1",
      "address4": "渋谷ビル 4F",
      "tel": "03-3333-3333",
      "email": "maru-fitness@info.co.jp"
    },
    "offices": [
      {
        "id": 13,
        "m_company_id": 3,
        "name": "株式会社 〇〇フィットネス",
        "owner": "山本 太郎",
        "zip": "1110011",
        "address1": "13",
        "address2": "渋谷区渋谷",
        "address3": "1-1-1",
        "address4": "渋谷ビル 4F",
        "tel": "03-3333-3333",
        "email": "maru-fitness@info.co.jp",
        "edgelimit": 5,
        "intdash_tenant_id": "5cdc75c9-ca87-4c68-936e-aa73ff1bb18s",
        "crm_flg": 1,
        "pivot": [
          {
            "m_company_user_id": 3,
            "m_office_id": 13
          }
        ]
      }
    ]
  },
  "roles": {
    "id": 20,
    "role_name": "member",
    "pivot": [
      {
        "m_login_account_id": 3,
        "m_role_id": 20
      }
    ],
    "permissions": [
      {
        "id": 10,
        "permission_name": "member_create",
        "pivot": [
          {
            "m_role_id": 20,
            "m_permission_id": 10
          }
        ],
        "created_at": "2021-03-12T12:23:05",
        "updated_at": "2021-03-12T12:23:05"
      }
    ],
    "created_at": "2021-03-12T12:23:05",
    "updated_at": "2021-03-12T12:23:05"
  },
  "created_at": "2021-02-28 13:05:21",
  "updated_at": "2021-02-28 15:23:41"
}
""";
    final loginAccount = LoginAccountRecord.fromJson(jsonDecode(json));
    print(loginAccount);
  });
  test("Member.decode", () {
    const json =
        """
  {
      "id": 3,
      "m_office_id": 13,
      "name": "山本 一郎",
      "name_kana": "ヤマモト イチロウ",
      "gender": 1,
      "birth_date": "1978-04-21",
      "height": 172.5,
      "weight": 68.3,
      "member_edges": [
        {
          "id": 3,
          "m_member_id": 2,
          "edge_uuid": "safsk3kd-4gakgjak-eeknfi9ns"
        }
      ],
      "member_links": [
        {
          "id": 3,
          "link_service": 1,
          "link_data": {
            "data_lake_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk1NmMwNDEwZmE1MjFjMTZlNDQ2NWE4ZjVjODU5NjZhNWY1MDk5NGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vb3JwaGVhbmFseXRpY3MtdGVzdCIsImF1ZCI6Im9ycGhlYW5hbHl0aWNzLXRlc3QiLCJhdXRoX3RpbWUiOjE2MzEyNTcyNjEsInVzZXJfaWQiOiJ2SEx5ZUpUZFZuZEdWQ0JSaTAyR1huSnQzeVgyIiwic3ViIjoidkhMeWVKVGRWbmRHVkNCUmkwMkdYbkp0M3lYMiIsImlhdCI6MTYzOTcyMDcyOSwiZXhwIjoxNjM5NzI0MzI5LCJlbWFpbCI6Im1oaXJvc2VAbm8tbmV3LWZvbGsuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsibWhpcm9zZUBuby1uZXctZm9say5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.T0g8S0VprKrDyMnw_BfY3yOWFoybZ023xEZxXtxgiNQfcS_cCV3gOQFSG9uTo6z8Y3b7Qvm35BzprP176f7TXm6MG_hgvfgsLMU1lUXWdThxSyLkr7IFeHjRc-3J8CjKNj6tL8UB3cMM1E4FqT8IBnhZohtRcrkrLffC_2MG-o2pSGaEfbm21e_In6VL7S70PKTMMlL_u69KPJhDm47vspzd44VrYAo24fTeNzZ0rkL0lwHHORFrwn5rKK-QrO4BetRyt4dRaMk-njhfPag0Y7c9pM8Rc-q3dWgzDvPL3vLcval-kdBKlLGOb43lkeeeT_utCLXHc9I-VteN3LwZfw",
            "data_lake_refresh_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk1NmMwNDEwZmE1MjFjMTZlNDQ2NWE4ZjVjODU5NjZhNWY1MDk5NGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vb3JwaGVhbmFseXRpY3MtdGVzdCIsImF1ZCI6Im9ycGhlYW5hbHl0aWNzLXRlc3QiLCJhdXRoX3RpbWUiOjE2MzEyNTcyNjEsInVzZXJfaWQiOiJ2SEx5ZUpUZFZuZEdWQ0JSaTAyR1huSnQzeVgyIiwic3ViIjoidkhMeWVKVGRWbmRHVkNCUmkwMkdYbkp0M3lYMiIsImlhdCI6MTYzOTcyMDcyOSwiZXhwIjoxNjM5NzI0MzI5LCJlbWFpbCI6Im1oaXJvc2VAbm8tbmV3LWZvbGsuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsibWhpcm9zZUBuby1uZXctZm9say5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.T0g8S0VprKrDyMnw_BfY3yOWFoybZ023xEZxXtxgiNQfcS_cCV3gOQFSG9uTo6z8Y3b7Qvm35BzprP176f7TXm6MG_hgvfgsLMU1lUXWdThxSyLkr7IFeHjRc-3J8CjKNj6tL8UB3cMM1E4FqT8IBnhZohtRcrkrLffC_2MG-o2pSGaEfbm21e_In6VL7S70PKTMMlL_u69KPJhDm47vspzd44VrYAo24fTeNzZ0rkL0lwHHORFrwn5rKK-QrO4BetRyt4dRaMk-njhfPag0Y7c9pM8Rc-q3dWgzDvPL3vLcval-kdBKlLGOb43lkeeeT_utCLXHc9I-VteN3LwZfw",
            "orphe_id": "40392",
            "tenant_id": "5f8cc13d-2017-4f4c-896c-638c7918a8sy"
          }
        }
      ],
      "record_measurement_sessions": [
        {
          "id": 3,
          "record_measurement_session_uuid": "safsk3kd-4gakgjak-eeknfi9ns",
          "measurement_type": 1,
          "m_member_id": 3,
          "comment_advise": "ストライドを意識すると良いでしょう",
          "comment_result": "徐々に改善がみられた",
          "analysis_summary_data": {
            "m_member_id": 3,
            "sort_id": "measurement_session#5#1",
            "aggregate_type": "monthly",
            "aggregate_conds": "2022-08",
            "measurement_type": 2,
            "record_from": "2021-03-05 00:00:00",
            "record_to": "2021-03-05 00:00:00",
            "gait_type": 0,
            "pace": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "distance": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "foot_strike_l": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "foot_strike_r": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "pronation_l": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "pronation_r": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "stride_l": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "stride_r": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "cadence_l": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "cadence_r": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "landing_time_l": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "landing_time_r": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "stride_height_l": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "stride_height_r": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "landing_force_l": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "landing_force_r": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "swing_phase_duration_l": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "swing_phase_duration_r": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "toe_off_angle_l": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "toe_off_angle_r": {
              "avg": 23.434,
              "max": 23.434,
              "min": 23.434,
              "med": 23.434
            },
            "summmary_datetime": "2021-03-05 00:00:00"
          },
          "record_measurement": [
            {
              "id": 2,
              "record_data_id": "3f0d4109-5944-44ea-86fb-e64807426741",
              "intdash_measurement_uuid": "9uJrk09-5a84-9uka-89sj-e648079jsdh41",
              "m_member_id": 3,
              "record_datetime_from": "2021-03-05 00:00:00",
              "record_datetime_to": "2021-03-05 23:59:59",
              "record_name": "テスト記録",
              "record_core": [
                {
                  "id": 2,
                  "core_type": 0,
                  "core_version": "2.0",
                  "firmware_version": "2.2(20211219.1)",
                  "m_device_id": 2,
                  "t_record_measurement_id": 2,
                  "m_measurement_part_id": 1,
                  "intdash_measurement_channel": 2,
                  "t_record_gait_analysis_id": 2,
                  "record_gait_analysis": {
                    "id": 2,
                    "pace": 312.2,
                    "distance": 1000,
                    "gait_type": 10,
                    "foot_strike_l": 3,
                    "foot_strike_r": 3,
                    "pronation_l": 3,
                    "pronation_r": 3,
                    "stride_l": 153,
                    "stride_r": 153,
                    "cadence_l": 160,
                    "cadence_r": 160,
                    "landing_time_l": 0.25,
                    "landing_time_r": 0.25,
                    "stride_height_l": 35,
                    "stride_height_r": 35,
                    "landing_force_l": 150,
                    "landing_force_r": 150,
                    "swing_phase_duration_l": 0.55,
                    "swing_phase_duration_r": 0.55,
                    "toe_off_angle_l": 3.2,
                    "toe_off_angle_r": 3.2,
                    "cyclic_stride_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_l.csv",
                    "cyclic_stride_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_r.csv",
                    "gait_analysis_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_l.csv",
                    "gait_analysis_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_r.csv",
                    "gaitanalysis_status": 2
                  }
                }
              ],
              "analysis_data": {
                "record_data_id": "safsk3kd-4gakgjak-eeknfi9ns",
                "analysis_type": 0,
                "pace": 312.2,
                "distance": 1000,
                "gait_type": 10,
                "foot_strike_l": 3,
                "foot_strike_r": 3,
                "pronation_l": 3,
                "pronation_r": 3,
                "stride_l": 153,
                "stride_r": 153,
                "cadence_l": 160,
                "cadence_r": 160,
                "landing_time_l": 0.25,
                "landing_time_r": 0.25,
                "stride_height_l": 35,
                "stride_height_r": 35,
                "landing_force_l": 150,
                "landing_force_r": 150,
                "swing_phase_duration_l": 0.55,
                "swing_phase_duration_r": 0.55,
                "toe_off_angle_l": 3.2,
                "toe_off_angle_r": 3.2,
                "cyclic_stride_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_l.csv",
                "cyclic_stride_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_r.csv",
                "gait_analysis_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_l.csv",
                "gait_analysis_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_r.csv",
                "gaitanalysis_status": 2
              },
              "tags": [
                {
                  "current_page": 1,
                  "last_page": 3,
                  "per_page": 10,
                  "from": 1,
                  "to": 10,
                  "total": 28,
                  "first_page_url": "https://xxxxx.com/api/tags?page=1",
                  "prev_page_url": null,
                  "next_page_url": "https://xxxxx.com/api/tags?page=2",
                  "last_page_url": "https://xxxxx.com/api/tags?page=3",
                  "path": "https://xxxxx.com/api/members/13",
                  "data": [
                    {
                      "id": 62,
                      "m_office_id": 3,
                      "tag_name": "膝関節症",
                      "created_at": "2021-02-28 13:05:21",
                      "updated_at": "2021-02-28 15:23:41"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ],
      "created_at": "2021-02-28 13:05:21",
      "updated_at": "2021-02-28 15:23:41",
      "deleted_at": "2021-03-05 10:03:05"
    }
""";
    final memberRecordGet = MemberRecordGet.fromJson(jsonDecode(json));
    print(memberRecordGet);
  });
  test("Session.decode", () {
    const json =
        """
    {
      "id": 3,
      "record_measurement_session_uuid": "safsk3kd-4gakgjak-eeknfi9ns",
      "measurement_type": 1,
      "m_member_id": 3,
      "comment_advise": "ストライドを意識すると良いでしょう",
      "comment_result": "徐々に改善がみられた",
      "analysis_summary_data": {
        "m_member_id": 3,
        "sort_id": "measurement_session#5#1",
        "aggregate_type": "monthly",
        "aggregate_conds": "2022-08",
        "measurement_type": 2,
        "record_from": "2021-03-05 00:00:00",
        "record_to": "2021-03-05 00:00:00",
        "gait_type": 0,
        "pace": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "distance": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "foot_strike_l": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "foot_strike_r": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "pronation_l": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "pronation_r": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "stride_l": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "stride_r": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "cadence_l": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "cadence_r": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "landing_time_l": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "landing_time_r": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "stride_height_l": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "stride_height_r": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "landing_force_l": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "landing_force_r": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "swing_phase_duration_l": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "swing_phase_duration_r": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "toe_off_angle_l": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "toe_off_angle_r": {
          "avg": 23.434,
          "max": 23.434,
          "min": 23.434,
          "med": 23.434
        },
        "summmary_datetime": "2021-03-05 00:00:00"
      },
      "record_measurement": [
        {
          "id": 2,
          "record_data_id": "3f0d4109-5944-44ea-86fb-e64807426741",
          "intdash_measurement_uuid": "9uJrk09-5a84-9uka-89sj-e648079jsdh41",
          "m_member_id": 3,
          "record_datetime_from": "2021-03-05 00:00:00",
          "record_datetime_to": "2021-03-05 23:59:59",
          "record_name": "テスト記録",
          "record_core": [
            {
              "id": 2,
              "core_type": 0,
              "core_version": "2.0",
              "firmware_version": "2.2(20211219.1)",
              "m_device_id": 2,
              "t_record_measurement_id": 2,
              "m_measurement_part_id": 1,
              "intdash_measurement_channel": 2,
              "t_record_gait_analysis_id": 2,
              "record_gait_analysis": {
                "id": 2,
                "pace": 312.2,
                "distance": 1000,
                "gait_type": 10,
                "foot_strike_l": 3,
                "foot_strike_r": 3,
                "pronation_l": 3,
                "pronation_r": 3,
                "stride_l": 153,
                "stride_r": 153,
                "cadence_l": 160,
                "cadence_r": 160,
                "landing_time_l": 0.25,
                "landing_time_r": 0.25,
                "stride_height_l": 35,
                "stride_height_r": 35,
                "landing_force_l": 150,
                "landing_force_r": 150,
                "swing_phase_duration_l": 0.55,
                "swing_phase_duration_r": 0.55,
                "toe_off_angle_l": 3.2,
                "toe_off_angle_r": 3.2,
                "cyclic_stride_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_l.csv",
                "cyclic_stride_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_r.csv",
                "gait_analysis_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_l.csv",
                "gait_analysis_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_r.csv",
                "gaitanalysis_status": 2
              }
            }
          ],
          "analysis_data": {
            "record_data_id": "safsk3kd-4gakgjak-eeknfi9ns",
            "analysis_type": 0,
            "pace": 312.2,
            "distance": 1000,
            "gait_type": 10,
            "foot_strike_l": 3,
            "foot_strike_r": 3,
            "pronation_l": 3,
            "pronation_r": 3,
            "stride_l": 153,
            "stride_r": 153,
            "cadence_l": 160,
            "cadence_r": 160,
            "landing_time_l": 0.25,
            "landing_time_r": 0.25,
            "stride_height_l": 35,
            "stride_height_r": 35,
            "landing_force_l": 150,
            "landing_force_r": 150,
            "swing_phase_duration_l": 0.55,
            "swing_phase_duration_r": 0.55,
            "toe_off_angle_l": 3.2,
            "toe_off_angle_r": 3.2,
            "cyclic_stride_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_l.csv",
            "cyclic_stride_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_r.csv",
            "gait_analysis_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_l.csv",
            "gait_analysis_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_r.csv",
            "gaitanalysis_status": 2
          },
          "tags": [
            {
              "current_page": 1,
              "last_page": 3,
              "per_page": 10,
              "from": 1,
              "to": 10,
              "total": 28,
              "first_page_url": "https://xxxxx.com/api/tags?page=1",
              "prev_page_url": null,
              "next_page_url": "https://xxxxx.com/api/tags?page=2",
              "last_page_url": "https://xxxxx.com/api/tags?page=3",
              "path": "https://xxxxx.com/api/members/13",
              "data": [
                {
                  "id": 62,
                  "m_office_id": 3,
                  "tag_name": "膝関節症",
                  "created_at": "2021-02-28 13:05:21",
                  "updated_at": "2021-02-28 15:23:41"
                }
              ]
            }
          ]
        }
      ]
    }
""";
    final sessionRecordGet =
        RecordMeasurementSessionGet.fromJson(jsonDecode(json));
    print(sessionRecordGet);
  });
  test("Measurement.decode", () {
    const json =
        """
    {
      "id": 2,
      "record_data_id": "3f0d4109-5944-44ea-86fb-e64807426741",
      "intdash_measurement_uuid": "9uJrk09-5a84-9uka-89sj-e648079jsdh41",
      "m_member_id": 3,
      "record_datetime_from": "2021-03-05 00:00:00",
      "record_datetime_to": "2021-03-05 23:59:59",
      "record_name": "テスト記録",
      "record_core": [
        {
          "id": 2,
          "core_type": 0,
          "core_version": "2.0",
          "firmware_version": "2.2(20211219.1)",
          "m_device_id": 2,
          "t_record_measurement_id": 2,
          "m_measurement_part_id": 1,
          "intdash_measurement_channel": 2,
          "t_record_gait_analysis_id": 2,
          "record_gait_analysis": {
            "id": 2,
            "pace": 312.2,
            "distance": 1000,
            "gait_type": 10,
            "foot_strike_l": 3,
            "foot_strike_r": 3,
            "pronation_l": 3,
            "pronation_r": 3,
            "stride_l": 153,
            "stride_r": 153,
            "cadence_l": 160,
            "cadence_r": 160,
            "landing_time_l": 0.25,
            "landing_time_r": 0.25,
            "stride_height_l": 35,
            "stride_height_r": 35,
            "landing_force_l": 150,
            "landing_force_r": 150,
            "swing_phase_duration_l": 0.55,
            "swing_phase_duration_r": 0.55,
            "toe_off_angle_l": 3.2,
            "toe_off_angle_r": 3.2,
            "cyclic_stride_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_l.csv",
            "cyclic_stride_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_r.csv",
            "gait_analysis_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_l.csv",
            "gait_analysis_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_r.csv",
            "gaitanalysis_status": 2
          }
        }
      ],
      "analysis_data": {
        "record_data_id": "safsk3kd-4gakgjak-eeknfi9ns",
        "analysis_type": 0,
        "pace": 312.2,
        "distance": 1000,
        "gait_type": 10,
        "foot_strike_l": 3,
        "foot_strike_r": 3,
        "pronation_l": 3,
        "pronation_r": 3,
        "stride_l": 153,
        "stride_r": 153,
        "cadence_l": 160,
        "cadence_r": 160,
        "landing_time_l": 0.25,
        "landing_time_r": 0.25,
        "stride_height_l": 35,
        "stride_height_r": 35,
        "landing_force_l": 150,
        "landing_force_r": 150,
        "swing_phase_duration_l": 0.55,
        "swing_phase_duration_r": 0.55,
        "toe_off_angle_l": 3.2,
        "toe_off_angle_r": 3.2,
        "cyclic_stride_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_l.csv",
        "cyclic_stride_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_r.csv",
        "gait_analysis_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_l.csv",
        "gait_analysis_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_r.csv",
        "gaitanalysis_status": 2
      },
      "tags": [
        {
          "current_page": 1,
          "last_page": 3,
          "per_page": 10,
          "from": 1,
          "to": 10,
          "total": 28,
          "first_page_url": "https://xxxxx.com/api/tags?page=1",
          "prev_page_url": null,
          "next_page_url": "https://xxxxx.com/api/tags?page=2",
          "last_page_url": "https://xxxxx.com/api/tags?page=3",
          "path": "https://xxxxx.com/api/members/13",
          "data": [
            {
              "id": 62,
              "m_office_id": 3,
              "tag_name": "膝関節症",
              "created_at": "2021-02-28 13:05:21",
              "updated_at": "2021-02-28 15:23:41"
            }
          ]
        }
      ]
    }
""";
    final measurement = RecordMeasurementGet.fromJson(jsonDecode(json));
    print(measurement);
  });
  test("Note.decode", () {
    const json =
        """
    {
      "id": 62,
      "m_member_id": 3,
      "note": "痛みの報告あり。ストレッチが必要。",
      "created_at": "2021-02-28 13:05:21",
      "updated_at": "2021-02-28 15:23:41"
    }
""";
    final note = NoteGet.fromJson(jsonDecode(json));
    print(note);
  });
  test("Edge.decode", () {
    const json =
        """
{
  "id": 3,
  "m_member_id": 2,
  "edge_uuid": "safsk3kd-4gakgjak-eeknfi9ns"
}
""";
    final note = EdgeAvailableGet.fromJson(jsonDecode(json));
    print(note);
  });
  test("Tag.decode", () {
    const json =
        """
    {
      "id": 62,
      "m_office_id": 3,
      "tag_name": "膝関節症",
      "created_at": "2021-02-28 13:05:21",
      "updated_at": "2021-02-28 15:23:41"
    }
""";
    final note = TagGetData.fromJson(jsonDecode(json));
    print(note);
  });
  test("Notice.decode", () {
    const json =
        """
    {
      "member": {
        "id": 3,
        "m_office_id": 13,
        "name": "山本 一郎",
        "name_kana": "ヤマモト イチロウ",
        "gender": 1,
        "birth_date": "1978-04-21",
        "height": 172.5,
        "weight": 68.3,
        "member_edges": [
          {
            "id": 3,
            "m_member_id": 2,
            "edge_uuid": "safsk3kd-4gakgjak-eeknfi9ns"
          }
        ],
        "member_links": [
          {
            "id": 3,
            "link_service": 1,
            "link_data": {
              "data_lake_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk1NmMwNDEwZmE1MjFjMTZlNDQ2NWE4ZjVjODU5NjZhNWY1MDk5NGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vb3JwaGVhbmFseXRpY3MtdGVzdCIsImF1ZCI6Im9ycGhlYW5hbHl0aWNzLXRlc3QiLCJhdXRoX3RpbWUiOjE2MzEyNTcyNjEsInVzZXJfaWQiOiJ2SEx5ZUpUZFZuZEdWQ0JSaTAyR1huSnQzeVgyIiwic3ViIjoidkhMeWVKVGRWbmRHVkNCUmkwMkdYbkp0M3lYMiIsImlhdCI6MTYzOTcyMDcyOSwiZXhwIjoxNjM5NzI0MzI5LCJlbWFpbCI6Im1oaXJvc2VAbm8tbmV3LWZvbGsuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsibWhpcm9zZUBuby1uZXctZm9say5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.T0g8S0VprKrDyMnw_BfY3yOWFoybZ023xEZxXtxgiNQfcS_cCV3gOQFSG9uTo6z8Y3b7Qvm35BzprP176f7TXm6MG_hgvfgsLMU1lUXWdThxSyLkr7IFeHjRc-3J8CjKNj6tL8UB3cMM1E4FqT8IBnhZohtRcrkrLffC_2MG-o2pSGaEfbm21e_In6VL7S70PKTMMlL_u69KPJhDm47vspzd44VrYAo24fTeNzZ0rkL0lwHHORFrwn5rKK-QrO4BetRyt4dRaMk-njhfPag0Y7c9pM8Rc-q3dWgzDvPL3vLcval-kdBKlLGOb43lkeeeT_utCLXHc9I-VteN3LwZfw",
              "data_lake_refresh_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk1NmMwNDEwZmE1MjFjMTZlNDQ2NWE4ZjVjODU5NjZhNWY1MDk5NGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vb3JwaGVhbmFseXRpY3MtdGVzdCIsImF1ZCI6Im9ycGhlYW5hbHl0aWNzLXRlc3QiLCJhdXRoX3RpbWUiOjE2MzEyNTcyNjEsInVzZXJfaWQiOiJ2SEx5ZUpUZFZuZEdWQ0JSaTAyR1huSnQzeVgyIiwic3ViIjoidkhMeWVKVGRWbmRHVkNCUmkwMkdYbkp0M3lYMiIsImlhdCI6MTYzOTcyMDcyOSwiZXhwIjoxNjM5NzI0MzI5LCJlbWFpbCI6Im1oaXJvc2VAbm8tbmV3LWZvbGsuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsibWhpcm9zZUBuby1uZXctZm9say5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.T0g8S0VprKrDyMnw_BfY3yOWFoybZ023xEZxXtxgiNQfcS_cCV3gOQFSG9uTo6z8Y3b7Qvm35BzprP176f7TXm6MG_hgvfgsLMU1lUXWdThxSyLkr7IFeHjRc-3J8CjKNj6tL8UB3cMM1E4FqT8IBnhZohtRcrkrLffC_2MG-o2pSGaEfbm21e_In6VL7S70PKTMMlL_u69KPJhDm47vspzd44VrYAo24fTeNzZ0rkL0lwHHORFrwn5rKK-QrO4BetRyt4dRaMk-njhfPag0Y7c9pM8Rc-q3dWgzDvPL3vLcval-kdBKlLGOb43lkeeeT_utCLXHc9I-VteN3LwZfw",
              "orphe_id": "40392",
              "tenant_id": "5f8cc13d-2017-4f4c-896c-638c7918a8sy"
            }
          }
        ],
        "record_measurement_sessions": [
          {
            "id": 3,
            "record_measurement_session_uuid": "safsk3kd-4gakgjak-eeknfi9ns",
            "measurement_type": 1,
            "m_member_id": 3,
            "comment_advise": "ストライドを意識すると良いでしょう",
            "comment_result": "徐々に改善がみられた",
            "analysis_summary_data": {
              "m_member_id": 3,
              "sort_id": "measurement_session#5#1",
              "aggregate_type": "monthly",
              "aggregate_conds": "2022-08",
              "measurement_type": 2,
              "record_from": "2021-03-05 00:00:00",
              "record_to": "2021-03-05 00:00:00",
              "gait_type": 0,
              "pace": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "distance": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "foot_strike_l": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "foot_strike_r": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "pronation_l": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "pronation_r": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "stride_l": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "stride_r": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "cadence_l": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "cadence_r": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "landing_time_l": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "landing_time_r": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "stride_height_l": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "stride_height_r": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "landing_force_l": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "landing_force_r": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "swing_phase_duration_l": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "swing_phase_duration_r": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "toe_off_angle_l": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "toe_off_angle_r": {
                "avg": 23.434,
                "max": 23.434,
                "min": 23.434,
                "med": 23.434
              },
              "summmary_datetime": "2021-03-05 00:00:00"
            },
            "record_measurement": [
              {
                "id": 2,
                "record_data_id": "3f0d4109-5944-44ea-86fb-e64807426741",
                "intdash_measurement_uuid": "9uJrk09-5a84-9uka-89sj-e648079jsdh41",
                "m_member_id": 3,
                "record_datetime_from": "2021-03-05 00:00:00",
                "record_datetime_to": "2021-03-05 23:59:59",
                "record_name": "テスト記録",
                "record_core": [
                  {
                    "id": 2,
                    "core_type": 0,
                    "core_version": "2.0",
                    "firmware_version": "2.2(20211219.1)",
                    "m_device_id": 2,
                    "t_record_measurement_id": 2,
                    "m_measurement_part_id": 1,
                    "intdash_measurement_channel": 2,
                    "t_record_gait_analysis_id": 2,
                    "record_gait_analysis": {
                      "id": 2,
                      "pace": 312.2,
                      "distance": 1000,
                      "gait_type": 10,
                      "foot_strike_l": 3,
                      "foot_strike_r": 3,
                      "pronation_l": 3,
                      "pronation_r": 3,
                      "stride_l": 153,
                      "stride_r": 153,
                      "cadence_l": 160,
                      "cadence_r": 160,
                      "landing_time_l": 0.25,
                      "landing_time_r": 0.25,
                      "stride_height_l": 35,
                      "stride_height_r": 35,
                      "landing_force_l": 150,
                      "landing_force_r": 150,
                      "swing_phase_duration_l": 0.55,
                      "swing_phase_duration_r": 0.55,
                      "toe_off_angle_l": 3.2,
                      "toe_off_angle_r": 3.2,
                      "cyclic_stride_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_l.csv",
                      "cyclic_stride_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_r.csv",
                      "gait_analysis_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_l.csv",
                      "gait_analysis_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_r.csv",
                      "gaitanalysis_status": 2
                    }
                  }
                ],
                "analysis_data": {
                  "record_data_id": "safsk3kd-4gakgjak-eeknfi9ns",
                  "analysis_type": 0,
                  "pace": 312.2,
                  "distance": 1000,
                  "gait_type": 10,
                  "foot_strike_l": 3,
                  "foot_strike_r": 3,
                  "pronation_l": 3,
                  "pronation_r": 3,
                  "stride_l": 153,
                  "stride_r": 153,
                  "cadence_l": 160,
                  "cadence_r": 160,
                  "landing_time_l": 0.25,
                  "landing_time_r": 0.25,
                  "stride_height_l": 35,
                  "stride_height_r": 35,
                  "landing_force_l": 150,
                  "landing_force_r": 150,
                  "swing_phase_duration_l": 0.55,
                  "swing_phase_duration_r": 0.55,
                  "toe_off_angle_l": 3.2,
                  "toe_off_angle_r": 3.2,
                  "cyclic_stride_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_l.csv",
                  "cyclic_stride_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/cyclicStride_xxx_r.csv",
                  "gait_analysis_file_l": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_l.csv",
                  "gait_analysis_file_r": "record_data/3/3f0d4109-5944-44ea-86fb-e64807426741/2021/03/12/gaitAnalysisResult_xxx_r.csv",
                  "gaitanalysis_status": 2
                },
                "tags": [
                  {
                    "current_page": 1,
                    "last_page": 3,
                    "per_page": 10,
                    "from": 1,
                    "to": 10,
                    "total": 28,
                    "first_page_url": "https://xxxxx.com/api/tags?page=1",
                    "prev_page_url": null,
                    "next_page_url": "https://xxxxx.com/api/tags?page=2",
                    "last_page_url": "https://xxxxx.com/api/tags?page=3",
                    "path": "https://xxxxx.com/api/members/13",
                    "data": [
                      {
                        "id": 62,
                        "m_office_id": 3,
                        "tag_name": "膝関節症",
                        "created_at": "2021-02-28 13:05:21",
                        "updated_at": "2021-02-28 15:23:41"
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ],
        "created_at": "2021-02-28 13:05:21",
        "updated_at": "2021-02-28 15:23:41",
        "deleted_at": "2021-03-05 10:03:05"
      },
      "rule_message": {
        "id": 3,
        "m_rule_id": 2,
        "m_communication_type_id": 3,
        "message": "ストライドが先週から30％以上減少しています",
        "rule": {
          "id": 2,
          "name": "歩数変化前週比30％",
          "m_indicator_id": 3,
          "rule": "'cadance' > '30%' since between('created_at', ['2022-02-01','2022-03-01'])",
          "priority": 0,
          "indicator": {
            "id": 3,
            "name": "cadance",
            "created_at": "2021-02-28 13:05:21",
            "updated_at": "2021-02-28 15:23:41"
          },
          "created_at": "2021-02-28 13:05:21",
          "updated_at": "2021-02-28 15:23:41"
        },
        "created_at": "2021-02-28 13:05:21",
        "updated_at": "2021-02-28 15:23:41"
      },
      "noticed": true
    }
""";
    final notice = NoticeGetData.fromJson(jsonDecode(json));
    print(notice);
  });

  test("APIToken.decode", () {
    const json =
        """
    {
      "id": 3,
      "m_office_id": 2,
      "uuid": "e757da66-a40a-4eaf-a38a-3338b74e5e59",
      "name": "edge_admin",
      "api_token": "olwFXYouTXWDa...IOlC9-z-69",
      "created_at": "2021-02-28 13:05:21",
      "updated_at": "2021-02-28 15:23:41"
    }
""";
    final token = OfficeIntdashUser.fromJson(jsonDecode(json));
    print(token);
  });

  test("APIToken.decode", () {
    const json =
        """
    {
      "id": 3,
      "m_office_id": 2,
      "uuid": "e757da66-a40a-4eaf-a38a-3338b74e5e59",
      "name": "edge_admin",
      "api_token": "olwFXYouTXWDa...IOlC9-z-69",
      "created_at": "2021-02-28 13:05:21",
      "updated_at": "2021-02-28 15:23:41"
    }
""";
    final token = OfficeIntdashUser.fromJson(jsonDecode(json));
    print(token);
  });
  test("EdgeHistory.decode", () {
    const json =
        """
    {
    "id": 1,
    "edge_uuid": "safsk3kd-4gakgjak-eeknfi9ns",
    "intdash_measurement_uuid": "9uJrk09-5a84-9uka-89sj-e648079jsdh41",
    "start_datetime": "2021-10-15 15:25:10",
    "end_datetime": "2021-10-15 15:28:22",
    "batch_end_flg": 0
  }
""";
    final available = EdgeAvailableGet.fromJson(jsonDecode(json));
    print(available);
  });
  test("EdgeHistory.decode", () {
    const json =
        """
    {
    "id": 1,
    "edge_uuid": "safsk3kd-4gakgjak-eeknfi9ns",
    "intdash_measurement_uuid": "9uJrk09-5a84-9uka-89sj-e648079jsdh41",
    "start_datetime": "2021-10-15 15:25:10",
    "end_datetime": "2021-10-15 15:28:22",
    "batch_end_flg": 0
  }
""";
    final available = EdgeAvailableGet.fromJson(jsonDecode(json));
    print(available);
  });
  test("EdgeHistory.decode", () {
    const json =
        """
    {
    "id": 1,
    "edge_uuid": "safsk3kd-4gakgjak-eeknfi9ns",
    "intdash_measurement_uuid": "9uJrk09-5a84-9uka-89sj-e648079jsdh41",
    "start_datetime": "2021-10-15 15:25:10",
    "end_datetime": "2021-10-15 15:28:22",
    "batch_end_flg": 0
  }
""";
    final available = EdgeAvailableGet.fromJson(jsonDecode(json));
    print(available);
  });
}
