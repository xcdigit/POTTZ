// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postal_code_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostalCodeInfo _$PostalCodeInfoFromJson(Map<String, dynamic> json) =>
    PostalCodeInfo(
      (json['id'] as num?)?.toInt(),
      json['country'] as String?,
      json['postal_code'] as String?,
      json['city'] as String?,
      json['region'] as String?,
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PostalCodeInfoToJson(PostalCodeInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['country'] = instance.country;
  val['postal_code'] = instance.postal_code;
  val['city'] = instance.city;
  val['region'] = instance.region;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
