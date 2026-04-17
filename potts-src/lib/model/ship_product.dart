import 'package:json_annotation/json_annotation.dart';

part 'ship_product.g.dart';

@JsonSerializable()
class ShipProduct {
  ShipProduct(
    this.id,
    this.ship_detail_id,
    this.product_location_id,
    this.stock,
    this.return_stock,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  int? id;
  int? ship_detail_id;
  int? product_location_id;
  int? stock;
  int? return_stock;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  factory ShipProduct.fromJson(Map<String, dynamic> json) => _$ShipProductFromJson(json);

  Map<String, dynamic> toJson() => _$ShipProductToJson(this);

  // 命名构造函数
  ShipProduct.empty();

}
