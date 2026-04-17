import 'package:json_annotation/json_annotation.dart';

part 'dict.g.dart';

@JsonSerializable()
class Dict {
  Dict(
    this.id,
    this.dict_name,
    this.dict_label,
    this.dict_value,
    this.note,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? dict_name;
  String? dict_label;
  String? dict_value;
  String? note;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Dict set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Dict.fromJson(_this);
  } 

  factory Dict.fromJson(Map<String, dynamic> json) => _$DictFromJson(json);

  Map<String, dynamic> toJson() => _$DictToJson(this);

  // 命名构造函数
  Dict.empty();

}
