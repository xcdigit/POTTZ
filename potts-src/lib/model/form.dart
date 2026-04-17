import 'package:json_annotation/json_annotation.dart';

part 'form.g.dart';

@JsonSerializable()
class Form {
  Form(
    this.id,
    this.form_kbn,
    this.form_picture,
    this.form_direction,
    this.description,
    this.company_id,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? form_kbn;
  String? form_picture;
  String? form_direction;
  String? description;
  int? company_id;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;

  // set方法
  Form set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Form.fromJson(_this);
  }

  factory Form.fromJson(Map<String, dynamic> json) => _$FormFromJson(json);

  Map<String, dynamic> toJson() => _$FormToJson(this);

  // 命名构造函数
  Form.empty();
}
