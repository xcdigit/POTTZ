import 'package:json_annotation/json_annotation.dart';

part 'authority.g.dart';

@JsonSerializable()
class Authority {
  Authority(
    this.id,
    this.role_id,
    this.menu_id,
    this.auth,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? role_id;
  int? menu_id;
  String? auth;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Authority set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Authority.fromJson(_this);
  } 

  factory Authority.fromJson(Map<String, dynamic> json) => _$AuthorityFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorityToJson(this);

  // 命名构造函数
  Authority.empty();

}
