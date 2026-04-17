import 'package:json_annotation/json_annotation.dart';

part 'receive.g.dart';

@JsonSerializable()
class Receive {
  Receive(
    this.id,
    this.receive_no,
    this.order_no,
    this.rcv_sch_date,
    this.receive_kbn,
    this.supplier_id,
    this.name,
    this.name_kana,
    this.postal_cd,
    this.addr_1,
    this.addr_2,
    this.addr_3,
    this.addr_tel,
    this.customer_fax,
    this.note1,
    this.note2,
    this.csv_kbn,
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
  String? receive_no;
  String? order_no;
  String? rcv_sch_date;
  String? receive_kbn;
  int? supplier_id;
  String? name;
  String? name_kana;
  String? postal_cd;
  String? addr_1;
  String? addr_2;
  String? addr_3;
  String? addr_tel;
  String? customer_fax;
  String? note1;
  String? note2;
  String? csv_kbn;
  int? company_id;
  String? importerror_flg;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Receive set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Receive.fromJson(_this);
  } 

  factory Receive.fromJson(Map<String, dynamic> json) => _$ReceiveFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiveToJson(this);

  // 命名构造函数
  Receive.empty();

}
