import 'package:json_annotation/json_annotation.dart';

part 'application_tmp.g.dart';

@JsonSerializable()
class ApplicationTmp {
  ApplicationTmp(
    this.id,
    this.user_email,
    this.user_password,
    this.user_name,
    this.user_phone,
    this.user_language_id,
    this.user_avatar,
    this.company_name,
    this.company_name_short,
    this.company_corporate_cd,
    this.company_qrr_cd,
    this.company_postal_cd,
    this.company_addr_1,
    this.company_addr_2,
    this.company_addr_3,
    this.company_tel,
    this.company_fax,
    this.company_url,
    this.company_email,
    this.use_type_id,
    this.pay_status,
    this.pay_total,
    this.pay_no,
    this.expiration_year,
    this.expiration_month,
    this.expiration_day,
    this.application_status,
    this.channel_id,
    this.promotion_code,
    this.authenticator_key,
    this.send_time,
    this.mail_code,
    this.base_ship,
    this.base_receive,
    this.base_store,
    this.plan_id,
    this.account_type,
    this.account_num,
    this.option,
    this.pay_cycle,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? user_email;
  String? user_password;
  String? user_name;
  String? user_phone;
  int? user_language_id;
  String? user_avatar;
  String? company_name;
  String? company_name_short;
  String? company_corporate_cd;
  String? company_qrr_cd;
  String? company_postal_cd;
  String? company_addr_1;
  String? company_addr_2;
  String? company_addr_3;
  String? company_tel;
  String? company_fax;
  String? company_url;
  String? company_email;
  int? use_type_id;
  String? pay_status;
  double? pay_total;
  String? pay_no;
  int? expiration_year;
  int? expiration_month;
  int? expiration_day;
  String? application_status;
  String? channel_id;
  String? promotion_code;
  String? authenticator_key;
  String? send_time;
  String? mail_code;
  String? base_ship;
  String? base_receive;
  String? base_store;
  int? plan_id;
  String? account_type;
  int? account_num;
  String? option;
  String? pay_cycle;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  ApplicationTmp set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return ApplicationTmp.fromJson(_this);
  } 

  factory ApplicationTmp.fromJson(Map<String, dynamic> json) => _$ApplicationTmpFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationTmpToJson(this);

  // 命名构造函数
  ApplicationTmp.empty();

}
