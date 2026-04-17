import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  Customer(
    this.id,
    this.name,
    this.name_kana,
    this.name_short,
    this.corporation_number,
    this.postal_cd,
    this.classify_1,
    this.classify_2,
    this.classify_3,
    this.country,
    this.region,
    this.addr_1,
    this.addr_2,
    this.addr_3,
    this.addr_4,
    this.tel,
    this.fax,
    this.owner_name,
    this.contact,
    this.contact_tel,
    this.contact_fax,
    this.contact_email,
    this.company_note1,
    this.company_note2,
    this.application_start_date,
    this.application_end_date,
    this.limit_date_flg,
    this.limit_date,
    this.company_id,
    this.del_kbn,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? name;
  String? name_kana;
  String? name_short;
  String? corporation_number;
  String? postal_cd;
  String? classify_1;
  String? classify_2;
  String? classify_3;
  String? country;
  String? region;
  String? addr_1;
  String? addr_2;
  String? addr_3;
  String? addr_4;
  String? tel;
  String? fax;
  String? owner_name;
  String? contact;
  String? contact_tel;
  String? contact_fax;
  String? contact_email;
  String? company_note1;
  String? company_note2;
  String? application_start_date;
  String? application_end_date;
  String? limit_date_flg;
  String? limit_date;
  int? company_id;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;

  // set方法
  Customer set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Customer.fromJson(_this);
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  // 命名构造函数
  Customer.empty();
}
