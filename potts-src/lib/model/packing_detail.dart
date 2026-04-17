import 'package:json_annotation/json_annotation.dart';

part 'packing_detail.g.dart';

@JsonSerializable()
class PackingDetail {
  PackingDetail(
    this.id,
    this.ship_no,
    this.packing_id,
    this.product_num,
    this.product_weight,
    this.product_volume,
    this.note1,
    this.note2,
    this.company_id,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? ship_no;
  int? packing_id;
  int? product_num;
  String? product_weight;
  String? product_volume;
  String? note1;
  String? note2;
  int? company_id;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  PackingDetail set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return PackingDetail.fromJson(_this);
  } 

  factory PackingDetail.fromJson(Map<String, dynamic> json) => _$PackingDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PackingDetailToJson(this);

  // 命名构造函数
  PackingDetail.empty();

}
