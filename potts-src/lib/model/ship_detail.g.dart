// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ship_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipDetail _$ShipDetailFromJson(Map<String, dynamic> json) => ShipDetail(
      (json['id'] as num?)?.toInt(),
      (json['ship_id'] as num?)?.toInt(),
      json['ship_line_no'] as String?,
      (json['product_id'] as num?)?.toInt(),
      (json['ship_num'] as num?)?.toInt(),
      (json['product_price'] as num?)?.toDouble(),
      json['warehouse_no'] as String?,
      (json['location_id'] as num?)?.toInt(),
      (json['lock_num'] as num?)?.toInt(),
      (json['store_num'] as num?)?.toInt(),
      (json['check_num'] as num?)?.toInt(),
      (json['packing_num'] as num?)?.toInt(),
      json['lock_kbn'] as String?,
      json['store_kbn'] as String?,
      json['check_kbn'] as String?,
      json['packing_kbn'] as String?,
      json['confirm_kbn'] as String?,
      json['note1'] as String?,
      json['note2'] as String?,
      json['importerror_flg'] as String?,
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShipDetailToJson(ShipDetail instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['ship_id'] = instance.ship_id;
  val['ship_line_no'] = instance.ship_line_no;
  val['product_id'] = instance.product_id;
  val['ship_num'] = instance.ship_num;
  val['product_price'] = instance.product_price;
  val['warehouse_no'] = instance.warehouse_no;
  val['location_id'] = instance.location_id;
  val['lock_num'] = instance.lock_num;
  val['store_num'] = instance.store_num;
  val['check_num'] = instance.check_num;
  val['packing_num'] = instance.packing_num;
  val['lock_kbn'] = instance.lock_kbn;
  val['store_kbn'] = instance.store_kbn;
  val['check_kbn'] = instance.check_kbn;
  val['packing_kbn'] = instance.packing_kbn;
  val['confirm_kbn'] = instance.confirm_kbn;
  val['note1'] = instance.note1;
  val['note2'] = instance.note2;
  val['importerror_flg'] = instance.importerror_flg;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
