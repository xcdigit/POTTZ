// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiveDetail _$ReceiveDetailFromJson(Map<String, dynamic> json) =>
    ReceiveDetail(
      (json['id'] as num?)?.toInt(),
      (json['receive_id'] as num?)?.toInt(),
      json['receive_line_no'] as String?,
      (json['product_id'] as num?)?.toInt(),
      (json['product_num'] as num?)?.toInt(),
      (json['product_price'] as num?)?.toDouble(),
      (json['check_num'] as num?)?.toInt(),
      (json['store_num'] as num?)?.toInt(),
      json['check_kbn'] as String?,
      json['store_kbn'] as String?,
      json['confirm_kbn'] as String?,
      json['note1'] as String?,
      json['note2'] as String?,
      json['importerror_flg'] as String?,
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReceiveDetailToJson(ReceiveDetail instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['receive_id'] = instance.receive_id;
  val['receive_line_no'] = instance.receive_line_no;
  val['product_id'] = instance.product_id;
  val['product_num'] = instance.product_num;
  val['product_price'] = instance.product_price;
  val['check_num'] = instance.check_num;
  val['store_num'] = instance.store_num;
  val['check_kbn'] = instance.check_kbn;
  val['store_kbn'] = instance.store_kbn;
  val['confirm_kbn'] = instance.confirm_kbn;
  val['note1'] = instance.note1;
  val['note2'] = instance.note2;
  val['importerror_flg'] = instance.importerror_flg;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
