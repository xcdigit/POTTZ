import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  Location(
    this.id,
    this.warehouse_id,
    this.loc_cd,
    this.kbn,
    this.floor_cd,
    this.room_cd,
    this.zone_cd,
    this.row_cd,
    this.shelve_cd,
    this.step_cd,
    this.range_cd,
    this.keeping_volume,
    this.area,
    this.note1,
    this.note2,
    this.company_id,
    this.del_kbn,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  int? warehouse_id;
  String? loc_cd;
  String? kbn;
  String? floor_cd;
  String? room_cd;
  String? zone_cd;
  String? row_cd;
  String? shelve_cd;
  String? step_cd;
  String? range_cd;
  double? keeping_volume;
  String? area;
  String? note1;
  String? note2;
  int? company_id;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Location set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Location.fromJson(_this);
  } 

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  // 命名构造函数
  Location.empty();

}
