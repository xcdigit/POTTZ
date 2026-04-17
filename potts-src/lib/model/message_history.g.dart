// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageHistory _$MessageHistoryFromJson(Map<String, dynamic> json) =>
    MessageHistory(
      (json['id'] as num?)?.toInt(),
      json['message_kbn'] as String?,
      (json['message_id'] as num?)?.toInt(),
      json['status'] as String?,
      json['read_status'] as String?,
      (json['user_id'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MessageHistoryToJson(MessageHistory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['message_kbn'] = instance.message_kbn;
  val['message_id'] = instance.message_id;
  val['status'] = instance.status;
  val['read_status'] = instance.read_status;
  val['user_id'] = instance.user_id;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
