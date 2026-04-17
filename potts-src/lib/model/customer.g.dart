// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['name_kana'] as String?,
      json['name_short'] as String?,
      json['corporation_number'] as String?,
      json['postal_cd'] as String?,
      json['classify_1'] as String?,
      json['classify_2'] as String?,
      json['classify_3'] as String?,
      json['country'] as String?,
      json['region'] as String?,
      json['addr_1'] as String?,
      json['addr_2'] as String?,
      json['addr_3'] as String?,
      json['addr_4'] as String?,
      json['tel'] as String?,
      json['fax'] as String?,
      json['owner_name'] as String?,
      json['contact'] as String?,
      json['contact_tel'] as String?,
      json['contact_fax'] as String?,
      json['contact_email'] as String?,
      json['company_note1'] as String?,
      json['company_note2'] as String?,
      json['application_start_date'] as String?,
      json['application_end_date'] as String?,
      json['limit_date_flg'] as String?,
      json['limit_date'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['name_kana'] = instance.name_kana;
  val['name_short'] = instance.name_short;
  val['corporation_number'] = instance.corporation_number;
  val['postal_cd'] = instance.postal_cd;
  val['classify_1'] = instance.classify_1;
  val['classify_2'] = instance.classify_2;
  val['classify_3'] = instance.classify_3;
  val['country'] = instance.country;
  val['region'] = instance.region;
  val['addr_1'] = instance.addr_1;
  val['addr_2'] = instance.addr_2;
  val['addr_3'] = instance.addr_3;
  val['addr_4'] = instance.addr_4;
  val['tel'] = instance.tel;
  val['fax'] = instance.fax;
  val['owner_name'] = instance.owner_name;
  val['contact'] = instance.contact;
  val['contact_tel'] = instance.contact_tel;
  val['contact_fax'] = instance.contact_fax;
  val['contact_email'] = instance.contact_email;
  val['company_note1'] = instance.company_note1;
  val['company_note2'] = instance.company_note2;
  val['application_start_date'] = instance.application_start_date;
  val['application_end_date'] = instance.application_end_date;
  val['limit_date_flg'] = instance.limit_date_flg;
  val['limit_date'] = instance.limit_date;
  val['company_id'] = instance.company_id;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
