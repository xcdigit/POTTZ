// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryDetail _$InventoryDetailFromJson(Map<String, dynamic> json) =>
    InventoryDetail(
      (json['id'] as num?)?.toInt(),
      (json['inventory_id'] as num?)?.toInt(),
      (json['location_id'] as num?)?.toInt(),
      (json['product_id'] as num?)?.toInt(),
      (json['real_num'] as num?)?.toInt(),
      (json['logic_num'] as num?)?.toInt(),
      json['limit_date'] as String?,
      json['lot_no'] as String?,
      json['serial_no'] as String?,
      json['note'] as String?,
      json['diff_kbn'] as String?,
      json['diff_reason'] as String?,
      json['end_kbn'] as String?,
      json['note1'] as String?,
      json['note2'] as String?,
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InventoryDetailToJson(InventoryDetail instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['inventory_id'] = instance.inventory_id;
  val['location_id'] = instance.location_id;
  val['product_id'] = instance.product_id;
  val['real_num'] = instance.real_num;
  val['logic_num'] = instance.logic_num;
  val['limit_date'] = instance.limit_date;
  val['lot_no'] = instance.lot_no;
  val['serial_no'] = instance.serial_no;
  val['note'] = instance.note;
  val['diff_kbn'] = instance.diff_kbn;
  val['diff_reason'] = instance.diff_reason;
  val['end_kbn'] = instance.end_kbn;
  val['note1'] = instance.note1;
  val['note2'] = instance.note2;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
