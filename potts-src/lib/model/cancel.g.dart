// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cancel _$CancelFromJson(Map<String, dynamic> json) => Cancel(
      (json['id'] as num?)?.toInt(),
      (json['user_id'] as num?)?.toInt(),
      (json['company_id'] as num?)?.toInt(),
      json['admin_confirm_status'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CancelToJson(Cancel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['user_id'] = instance.user_id;
  val['company_id'] = instance.company_id;
  val['admin_confirm_status'] = instance.admin_confirm_status;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
