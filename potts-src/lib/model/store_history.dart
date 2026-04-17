import 'package:json_annotation/json_annotation.dart';

part 'store_history.g.dart';

@JsonSerializable()
class StoreHistory {
  StoreHistory(
    this.id,
    this.stock_id,
    this.year_month,
    this.rev_ship_line_no,
    this.rev_ship_kbn,
    this.product_id,
    this.num,
    this.store_kbn,
    this.location_id,
    this.action_id,
    this.note1,
    this.note2,
    this.company_id,
    this.create_time,
    this.create_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? stock_id;
  String? year_month;
  String? rev_ship_line_no;
  String? rev_ship_kbn;
  int? product_id;
  int? num;
  String? store_kbn;
  int? location_id;
  int? action_id;
  String? note1;
  String? note2;
  int? company_id;
  String? create_time;
  int? create_id;


  // set方法
  StoreHistory set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return StoreHistory.fromJson(_this);
  } 

  factory StoreHistory.fromJson(Map<String, dynamic> json) => _$StoreHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoreHistoryToJson(this);

  // 命名构造函数
  StoreHistory.empty();

}
