import 'package:json_annotation/json_annotation.dart';

part 'action.g.dart';

@JsonSerializable()
class Action {
  Action(
    this.id,
    this.name,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? name;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Action set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Action.fromJson(_this);
  } 

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);

  // 命名构造函数
  Action.empty();

}
