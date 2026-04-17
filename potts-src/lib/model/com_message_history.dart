import 'package:json_annotation/json_annotation.dart';

part 'com_message_history.g.dart';

@JsonSerializable()
class ComMessageHistory {
  ComMessageHistory(
    this.id,
    this.message_kbn,
    this.message_id,
    this.status,
    this.read_status,
    this.user_id,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? message_kbn;
  int? message_id;
  String? status;
  String? read_status;
  int? user_id;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  ComMessageHistory set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return ComMessageHistory.fromJson(_this);
  } 

  factory ComMessageHistory.fromJson(Map<String, dynamic> json) => _$ComMessageHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ComMessageHistoryToJson(this);

  // 命名构造函数
  ComMessageHistory.empty();

}
