// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Log _$LogFromJson(Map<String, dynamic> json) => Log(
      (json['id'] as num?)?.toInt(),
      json['content'] as String?,
      json['log_type'] as String?,
      json['method'] as String?,
      json['exception_detail'] as String?,
      json['request_ip'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogToJson(Log instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['content'] = instance.content;
  val['log_type'] = instance.log_type;
  val['method'] = instance.method;
  val['exception_detail'] = instance.exception_detail;
  val['request_ip'] = instance.request_ip;
  val['company_id'] = instance.company_id;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  return val;
}
