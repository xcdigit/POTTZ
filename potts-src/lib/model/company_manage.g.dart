// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_manage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyManage _$CompanyManageFromJson(Map<String, dynamic> json) =>
    CompanyManage(
      (json['id'] as num?)?.toInt(),
      (json['company_id'] as num?)?.toInt(),
      json['start_date'] as String?,
      json['end_date'] as String?,
      (json['user_id'] as num?)?.toInt(),
      json['note'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CompanyManageToJson(CompanyManage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['company_id'] = instance.company_id;
  val['start_date'] = instance.start_date;
  val['end_date'] = instance.end_date;
  val['user_id'] = instance.user_id;
  val['note'] = instance.note;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
