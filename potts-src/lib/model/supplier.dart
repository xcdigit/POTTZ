import 'package:json_annotation/json_annotation.dart';

part 'supplier.g.dart';

@JsonSerializable()
class Supplier {
  Supplier(
    this.id,
    this.name,
    this.name_kana,
    this.name_short,
    this.postal_cd,
    this.addr_1,
    this.addr_2,
    this.addr_3,
    this.tel,
    this.fax,
    this.owner_name,
    this.contact,
    this.contact_tel,
    this.contact_fax,
    this.contact_email,
    this.company_note1,
    this.company_note2,
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
  String? postal_cd;
  String? addr_1;
  String? addr_2;
  String? addr_3;
  String? tel;
  String? fax;
  String? owner_name;
  String? contact;
  String? contact_tel;
  String? contact_fax;
  String? contact_email;
  String? company_note1;
  String? company_note2;
  int? company_id;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Supplier set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Supplier.fromJson(_this);
  } 

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierToJson(this);

  // 命名构造函数
  Supplier.empty();

}
