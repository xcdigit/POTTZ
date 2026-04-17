import 'package:json_annotation/json_annotation.dart';

part 'inventory_detail.g.dart';

@JsonSerializable()
class InventoryDetail {
  InventoryDetail(
    this.id,
    this.inventory_id,
    this.location_id,
    this.product_id,
    this.real_num,
    this.logic_num,
    this.limit_date,
    this.lot_no,
    this.serial_no,
    this.note,
    this.diff_kbn,
    this.diff_reason,
    this.end_kbn,
    this.note1,
    this.note2,
    this.del_kbn,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? inventory_id;
  int? location_id;
  int? product_id;
  int? real_num;
  int? logic_num;
  String? limit_date;
  String? lot_no;
  String? serial_no;
  String? note;
  String? diff_kbn;
  String? diff_reason;
  String? end_kbn;
  String? note1;
  String? note2;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  InventoryDetail set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return InventoryDetail.fromJson(_this);
  } 

  factory InventoryDetail.fromJson(Map<String, dynamic> json) => _$InventoryDetailFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryDetailToJson(this);

  // 命名构造函数
  InventoryDetail.empty();

}
