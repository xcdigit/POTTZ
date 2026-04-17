import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable()
class Store {
  Store(
    this.id,
    this.product_id,
    this.year_month,
    this.stock,
    this.lock_stock,
    this.before_stock,
    this.in_stock,
    this.out_stock,
    this.adjust_stock,
    this.inventory_stock,
    this.move_in_stock,
    this.move_out_stock,
    this.return_stock,
    this.company_id,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? product_id;
  String? year_month;
  int? stock;
  int? lock_stock;
  int? before_stock;
  int? in_stock;
  int? out_stock;
  int? adjust_stock;
  int? inventory_stock;
  int? move_in_stock;
  int? move_out_stock;
  int? return_stock;
  int? company_id;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Store set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Store.fromJson(_this);
  } 

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  Map<String, dynamic> toJson() => _$StoreToJson(this);

  // 命名构造函数
  Store.empty();

}
