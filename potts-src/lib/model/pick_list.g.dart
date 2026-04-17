// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pick_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickList _$PickListFromJson(Map<String, dynamic> json) => PickList(
      (json['id'] as num?)?.toInt(),
      (json['ship_id'] as num?)?.toInt(),
      json['ship_line_no'] as String?,
      json['pick_line_no'] as String?,
      (json['product_id'] as num?)?.toInt(),
      (json['product_price'] as num?)?.toDouble(),
      json['warehouse_no'] as String?,
      (json['from_location_id'] as num?)?.toInt(),
      (json['to_location_id'] as num?)?.toInt(),
      (json['lock_num'] as num?)?.toInt(),
      json['store_kbn'] as String?,
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PickListToJson(PickList instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['ship_id'] = instance.ship_id;
  val['ship_line_no'] = instance.ship_line_no;
  val['pick_line_no'] = instance.pick_line_no;
  val['product_id'] = instance.product_id;
  val['product_price'] = instance.product_price;
  val['warehouse_no'] = instance.warehouse_no;
  val['from_location_id'] = instance.from_location_id;
  val['to_location_id'] = instance.to_location_id;
  val['lock_num'] = instance.lock_num;
  val['store_kbn'] = instance.store_kbn;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
