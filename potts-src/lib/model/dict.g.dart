// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dict.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dict _$DictFromJson(Map<String, dynamic> json) => Dict(
      (json['id'] as num?)?.toInt(),
      json['dict_name'] as String?,
      json['dict_label'] as String?,
      json['dict_value'] as String?,
      json['note'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DictToJson(Dict instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['dict_name'] = instance.dict_name;
  val['dict_label'] = instance.dict_label;
  val['dict_value'] = instance.dict_value;
  val['note'] = instance.note;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
