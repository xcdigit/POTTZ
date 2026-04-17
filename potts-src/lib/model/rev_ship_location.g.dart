// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rev_ship_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RevShipLocation _$RevShipLocationFromJson(Map<String, dynamic> json) =>
    RevShipLocation(
      (json['id'] as num?)?.toInt(),
      json['rev_ship_line_no'] as String?,
      json['rev_ship_kbn'] as String?,
      (json['product_location_id'] as num?)?.toInt(),
      (json['stock'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RevShipLocationToJson(RevShipLocation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['rev_ship_line_no'] = instance.rev_ship_line_no;
  val['rev_ship_kbn'] = instance.rev_ship_kbn;
  val['product_location_id'] = instance.product_location_id;
  val['stock'] = instance.stock;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
