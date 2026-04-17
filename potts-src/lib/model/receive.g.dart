// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receive _$ReceiveFromJson(Map<String, dynamic> json) => Receive(
      (json['id'] as num?)?.toInt(),
      json['receive_no'] as String?,
      json['order_no'] as String?,
      json['rcv_sch_date'] as String?,
      json['receive_kbn'] as String?,
      (json['supplier_id'] as num?)?.toInt(),
      json['name'] as String?,
      json['name_kana'] as String?,
      json['postal_cd'] as String?,
      json['addr_1'] as String?,
      json['addr_2'] as String?,
      json['addr_3'] as String?,
      json['addr_tel'] as String?,
      json['customer_fax'] as String?,
      json['note1'] as String?,
      json['note2'] as String?,
      json['csv_kbn'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['importerror_flg'] as String?,
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReceiveToJson(Receive instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['receive_no'] = instance.receive_no;
  val['order_no'] = instance.order_no;
  val['rcv_sch_date'] = instance.rcv_sch_date;
  val['receive_kbn'] = instance.receive_kbn;
  val['supplier_id'] = instance.supplier_id;
  val['name'] = instance.name;
  val['name_kana'] = instance.name_kana;
  val['postal_cd'] = instance.postal_cd;
  val['addr_1'] = instance.addr_1;
  val['addr_2'] = instance.addr_2;
  val['addr_3'] = instance.addr_3;
  val['addr_tel'] = instance.addr_tel;
  val['customer_fax'] = instance.customer_fax;
  val['note1'] = instance.note1;
  val['note2'] = instance.note2;
  val['csv_kbn'] = instance.csv_kbn;
  val['company_id'] = instance.company_id;
  val['importerror_flg'] = instance.importerror_flg;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
