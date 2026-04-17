// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormDetail _$FormDetailFromJson(Map<String, dynamic> json) => FormDetail(
      (json['id'] as num?)?.toInt(),
      (json['form_id'] as num?)?.toInt(),
      json['location'] as String?,
      (json['sequence_number'] as num?)?.toInt(),
      json['assort'] as String?,
      json['content_table'] as String?,
      json['content_fields'] as String?,
      json['calculation_table1'] as String?,
      json['calculation_fields1'] as String?,
      json['calculation_table2'] as String?,
      json['calculation_fields2'] as String?,
      json['calculation_mode'] as String?,
      json['show_field_name'] as String?,
      json['prefix_text'] as String?,
      json['suffix_text'] as String?,
      (json['word_size'] as num?)?.toInt(),
      (json['company_id'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FormDetailToJson(FormDetail instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['form_id'] = instance.form_id;
  val['location'] = instance.location;
  val['sequence_number'] = instance.sequence_number;
  val['assort'] = instance.assort;
  val['content_table'] = instance.content_table;
  val['content_fields'] = instance.content_fields;
  val['calculation_table1'] = instance.calculation_table1;
  val['calculation_fields1'] = instance.calculation_fields1;
  val['calculation_table2'] = instance.calculation_table2;
  val['calculation_fields2'] = instance.calculation_fields2;
  val['calculation_mode'] = instance.calculation_mode;
  val['show_field_name'] = instance.show_field_name;
  val['prefix_text'] = instance.prefix_text;
  val['suffix_text'] = instance.suffix_text;
  val['word_size'] = instance.word_size;
  val['company_id'] = instance.company_id;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
