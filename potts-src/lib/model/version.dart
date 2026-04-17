import 'package:json_annotation/json_annotation.dart';

part 'version.g.dart';

@JsonSerializable()
class Version {
  Version(
    this.id,
    this.version,
    this.content,
    this.path,
    this.status,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? version;
  String? content;
  String? path;
  String? status;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Version set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Version.fromJson(_this);
  } 

  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(this);

  // 命名构造函数
  Version.empty();

}
