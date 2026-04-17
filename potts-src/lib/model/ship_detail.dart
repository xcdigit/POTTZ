import 'package:json_annotation/json_annotation.dart';

part 'ship_detail.g.dart';

@JsonSerializable()
class ShipDetail {
  ShipDetail(
    this.id,
    this.ship_id,
    this.ship_line_no,
    this.product_id,
    this.ship_num,
    this.product_price,
    this.warehouse_no,
    this.location_id,
    this.lock_num,
    this.store_num,
    this.check_num,
    this.packing_num,
    this.lock_kbn,
    this.store_kbn,
    this.check_kbn,
    this.packing_kbn,
    this.confirm_kbn,
    this.note1,
    this.note2,
    this.importerror_flg,
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
  int? product_id;
  int? ship_num;
  double? product_price;
  String? warehouse_no;
  int? location_id;
  int? lock_num;
  int? store_num;
  int? check_num;
  int? packing_num;
  String? lock_kbn;
  String? store_kbn;
  String? check_kbn;
  String? packing_kbn;
  String? confirm_kbn;
  String? note1;
  String? note2;
  String? importerror_flg;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  ShipDetail set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return ShipDetail.fromJson(_this);
  } 

  factory ShipDetail.fromJson(Map<String, dynamic> json) => _$ShipDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ShipDetailToJson(this);

  // 命名构造函数
  ShipDetail.empty();

}
