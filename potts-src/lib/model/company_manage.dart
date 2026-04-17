import 'package:json_annotation/json_annotation.dart';

part 'company_manage.g.dart';

@JsonSerializable()
class CompanyManage {
  CompanyManage(
    this.id,
    this.company_id,
    this.start_date,
    this.end_date,
    this.user_id,
    this.note,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? company_id;
  String? start_date;
  String? end_date;
  int? user_id;
  String? note;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  CompanyManage set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return CompanyManage.fromJson(_this);
  } 

  factory CompanyManage.fromJson(Map<String, dynamic> json) => _$CompanyManageFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyManageToJson(this);

  // 命名构造函数
  CompanyManage.empty();

}
