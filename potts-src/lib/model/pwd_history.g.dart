// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pwd_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PwdHistory _$PwdHistoryFromJson(Map<String, dynamic> json) => PwdHistory(
      (json['id'] as num?)?.toInt(),
      (json['user_id'] as num?)?.toInt(),
      json['password'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PwdHistoryToJson(PwdHistory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['user_id'] = instance.user_id;
  val['password'] = instance.password;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  return val;
}
