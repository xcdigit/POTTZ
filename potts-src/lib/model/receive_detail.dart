import 'package:json_annotation/json_annotation.dart';

part 'receive_detail.g.dart';

@JsonSerializable()
class ReceiveDetail {
  ReceiveDetail(
    this.id,
    this.receive_id,
    this.receive_line_no,
    this.product_id,
    this.product_num,
    this.product_price,
    this.check_num,
    this.store_num,
    this.check_kbn,
    this.store_kbn,
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
  int? receive_id;
  String? receive_line_no;
  int? product_id;
  int? product_num;
  double? product_price;
  int? check_num;
  int? store_num;
  String? check_kbn;
  String? store_kbn;
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
  ReceiveDetail set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return ReceiveDetail.fromJson(_this);
  } 

  factory ReceiveDetail.fromJson(Map<String, dynamic> json) => _$ReceiveDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiveDetailToJson(this);

  // 命名构造函数
  ReceiveDetail.empty();

}
