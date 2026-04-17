import 'package:json_annotation/json_annotation.dart';

part 'delivery.g.dart';

@JsonSerializable()
class Delivery {
  Delivery(
    this.id,
    this.name,
    this.postal_cd,
    this.addr_1,
    this.addr_2,
    this.addr_3,
    this.tel,
    this.fax,
    this.contact,
    this.contact_tel,
    this.contact_fax,
    this.contact_email,
    this.company_note1,
    this.company_note2,
    this.start_date,
    this.end_date,
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
  String? postal_cd;
  String? addr_1;
  String? addr_2;
  String? addr_3;
  String? tel;
  String? fax;
  String? contact;
  String? contact_tel;
  String? contact_fax;
  String? contact_email;
  String? company_note1;
  String? company_note2;
  String? start_date;
  String? end_date;
  int? company_id;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Delivery set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Delivery.fromJson(_this);
  } 

  factory Delivery.fromJson(Map<String, dynamic> json) => _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);

  // 命名构造函数
  Delivery.empty();

}
