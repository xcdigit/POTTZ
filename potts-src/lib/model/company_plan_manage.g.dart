// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_plan_manage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyPlanManage _$CompanyPlanManageFromJson(Map<String, dynamic> json) =>
    CompanyPlanManage(
      (json['id'] as num?)?.toInt(),
      (json['company_id'] as num?)?.toInt(),
      json['promotion_code'] as String?,
      json['base_ship'] as String?,
      json['base_receive'] as String?,
      json['base_store'] as String?,
      (json['plan_id'] as num?)?.toInt(),
      json['account_type'] as String?,
      (json['account_num'] as num?)?.toInt(),
      json['option'] as String?,
      json['pay_cycle'] as String?,
      json['start_date'] as String?,
      json['next_date'] as String?,
      json['end_date'] as String?,
      json['pay_status'] as String?,
      (json['pay_total'] as num?)?.toDouble(),
      json['pay_no'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CompanyPlanManageToJson(CompanyPlanManage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['company_id'] = instance.company_id;
  val['promotion_code'] = instance.promotion_code;
  val['base_ship'] = instance.base_ship;
  val['base_receive'] = instance.base_receive;
  val['base_store'] = instance.base_store;
  val['plan_id'] = instance.plan_id;
  val['account_type'] = instance.account_type;
  val['account_num'] = instance.account_num;
  val['option'] = instance.option;
  val['pay_cycle'] = instance.pay_cycle;
  val['start_date'] = instance.start_date;
  val['next_date'] = instance.next_date;
  val['end_date'] = instance.end_date;
  val['pay_status'] = instance.pay_status;
  val['pay_total'] = instance.pay_total;
  val['pay_no'] = instance.pay_no;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
