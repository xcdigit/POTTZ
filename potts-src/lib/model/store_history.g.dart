// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreHistory _$StoreHistoryFromJson(Map<String, dynamic> json) => StoreHistory(
      (json['id'] as num?)?.toInt(),
      (json['stock_id'] as num?)?.toInt(),
      json['year_month'] as String?,
      json['rev_ship_line_no'] as String?,
      json['rev_ship_kbn'] as String?,
      (json['product_id'] as num?)?.toInt(),
      (json['num'] as num?)?.toInt(),
      json['store_kbn'] as String?,
      (json['location_id'] as num?)?.toInt(),
      (json['action_id'] as num?)?.toInt(),
      json['note1'] as String?,
      json['note2'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoreHistoryToJson(StoreHistory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['stock_id'] = instance.stock_id;
  val['year_month'] = instance.year_month;
  val['rev_ship_line_no'] = instance.rev_ship_line_no;
  val['rev_ship_kbn'] = instance.rev_ship_kbn;
  val['product_id'] = instance.product_id;
  val['num'] = instance.num;
  val['store_kbn'] = instance.store_kbn;
  val['location_id'] = instance.location_id;
  val['action_id'] = instance.action_id;
  val['note1'] = instance.note1;
  val['note2'] = instance.note2;
  val['company_id'] = instance.company_id;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  return val;
}
