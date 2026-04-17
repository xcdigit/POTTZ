// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_manage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserManage _$UserManageFromJson(Map<String, dynamic> json) => UserManage(
      (json['id'] as num?)?.toInt(),
      (json['company_id'] as num?)?.toInt(),
      (json['user_id'] as num?)?.toInt(),
      (json['use_type_id'] as num?)?.toInt(),
      json['start_date'] as String?,
      json['end_date'] as String?,
      json['pay_status'] as String?,
      (json['pay_total'] as num?)?.toDouble(),
      json['pay_no'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserManageToJson(UserManage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['company_id'] = instance.company_id;
  val['user_id'] = instance.user_id;
  val['use_type_id'] = instance.use_type_id;
  val['start_date'] = instance.start_date;
  val['end_date'] = instance.end_date;
  val['pay_status'] = instance.pay_status;
  val['pay_total'] = instance.pay_total;
  val['pay_no'] = instance.pay_no;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
