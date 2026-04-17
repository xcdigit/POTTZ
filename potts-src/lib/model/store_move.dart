import 'package:json_annotation/json_annotation.dart';

part 'store_move.g.dart';

@JsonSerializable()
class StoreMove {
  StoreMove(
    this.id,
    this.move_kbn,
    this.from_location_id,
    this.to_location_id,
    this.product_id,
    this.move_num,
    this.before_ad_num,
    this.after_ad_num,
    this.adjust_date,
    this.adjust_reason,
    this.company_id,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? move_kbn;
  int? from_location_id;
  int? to_location_id;
  int? product_id;
  int? move_num;
  int? before_ad_num;
  int? after_ad_num;
  String? adjust_date;
  String? adjust_reason;
  int? company_id;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  StoreMove set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return StoreMove.fromJson(_this);
  } 

  factory StoreMove.fromJson(Map<String, dynamic> json) => _$StoreMoveFromJson(json);

  Map<String, dynamic> toJson() => _$StoreMoveToJson(this);

  // 命名构造函数
  StoreMove.empty();

}
