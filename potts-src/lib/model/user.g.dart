// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      (json['id'] as num?)?.toInt(),
      json['code'] as String?,
      json['name'] as String?,
      (json['role_id'] as num?)?.toInt(),
      (json['organization_id'] as num?)?.toInt(),
      (json['company_id'] as num?)?.toInt(),
      json['status'] as String?,
      json['start_date'] as String?,
      json['end_date'] as String?,
      (json['language_id'] as num?)?.toInt(),
      json['email'] as String?,
      json['avatar'] as String?,
      json['description'] as String?,
      json['authenticator_key'] as String?,
      json['send_time'] as String?,
      json['mail_code'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['code'] = instance.code;
  val['name'] = instance.name;
  val['role_id'] = instance.role_id;
  val['organization_id'] = instance.organization_id;
  val['company_id'] = instance.company_id;
  val['status'] = instance.status;
  val['start_date'] = instance.start_date;
  val['end_date'] = instance.end_date;
  val['language_id'] = instance.language_id;
  val['email'] = instance.email;
  val['avatar'] = instance.avatar;
  val['description'] = instance.description;
  val['authenticator_key'] = instance.authenticator_key;
  val['send_time'] = instance.send_time;
  val['mail_code'] = instance.mail_code;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
