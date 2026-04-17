import 'package:json_annotation/json_annotation.dart';

part 'postal_code_info.g.dart';

@JsonSerializable()
class PostalCodeInfo {
  PostalCodeInfo(
    this.id,
    this.country,
    this.postal_code,
    this.city,
    this.region,
    this.del_kbn,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? country;
  String? postal_code;
  String? city;
  String? region;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  PostalCodeInfo set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return PostalCodeInfo.fromJson(_this);
  } 

  factory PostalCodeInfo.fromJson(Map<String, dynamic> json) => _$PostalCodeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PostalCodeInfoToJson(this);

  // 命名构造函数
  PostalCodeInfo.empty();

}
