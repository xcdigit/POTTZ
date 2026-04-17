// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_tmp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationTmp _$ApplicationTmpFromJson(Map<String, dynamic> json) =>
    ApplicationTmp(
      (json['id'] as num?)?.toInt(),
      json['user_email'] as String?,
      json['user_password'] as String?,
      json['user_name'] as String?,
      json['user_phone'] as String?,
      (json['user_language_id'] as num?)?.toInt(),
      json['user_avatar'] as String?,
      json['company_name'] as String?,
      json['company_name_short'] as String?,
      json['company_corporate_cd'] as String?,
      json['company_qrr_cd'] as String?,
      json['company_postal_cd'] as String?,
      json['company_addr_1'] as String?,
      json['company_addr_2'] as String?,
      json['company_addr_3'] as String?,
      json['company_tel'] as String?,
      json['company_fax'] as String?,
      json['company_url'] as String?,
      json['company_email'] as String?,
      (json['use_type_id'] as num?)?.toInt(),
      json['pay_status'] as String?,
      (json['pay_total'] as num?)?.toDouble(),
      json['pay_no'] as String?,
      (json['expiration_year'] as num?)?.toInt(),
      (json['expiration_month'] as num?)?.toInt(),
      (json['expiration_day'] as num?)?.toInt(),
      json['application_status'] as String?,
      json['channel_id'] as String?,
      json['promotion_code'] as String?,
      json['authenticator_key'] as String?,
      json['send_time'] as String?,
      json['mail_code'] as String?,
      json['base_ship'] as String?,
      json['base_receive'] as String?,
      json['base_store'] as String?,
      (json['plan_id'] as num?)?.toInt(),
      json['account_type'] as String?,
      (json['account_num'] as num?)?.toInt(),
      json['option'] as String?,
      json['pay_cycle'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ApplicationTmpToJson(ApplicationTmp instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['user_email'] = instance.user_email;
  val['user_password'] = instance.user_password;
  val['user_name'] = instance.user_name;
  val['user_phone'] = instance.user_phone;
  val['user_language_id'] = instance.user_language_id;
  val['user_avatar'] = instance.user_avatar;
  val['company_name'] = instance.company_name;
  val['company_name_short'] = instance.company_name_short;
  val['company_corporate_cd'] = instance.company_corporate_cd;
  val['company_qrr_cd'] = instance.company_qrr_cd;
  val['company_postal_cd'] = instance.company_postal_cd;
  val['company_addr_1'] = instance.company_addr_1;
  val['company_addr_2'] = instance.company_addr_2;
  val['company_addr_3'] = instance.company_addr_3;
  val['company_tel'] = instance.company_tel;
  val['company_fax'] = instance.company_fax;
  val['company_url'] = instance.company_url;
  val['company_email'] = instance.company_email;
  val['use_type_id'] = instance.use_type_id;
  val['pay_status'] = instance.pay_status;
  val['pay_total'] = instance.pay_total;
  val['pay_no'] = instance.pay_no;
  val['expiration_year'] = instance.expiration_year;
  val['expiration_month'] = instance.expiration_month;
  val['expiration_day'] = instance.expiration_day;
  val['application_status'] = instance.application_status;
  val['channel_id'] = instance.channel_id;
  val['promotion_code'] = instance.promotion_code;
  val['authenticator_key'] = instance.authenticator_key;
  val['send_time'] = instance.send_time;
  val['mail_code'] = instance.mail_code;
  val['base_ship'] = instance.base_ship;
  val['base_receive'] = instance.base_receive;
  val['base_store'] = instance.base_store;
  val['plan_id'] = instance.plan_id;
  val['account_type'] = instance.account_type;
  val['account_num'] = instance.account_num;
  val['option'] = instance.option;
  val['pay_cycle'] = instance.pay_cycle;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
