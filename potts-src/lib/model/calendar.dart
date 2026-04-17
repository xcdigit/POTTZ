import 'package:json_annotation/json_annotation.dart';

part 'calendar.g.dart';

@JsonSerializable()
class Calendar {
  Calendar(
    this.id,
    this.calendar_date,
    this.calendar_type,
    this.note,
    this.company_id,
    this.del_kbn,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? calendar_date;
  String? calendar_type;
  String? note;
  int? company_id;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Calendar set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Calendar.fromJson(_this);
  } 

  factory Calendar.fromJson(Map<String, dynamic> json) => _$CalendarFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarToJson(this);

  // 命名构造函数
  Calendar.empty();

}
