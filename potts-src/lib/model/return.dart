import 'package:json_annotation/json_annotation.dart';

part 'return.g.dart';

@JsonSerializable()
class Return {
  Return(
    this.id,
    this.return_kbn,
    this.rev_ship_id,
    this.rev_ship_line_no,
    this.product_id,
    this.location_id,
    this.return_num,
    this.company_id,
    this.del_kbn,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? return_kbn;
  int? rev_ship_id;
  String? rev_ship_line_no;
  int? product_id;
  int? location_id;
  int? return_num;
  int? company_id;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Return set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Return.fromJson(_this);
  } 

  factory Return.fromJson(Map<String, dynamic> json) => _$ReturnFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnToJson(this);

  // 命名构造函数
  Return.empty();

}
