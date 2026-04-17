import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu {
  Menu(
    this.id,
    this.parent_id,
    this.name,
    this.description,
    this.path,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? parent_id;
  String? name;
  String? description;
  String? path;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Menu set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Menu.fromJson(_this);
  } 

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  // 命名构造函数
  Menu.empty();

}
