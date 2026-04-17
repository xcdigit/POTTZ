import 'package:json_annotation/json_annotation.dart';

part 'inventory.g.dart';

@JsonSerializable()
class Inventory {
  Inventory(
    this.id,
    this.warehouse_id,
    this.start_date,
    this.confirm_date,
    this.confirm_flg,
    this.csv_kbn,
    this.note1,
    this.note2,
    this.company_id,
    this.del_kbn,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? warehouse_id;
  String? start_date;
  String? confirm_date;
  String? confirm_flg;
  String? csv_kbn;
  String? note1;
  String? note2;
  int? company_id;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Inventory set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Inventory.fromJson(_this);
  } 

  factory Inventory.fromJson(Map<String, dynamic> json) => _$InventoryFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryToJson(this);

  // 命名构造函数
  Inventory.empty();

}
