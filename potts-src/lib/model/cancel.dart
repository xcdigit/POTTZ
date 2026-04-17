import 'package:json_annotation/json_annotation.dart';

part 'cancel.g.dart';

@JsonSerializable()
class Cancel {
  Cancel(
    this.id,
    this.user_id,
    this.company_id,
    this.admin_confirm_status,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? user_id;
  int? company_id;
  String? admin_confirm_status;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Cancel set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Cancel.fromJson(_this);
  } 

  factory Cancel.fromJson(Map<String, dynamic> json) => _$CancelFromJson(json);

  Map<String, dynamic> toJson() => _$CancelToJson(this);

  // 命名构造函数
  Cancel.empty();

}
