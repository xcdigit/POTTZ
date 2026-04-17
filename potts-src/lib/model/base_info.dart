import 'package:json_annotation/json_annotation.dart';

part 'base_info.g.dart';

@JsonSerializable()
class BaseInfo {
  BaseInfo(
    this.id,
    this.name,
    this.corporate_cd,
    this.qrr_cd,
    this.postal_cd,
    this.addr_1,
    this.addr_2,
    this.addr_3,
    this.tel,
    this.fax,
    this.url,
    this.email,
    this.business_hour,
    this.free_time,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? name;
  String? corporate_cd;
  String? qrr_cd;
  String? postal_cd;
  String? addr_1;
  String? addr_2;
  String? addr_3;
  String? tel;
  String? fax;
  String? url;
  String? email;
  String? business_hour;
  String? free_time;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  BaseInfo set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return BaseInfo.fromJson(_this);
  } 

  factory BaseInfo.fromJson(Map<String, dynamic> json) => _$BaseInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BaseInfoToJson(this);

  // 命名构造函数
  BaseInfo.empty();

}
