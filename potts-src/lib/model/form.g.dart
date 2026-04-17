// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Form _$FormFromJson(Map<String, dynamic> json) => Form(
      (json['id'] as num?)?.toInt(),
      json['form_kbn'] as String?,
      json['form_picture'] as String?,
      json['form_direction'] as String?,
      json['description'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FormToJson(Form instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['form_kbn'] = instance.form_kbn;
  val['form_picture'] = instance.form_picture;
  val['form_direction'] = instance.form_direction;
  val['description'] = instance.description;
  val['company_id'] = instance.company_id;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
