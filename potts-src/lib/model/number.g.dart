// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Number _$NumberFromJson(Map<String, dynamic> json) => Number(
      (json['id'] as num?)?.toInt(),
      (json['company_id'] as num?)?.toInt(),
      json['wms_channel'] as String?,
      json['year_month'] as String?,
      (json['seq_no'] as num?)?.toInt(),
      json['init_datetime'] as String?,
      json['note'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NumberToJson(Number instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['company_id'] = instance.company_id;
  val['wms_channel'] = instance.wms_channel;
  val['year_month'] = instance.year_month;
  val['seq_no'] = instance.seq_no;
  val['init_datetime'] = instance.init_datetime;
  val['note'] = instance.note;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
