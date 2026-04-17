import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable()
class Role {
  Role(
    this.id,
    this.name,
    this.description,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? name;
  String? description;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Role set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Role.fromJson(_this);
  } 

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);

  // 命名构造函数
  Role.empty();

}
