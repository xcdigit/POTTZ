import 'package:json_annotation/json_annotation.dart';

part 'pwd_history.g.dart';

@JsonSerializable()
class PwdHistory {
  PwdHistory(
    this.id,
    this.user_id,
    this.password,
    this.create_time,
    this.create_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? user_id;
  String? password;
  String? create_time;
  int? create_id;


  // set方法
  PwdHistory set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return PwdHistory.fromJson(_this);
  } 

  factory PwdHistory.fromJson(Map<String, dynamic> json) => _$PwdHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PwdHistoryToJson(this);

  // 命名构造函数
  PwdHistory.empty();

}
