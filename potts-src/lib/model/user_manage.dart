import 'package:json_annotation/json_annotation.dart';

part 'user_manage.g.dart';

@JsonSerializable()
class UserManage {
  UserManage(
    this.id,
    this.company_id,
    this.user_id,
    this.use_type_id,
    this.start_date,
    this.end_date,
    this.pay_status,
    this.pay_total,
    this.pay_no,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? company_id;
  int? user_id;
  int? use_type_id;
  String? start_date;
  String? end_date;
  String? pay_status;
  double? pay_total;
  String? pay_no;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  UserManage set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return UserManage.fromJson(_this);
  } 

  factory UserManage.fromJson(Map<String, dynamic> json) => _$UserManageFromJson(json);

  Map<String, dynamic> toJson() => _$UserManageToJson(this);

  // 命名构造函数
  UserManage.empty();

}
