// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UseType _$UseTypeFromJson(Map<String, dynamic> json) => UseType(
      (json['id'] as num?)?.toInt(),
      (json['role_id'] as num?)?.toInt(),
      json['type'] as String?,
      json['support_cotent'] as String?,
      (json['amount'] as num?)?.toDouble(),
      (json['expiration_year'] as num?)?.toInt(),
      (json['expiration_month'] as num?)?.toInt(),
      (json['expiration_day'] as num?)?.toInt(),
      json['start_date'] as String?,
      json['end_date'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UseTypeToJson(UseType instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['role_id'] = instance.role_id;
  val['type'] = instance.type;
  val['support_cotent'] = instance.support_cotent;
  val['amount'] = instance.amount;
  val['expiration_year'] = instance.expiration_year;
  val['expiration_month'] = instance.expiration_month;
  val['expiration_day'] = instance.expiration_day;
  val['start_date'] = instance.start_date;
  val['end_date'] = instance.end_date;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
