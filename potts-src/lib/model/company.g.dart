// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['name_short'] as String?,
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
      json['status'] as String?,
      json['forced_shipment_flag'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CompanyToJson(Company instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['name_short'] = instance.name_short;
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
  val['status'] = instance.status;
  val['forced_shipment_flag'] = instance.forced_shipment_flag;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
