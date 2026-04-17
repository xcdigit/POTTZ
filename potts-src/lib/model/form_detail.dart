import 'package:json_annotation/json_annotation.dart';

part 'form_detail.g.dart';

@JsonSerializable()
class FormDetail {
  FormDetail(
    this.id,
    this.form_id,
    this.location,
    this.sequence_number,
    this.assort,
    this.content_table,
    this.content_fields,
    this.calculation_table1,
    this.calculation_fields1,
    this.calculation_table2,
    this.calculation_fields2,
    this.calculation_mode,
    this.show_field_name,
    this.prefix_text,
    this.suffix_text,
    this.word_size,
    this.company_id,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? form_id;
  String? location;
  int? sequence_number;
  String? assort;
  String? content_table;
  String? content_fields;
  String? calculation_table1;
  String? calculation_fields1;
  String? calculation_table2;
  String? calculation_fields2;
  String? calculation_mode;
  String? show_field_name;
  String? prefix_text;
  String? suffix_text;
  int? word_size;
  int? company_id;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  FormDetail set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return FormDetail.fromJson(_this);
  } 

  factory FormDetail.fromJson(Map<String, dynamic> json) => _$FormDetailFromJson(json);

  Map<String, dynamic> toJson() => _$FormDetailToJson(this);

  // 命名构造函数
  FormDetail.empty();

}
