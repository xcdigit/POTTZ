// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Packing _$PackingFromJson(Map<String, dynamic> json) => Packing(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['kbn'] as String?,
      json['weight'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PackingToJson(Packing instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['name'] = instance.name;
  val['kbn'] = instance.kbn;
  val['weight'] = instance.weight;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
