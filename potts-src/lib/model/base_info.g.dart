// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseInfo _$BaseInfoFromJson(Map<String, dynamic> json) => BaseInfo(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['corporate_cd'] as String?,
      json['qrr_cd'] as String?,
      json['postal_cd'] as String?,
      json['addr_1'] as String?,
      json['addr_2'] as String?,
      json['addr_3'] as String?,
      json['tel'] as String?,
      json['fax'] as String?,
      json['url'] as String?,
      json['email'] as String?,
      json['business_hour'] as String?,
      json['free_time'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BaseInfoToJson(BaseInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['corporate_cd'] = instance.corporate_cd;
  val['qrr_cd'] = instance.qrr_cd;
  val['postal_cd'] = instance.postal_cd;
  val['addr_1'] = instance.addr_1;
  val['addr_2'] = instance.addr_2;
  val['addr_3'] = instance.addr_3;
  val['tel'] = instance.tel;
  val['fax'] = instance.fax;
  val['url'] = instance.url;
  val['email'] = instance.email;
  val['business_hour'] = instance.business_hour;
  val['free_time'] = instance.free_time;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
