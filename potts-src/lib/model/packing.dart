import 'package:json_annotation/json_annotation.dart';

part 'packing.g.dart';

@JsonSerializable()
class Packing {
  Packing(
    this.id,
    this.name,
    this.kbn,
    this.weight,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? name;
  String? kbn;
  String? weight;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Packing set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Packing.fromJson(_this);
  } 

  factory Packing.fromJson(Map<String, dynamic> json) => _$PackingFromJson(json);

  Map<String, dynamic> toJson() => _$PackingToJson(this);

  // 命名构造函数
  Packing.empty();

}
