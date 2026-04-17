// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Warehouse _$WarehouseFromJson(Map<String, dynamic> json) => Warehouse(
      (json['id'] as num?)?.toInt(),
      json['code'] as String?,
      json['name'] as String?,
      json['name_short'] as String?,
      json['kbn'] as String?,
      json['area'] as String?,
      json['postal_cd'] as String?,
      json['addr_1'] as String?,
      json['addr_2'] as String?,
      json['addr_3'] as String?,
      json['tel'] as String?,
      json['fax'] as String?,
      json['note1'] as String?,
      json['note2'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WarehouseToJson(Warehouse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['code'] = instance.code;
  val['name'] = instance.name;
  val['name_short'] = instance.name_short;
  val['kbn'] = instance.kbn;
  val['area'] = instance.area;
  val['postal_cd'] = instance.postal_cd;
  val['addr_1'] = instance.addr_1;
  val['addr_2'] = instance.addr_2;
  val['addr_3'] = instance.addr_3;
  val['tel'] = instance.tel;
  val['fax'] = instance.fax;
  val['note1'] = instance.note1;
  val['note2'] = instance.note2;
  val['company_id'] = instance.company_id;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
