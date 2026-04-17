import 'package:json_annotation/json_annotation.dart';

part 'log.g.dart';

@JsonSerializable()
class Log {
  Log(
    this.id,
    this.content,
    this.log_type,
    this.method,
    this.exception_detail,
    this.request_ip,
    this.company_id,
    this.create_time,
    this.create_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? content;
  String? log_type;
  String? method;
  String? exception_detail;
  String? request_ip;
  int? company_id;
  String? create_time;
  int? create_id;


  // set方法
  Log set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Log.fromJson(_this);
  } 

  factory Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);

  Map<String, dynamic> toJson() => _$LogToJson(this);

  // 命名构造函数
  Log.empty();

}
