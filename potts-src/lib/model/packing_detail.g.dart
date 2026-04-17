// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackingDetail _$PackingDetailFromJson(Map<String, dynamic> json) =>
    PackingDetail(
      (json['id'] as num?)?.toInt(),
      json['ship_no'] as String?,
      (json['packing_id'] as num?)?.toInt(),
      (json['product_num'] as num?)?.toInt(),
      json['product_weight'] as String?,
      json['product_volume'] as String?,
      json['note1'] as String?,
      json['note2'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PackingDetailToJson(PackingDetail instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['ship_no'] = instance.ship_no;
  val['packing_id'] = instance.packing_id;
  val['product_num'] = instance.product_num;
  val['product_weight'] = instance.product_weight;
  val['product_volume'] = instance.product_volume;
  val['note1'] = instance.note1;
  val['note2'] = instance.note2;
  val['company_id'] = instance.company_id;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
