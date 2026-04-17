// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      (json['id'] as num?)?.toInt(),
      (json['warehouse_id'] as num?)?.toInt(),
      json['loc_cd'] as String?,
      json['kbn'] as String?,
      json['floor_cd'] as String?,
      json['room_cd'] as String?,
      json['zone_cd'] as String?,
      json['row_cd'] as String?,
      json['shelve_cd'] as String?,
      json['step_cd'] as String?,
      json['range_cd'] as String?,
      (json['keeping_volume'] as num?)?.toDouble(),
      json['area'] as String?,
      json['note1'] as String?,
      json['note2'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['warehouse_id'] = instance.warehouse_id;
  val['loc_cd'] = instance.loc_cd;
  val['kbn'] = instance.kbn;
  val['floor_cd'] = instance.floor_cd;
  val['room_cd'] = instance.room_cd;
  val['zone_cd'] = instance.zone_cd;
  val['row_cd'] = instance.row_cd;
  val['shelve_cd'] = instance.shelve_cd;
  val['step_cd'] = instance.step_cd;
  val['range_cd'] = instance.range_cd;
  val['keeping_volume'] = instance.keeping_volume;
  val['area'] = instance.area;
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
