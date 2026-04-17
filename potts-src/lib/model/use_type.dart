import 'package:json_annotation/json_annotation.dart';

part 'use_type.g.dart';

@JsonSerializable()
class UseType {
  UseType(
    this.id,
    this.role_id,
    this.type,
    this.support_cotent,
    this.amount,
    this.expiration_year,
    this.expiration_month,
    this.expiration_day,
    this.start_date,
    this.end_date,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? role_id;
  String? type;
  String? support_cotent;
  double? amount;
  int? expiration_year;
  int? expiration_month;
  int? expiration_day;
  String? start_date;
  String? end_date;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  UseType set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return UseType.fromJson(_this);
  } 

  factory UseType.fromJson(Map<String, dynamic> json) => _$UseTypeFromJson(json);

  Map<String, dynamic> toJson() => _$UseTypeToJson(this);

  // 命名构造函数
  UseType.empty();

}
