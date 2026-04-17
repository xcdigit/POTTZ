// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['name_kana'] as String?,
      json['name_short'] as String?,
      json['postal_cd'] as String?,
      json['addr_1'] as String?,
      json['addr_2'] as String?,
      json['addr_3'] as String?,
      json['tel'] as String?,
      json['fax'] as String?,
      json['owner_name'] as String?,
      json['contact'] as String?,
      json['contact_tel'] as String?,
      json['contact_fax'] as String?,
      json['contact_email'] as String?,
      json['company_note1'] as String?,
      json['company_note2'] as String?,
      json['start_date'] as String?,
      json['end_date'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) {
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
  val['postal_cd'] = instance.postal_cd;
  val['addr_1'] = instance.addr_1;
  val['addr_2'] = instance.addr_2;
  val['addr_3'] = instance.addr_3;
  val['tel'] = instance.tel;
  val['fax'] = instance.fax;
  val['owner_name'] = instance.owner_name;
  val['contact'] = instance.contact;
  val['contact_tel'] = instance.contact_tel;
  val['contact_fax'] = instance.contact_fax;
  val['contact_email'] = instance.contact_email;
  val['company_note1'] = instance.company_note1;
  val['company_note2'] = instance.company_note2;
  val['start_date'] = instance.start_date;
  val['end_date'] = instance.end_date;
  val['company_id'] = instance.company_id;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
