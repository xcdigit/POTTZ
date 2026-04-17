import 'package:json_annotation/json_annotation.dart';

part 'pick_list.g.dart';

@JsonSerializable()
class PickList {
  PickList(
    this.id,
    this.ship_id,
    this.ship_line_no,
    this.pick_line_no,
    this.product_id,
    this.product_price,
    this.warehouse_no,
    this.from_location_id,
    this.to_location_id,
    this.lock_num,
    this.store_kbn,
    this.del_kbn,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? ship_id;
  String? ship_line_no;
  String? pick_line_no;
  int? product_id;
  double? product_price;
  String? warehouse_no;
  int? from_location_id;
  int? to_location_id;
  int? lock_num;
  String? store_kbn;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  PickList set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return PickList.fromJson(_this);
  } 

  factory PickList.fromJson(Map<String, dynamic> json) => _$PickListFromJson(json);

  Map<String, dynamic> toJson() => _$PickListToJson(this);

  // 命名构造函数
  PickList.empty();

}
