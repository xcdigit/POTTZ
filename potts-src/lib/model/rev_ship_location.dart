import 'package:json_annotation/json_annotation.dart';

part 'rev_ship_location.g.dart';

@JsonSerializable()
class RevShipLocation {
  RevShipLocation(
    this.id,
    this.rev_ship_line_no,
    this.rev_ship_kbn,
    this.product_location_id,
    this.stock,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? rev_ship_line_no;
  String? rev_ship_kbn;
  int? product_location_id;
  int? stock;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  RevShipLocation set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return RevShipLocation.fromJson(_this);
  } 

  factory RevShipLocation.fromJson(Map<String, dynamic> json) => _$RevShipLocationFromJson(json);

  Map<String, dynamic> toJson() => _$RevShipLocationToJson(this);

  // 命名构造函数
  RevShipLocation.empty();

}
