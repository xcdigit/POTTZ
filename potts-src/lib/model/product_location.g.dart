// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductLocation _$ProductLocationFromJson(Map<String, dynamic> json) =>
    ProductLocation(
      (json['id'] as num?)?.toInt(),
      (json['location_id'] as num?)?.toInt(),
      (json['stock_id'] as num?)?.toInt(),
      (json['product_id'] as num?)?.toInt(),
      (json['stock'] as num?)?.toInt(),
      (json['lock_stock'] as num?)?.toInt(),
      json['limit_date'] as String?,
      json['lot_no'] as String?,
      json['serial_no'] as String?,
      json['note'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductLocationToJson(ProductLocation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['location_id'] = instance.location_id;
  val['stock_id'] = instance.stock_id;
  val['product_id'] = instance.product_id;
  val['stock'] = instance.stock;
  val['lock_stock'] = instance.lock_stock;
  val['limit_date'] = instance.limit_date;
  val['lot_no'] = instance.lot_no;
  val['serial_no'] = instance.serial_no;
  val['note'] = instance.note;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
