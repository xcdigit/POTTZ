import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  Company(
    this.id,
    this.name,
    this.name_short,
    this.corporate_cd,
    this.qrr_cd,
    this.postal_cd,
    this.addr_1,
    this.addr_2,
    this.addr_3,
    this.tel,
    this.fax,
    this.url,
    this.email,
    this.status,
    this.forced_shipment_flag,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? name;
  String? name_short;
  String? corporate_cd;
  String? qrr_cd;
  String? postal_cd;
  String? addr_1;
  String? addr_2;
  String? addr_3;
  String? tel;
  String? fax;
  String? url;
  String? email;
  String? status;
  String? forced_shipment_flag;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Company set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Company.fromJson(_this);
  } 

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  // 命名构造函数
  Company.empty();

}
