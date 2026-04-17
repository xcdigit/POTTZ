import 'package:json_annotation/json_annotation.dart';

part 'number.g.dart';

@JsonSerializable()
class Number {
  Number(
    this.id,
    this.company_id,
    this.wms_channel,
    this.year_month,
    this.seq_no,
    this.init_datetime,
    this.note,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? company_id;
  String? wms_channel;
  String? year_month;
  int? seq_no;
  String? init_datetime;
  String? note;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Number set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Number.fromJson(_this);
  } 

  factory Number.fromJson(Map<String, dynamic> json) => _$NumberFromJson(json);

  Map<String, dynamic> toJson() => _$NumberToJson(this);

  // 命名构造函数
  Number.empty();

}
