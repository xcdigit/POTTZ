// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authority.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Authority _$AuthorityFromJson(Map<String, dynamic> json) => Authority(
      (json['id'] as num?)?.toInt(),
      (json['role_id'] as num?)?.toInt(),
      (json['menu_id'] as num?)?.toInt(),
      json['auth'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AuthorityToJson(Authority instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['role_id'] = instance.role_id;
  val['menu_id'] = instance.menu_id;
  val['auth'] = instance.auth;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
