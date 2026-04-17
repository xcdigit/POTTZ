import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

@JsonSerializable()
class Language {
  Language(
    this.id,
    this.name,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? name;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Language set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Language.fromJson(_this);
  } 

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  // 命名构造函数
  Language.empty();

}
