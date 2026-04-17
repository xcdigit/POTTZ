// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ship _$ShipFromJson(Map<String, dynamic> json) => Ship(
      (json['id'] as num?)?.toInt(),
      json['ship_no'] as String?,
      json['order_no'] as String?,
      json['rcv_sch_date'] as String?,
      json['rcv_real_date'] as String?,
      json['cus_rev_date'] as String?,
      json['ship_kbn'] as String?,
      (json['delivery_company_id'] as num?)?.toInt(),
      json['delivery_no'] as String?,
      (json['customer_id'] as num?)?.toInt(),
      (json['customer_addr_id'] as num?)?.toInt(),
      json['customer_name'] as String?,
      json['customer_name_kana'] as String?,
      json['customer_postal_cd'] as String?,
      json['customer_addr_1'] as String?,
      json['customer_addr_2'] as String?,
      json['customer_addr_3'] as String?,
      json['customer_tel'] as String?,
      json['customer_fax'] as String?,
      json['same_kbn'] as String?,
      json['name'] as String?,
      json['name_kana'] as String?,
      json['postal_cd'] as String?,
      json['addr_1'] as String?,
      json['addr_2'] as String?,
      json['addr_3'] as String?,
      json['addr_tel'] as String?,
      json['fax'] as String?,
      json['person'] as String?,
      json['pick_list_kbn'] as String?,
      json['pdf_kbn'] as String?,
      json['csv_kbn'] as String?,
      json['note1'] as String?,
      json['note2'] as String?,
      (json['company_id'] as num?)?.toInt(),
      json['importerror_flg'] as String?,
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShipToJson(Ship instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['ship_no'] = instance.ship_no;
  val['order_no'] = instance.order_no;
  val['rcv_sch_date'] = instance.rcv_sch_date;
  val['rcv_real_date'] = instance.rcv_real_date;
  val['cus_rev_date'] = instance.cus_rev_date;
  val['ship_kbn'] = instance.ship_kbn;
  val['delivery_company_id'] = instance.delivery_company_id;
  val['delivery_no'] = instance.delivery_no;
  val['customer_id'] = instance.customer_id;
  val['customer_addr_id'] = instance.customer_addr_id;
  val['customer_name'] = instance.customer_name;
  val['customer_name_kana'] = instance.customer_name_kana;
  val['customer_postal_cd'] = instance.customer_postal_cd;
  val['customer_addr_1'] = instance.customer_addr_1;
  val['customer_addr_2'] = instance.customer_addr_2;
  val['customer_addr_3'] = instance.customer_addr_3;
  val['customer_tel'] = instance.customer_tel;
  val['customer_fax'] = instance.customer_fax;
  val['same_kbn'] = instance.same_kbn;
  val['name'] = instance.name;
  val['name_kana'] = instance.name_kana;
  val['postal_cd'] = instance.postal_cd;
  val['addr_1'] = instance.addr_1;
  val['addr_2'] = instance.addr_2;
  val['addr_3'] = instance.addr_3;
  val['addr_tel'] = instance.addr_tel;
  val['fax'] = instance.fax;
  val['person'] = instance.person;
  val['pick_list_kbn'] = instance.pick_list_kbn;
  val['pdf_kbn'] = instance.pdf_kbn;
  val['csv_kbn'] = instance.csv_kbn;
  val['note1'] = instance.note1;
  val['note2'] = instance.note2;
  val['company_id'] = instance.company_id;
  val['importerror_flg'] = instance.importerror_flg;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
