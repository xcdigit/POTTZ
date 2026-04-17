import 'package:json_annotation/json_annotation.dart';

part 'return_detail.g.dart';

@JsonSerializable()
class ReturnDetail {
  ReturnDetail(
    this.id,
    this.return_id,
    this.rev_ship_line_no,
    this.product_id,
    this.location_id,
    this.return_num,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? return_id;
  String? rev_ship_line_no;
  int? product_id;
  int? location_id;
  int? return_num;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  ReturnDetail set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return ReturnDetail.fromJson(_this);
  } 

  factory ReturnDetail.fromJson(Map<String, dynamic> json) => _$ReturnDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ReturnDetailToJson(this);

  // 命名构造函数
  ReturnDetail.empty();

}
