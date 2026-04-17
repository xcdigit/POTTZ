// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnDetail _$ReturnDetailFromJson(Map<String, dynamic> json) => ReturnDetail(
      (json['id'] as num?)?.toInt(),
      (json['return_id'] as num?)?.toInt(),
      json['rev_ship_line_no'] as String?,
      (json['product_id'] as num?)?.toInt(),
      (json['location_id'] as num?)?.toInt(),
      (json['return_num'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReturnDetailToJson(ReturnDetail instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['return_id'] = instance.return_id;
  val['rev_ship_line_no'] = instance.rev_ship_line_no;
  val['product_id'] = instance.product_id;
  val['location_id'] = instance.location_id;
  val['return_num'] = instance.return_num;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
