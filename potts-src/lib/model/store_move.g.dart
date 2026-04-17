// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_move.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreMove _$StoreMoveFromJson(Map<String, dynamic> json) => StoreMove(
      (json['id'] as num?)?.toInt(),
      json['move_kbn'] as String?,
      (json['from_location_id'] as num?)?.toInt(),
      (json['to_location_id'] as num?)?.toInt(),
      (json['product_id'] as num?)?.toInt(),
      (json['move_num'] as num?)?.toInt(),
      (json['before_ad_num'] as num?)?.toInt(),
      (json['after_ad_num'] as num?)?.toInt(),
      json['adjust_date'] as String?,
      json['adjust_reason'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoreMoveToJson(StoreMove instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['move_kbn'] = instance.move_kbn;
  val['from_location_id'] = instance.from_location_id;
  val['to_location_id'] = instance.to_location_id;
  val['product_id'] = instance.product_id;
  val['move_num'] = instance.move_num;
  val['before_ad_num'] = instance.before_ad_num;
  val['after_ad_num'] = instance.after_ad_num;
  val['adjust_date'] = instance.adjust_date;
  val['adjust_reason'] = instance.adjust_reason;
  val['company_id'] = instance.company_id;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
