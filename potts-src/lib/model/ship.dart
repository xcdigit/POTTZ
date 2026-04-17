import 'package:json_annotation/json_annotation.dart';

part 'ship.g.dart';

@JsonSerializable()
class Ship {
  Ship(
    this.id,
    this.ship_no,
    this.order_no,
    this.rcv_sch_date,
    this.rcv_real_date,
    this.cus_rev_date,
    this.ship_kbn,
    this.delivery_company_id,
    this.delivery_no,
    this.customer_id,
    this.customer_addr_id,
    this.customer_name,
    this.customer_name_kana,
    this.customer_postal_cd,
    this.customer_addr_1,
    this.customer_addr_2,
    this.customer_addr_3,
    this.customer_tel,
    this.customer_fax,
    this.same_kbn,
    this.name,
    this.name_kana,
    this.postal_cd,
    this.addr_1,
    this.addr_2,
    this.addr_3,
    this.addr_tel,
    this.fax,
    this.person,
    this.pick_list_kbn,
    this.pdf_kbn,
    this.csv_kbn,
    this.note1,
    this.note2,
    this.company_id,
    this.importerror_flg,
    this.del_kbn,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? ship_no;
  String? order_no;
  String? rcv_sch_date;
  String? rcv_real_date;
  String? cus_rev_date;
  String? ship_kbn;
  int? delivery_company_id;
  String? delivery_no;
  int? customer_id;
  int? customer_addr_id;
  String? customer_name;
  String? customer_name_kana;
  String? customer_postal_cd;
  String? customer_addr_1;
  String? customer_addr_2;
  String? customer_addr_3;
  String? customer_tel;
  String? customer_fax;
  String? same_kbn;
  String? name;
  String? name_kana;
  String? postal_cd;
  String? addr_1;
  String? addr_2;
  String? addr_3;
  String? addr_tel;
  String? fax;
  String? person;
  String? pick_list_kbn;
  String? pdf_kbn;
  String? csv_kbn;
  String? note1;
  String? note2;
  int? company_id;
  String? importerror_flg;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Ship set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Ship.fromJson(_this);
  } 

  factory Ship.fromJson(Map<String, dynamic> json) => _$ShipFromJson(json);

  Map<String, dynamic> toJson() => _$ShipToJson(this);

  // 命名构造函数
  Ship.empty();

}
