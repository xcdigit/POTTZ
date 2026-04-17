// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inventory _$InventoryFromJson(Map<String, dynamic> json) => Inventory(
      (json['id'] as num?)?.toInt(),
      (json['warehouse_id'] as num?)?.toInt(),
      json['start_date'] as String?,
      json['confirm_date'] as String?,
      json['confirm_flg'] as String?,
      json['csv_kbn'] as String?,
      json['note1'] as String?,
      json['note2'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InventoryToJson(Inventory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['warehouse_id'] = instance.warehouse_id;
  val['start_date'] = instance.start_date;
  val['confirm_date'] = instance.confirm_date;
  val['confirm_flg'] = instance.confirm_flg;
  val['csv_kbn'] = instance.csv_kbn;
  val['note1'] = instance.note1;
  val['note2'] = instance.note2;
  val['company_id'] = instance.company_id;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
