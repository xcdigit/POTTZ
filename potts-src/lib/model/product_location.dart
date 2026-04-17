import 'package:json_annotation/json_annotation.dart';

part 'product_location.g.dart';

@JsonSerializable()
class ProductLocation {
  ProductLocation(
    this.id,
    this.location_id,
    this.stock_id,
    this.product_id,
    this.stock,
    this.lock_stock,
    this.limit_date,
    this.lot_no,
    this.serial_no,
    this.note,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? location_id;
  int? stock_id;
  int? product_id;
  int? stock;
  int? lock_stock;
  String? limit_date;
  String? lot_no;
  String? serial_no;
  String? note;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  ProductLocation set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return ProductLocation.fromJson(_this);
  } 

  factory ProductLocation.fromJson(Map<String, dynamic> json) => _$ProductLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ProductLocationToJson(this);

  // 命名构造函数
  ProductLocation.empty();

}
