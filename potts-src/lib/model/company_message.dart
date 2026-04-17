import 'package:json_annotation/json_annotation.dart';

part 'company_message.g.dart';

@JsonSerializable()
class CompanyMessage {
  CompanyMessage(
    this.id,
    this.title,
    this.message,
    this.push_kbn,
    this.del_kbn,
    this.company_id,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? title;
  String? message;
  int? push_kbn;
  String? del_kbn;
  int? company_id;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  CompanyMessage set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return CompanyMessage.fromJson(_this);
  } 

  factory CompanyMessage.fromJson(Map<String, dynamic> json) => _$CompanyMessageFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyMessageToJson(this);

  // 命名构造函数
  CompanyMessage.empty();

}
