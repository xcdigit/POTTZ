// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization(
      (json['id'] as num?)?.toInt(),
      (json['parent_id'] as num?)?.toInt(),
      json['code'] as String?,
      json['name'] as String?,
      json['content'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrganizationToJson(Organization instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['parent_id'] = instance.parent_id;
  val['code'] = instance.code;
  val['name'] = instance.name;
  val['content'] = instance.content;
  val['company_id'] = instance.company_id;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
