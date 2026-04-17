import 'package:json_annotation/json_annotation.dart';

part 'warehouse.g.dart';

@JsonSerializable()
class Warehouse {
  Warehouse(
    this.id,
    this.code,
    this.name,
    this.name_short,
    this.kbn,
    this.area,
    this.postal_cd,
    this.addr_1,
    this.addr_2,
    this.addr_3,
    this.tel,
    this.fax,
    this.note1,
    this.note2,
    this.company_id,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? code;
  String? name;
  String? name_short;
  String? kbn;
  String? area;
  String? postal_cd;
  String? addr_1;
  String? addr_2;
  String? addr_3;
  String? tel;
  String? fax;
  String? note1;
  String? note2;
  int? company_id;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Warehouse set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Warehouse.fromJson(_this);
  } 

  factory Warehouse.fromJson(Map<String, dynamic> json) => _$WarehouseFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseToJson(this);

  // 命名构造函数
  Warehouse.empty();

}
