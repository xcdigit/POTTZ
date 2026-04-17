import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(
    this.id,
    this.code,
    this.name,
    this.role_id,
    this.organization_id,
    this.company_id,
    this.status,
    this.start_date,
    this.end_date,
    this.language_id,
    this.email,
    this.avatar,
    this.description,
    this.authenticator_key,
    this.send_time,
    this.mail_code,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? code;
  String? name;
  int? role_id;
  int? organization_id;
  int? company_id;
  String? status;
  String? start_date;
  String? end_date;
  int? language_id;
  String? email;
  String? avatar;
  String? description;
  String? authenticator_key;
  String? send_time;
  String? mail_code;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  User set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return User.fromJson(_this);
  } 

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  // 命名构造函数
  User.empty();

}
