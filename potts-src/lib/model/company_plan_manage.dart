import 'package:json_annotation/json_annotation.dart';

part 'company_plan_manage.g.dart';

@JsonSerializable()
class CompanyPlanManage {
  CompanyPlanManage(
    this.id,
    this.company_id,
    this.promotion_code,
    this.base_ship,
    this.base_receive,
    this.base_store,
    this.plan_id,
    this.account_type,
    this.account_num,
    this.option,
    this.pay_cycle,
    this.start_date,
    this.next_date,
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
  String? promotion_code;
  String? base_ship;
  String? base_receive;
  String? base_store;
  int? plan_id;
  String? account_type;
  int? account_num;
  String? option;
  String? pay_cycle;
  String? start_date;
  String? next_date;
  String? end_date;
  String? pay_status;
  double? pay_total;
  String? pay_no;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  CompanyPlanManage set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return CompanyPlanManage.fromJson(_this);
  } 

  factory CompanyPlanManage.fromJson(Map<String, dynamic> json) => _$CompanyPlanManageFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyPlanManageToJson(this);

  // 命名构造函数
  CompanyPlanManage.empty();

}
