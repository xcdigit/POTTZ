// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Calendar _$CalendarFromJson(Map<String, dynamic> json) => Calendar(
      (json['id'] as num?)?.toInt(),
      json['calendar_date'] as String?,
      json['calendar_type'] as String?,
      json['note'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CalendarToJson(Calendar instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['calendar_date'] = instance.calendar_date;
  val['calendar_type'] = instance.calendar_type;
  val['note'] = instance.note;
  val['company_id'] = instance.company_id;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
