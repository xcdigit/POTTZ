import 'package:json_annotation/json_annotation.dart';

part 'organization.g.dart';

@JsonSerializable()
class Organization {
  Organization(
    this.id,
    this.parent_id,
    this.code,
    this.name,
    this.content,
    this.company_id,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? parent_id;
  String? code;
  String? name;
  String? content;
  int? company_id;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Organization set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Organization.fromJson(_this);
  } 

  factory Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationToJson(this);

  // 命名构造函数
  Organization.empty();

}
