// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      (json['id'] as num?)?.toInt(),
      (json['product_id'] as num?)?.toInt(),
      json['year_month'] as String?,
      (json['stock'] as num?)?.toInt(),
      (json['lock_stock'] as num?)?.toInt(),
      (json['before_stock'] as num?)?.toInt(),
      (json['in_stock'] as num?)?.toInt(),
      (json['out_stock'] as num?)?.toInt(),
      (json['adjust_stock'] as num?)?.toInt(),
      (json['inventory_stock'] as num?)?.toInt(),
      (json['move_in_stock'] as num?)?.toInt(),
      (json['move_out_stock'] as num?)?.toInt(),
      (json['return_stock'] as num?)?.toInt(),
      (json['company_id'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoreToJson(Store instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['product_id'] = instance.product_id;
  val['year_month'] = instance.year_month;
  val['stock'] = instance.stock;
  val['lock_stock'] = instance.lock_stock;
  val['before_stock'] = instance.before_stock;
  val['in_stock'] = instance.in_stock;
  val['out_stock'] = instance.out_stock;
  val['adjust_stock'] = instance.adjust_stock;
  val['inventory_stock'] = instance.inventory_stock;
  val['move_in_stock'] = instance.move_in_stock;
  val['move_out_stock'] = instance.move_out_stock;
  val['return_stock'] = instance.return_stock;
  val['company_id'] = instance.company_id;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
