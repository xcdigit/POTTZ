// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      (json['id'] as num?)?.toInt(),
      json['code'] as String?,
      json['name'] as String?,
      json['name_short'] as String?,
      json['jan_cd'] as String?,
      json['category_l'] as String?,
      json['category_m'] as String?,
      json['category_s'] as String?,
      json['size'] as String?,
      json['packing_type'] as String?,
      (json['packing_num'] as num?)?.toInt(),
      json['image1'] as String?,
      json['image2'] as String?,
      (json['owner_id'] as num?)?.toInt(),
      json['company_note1'] as String?,
      json['company_note2'] as String?,
      json['notice_note1'] as String?,
      json['notice_note2'] as String?,
      (json['stock_limit'] as num?)?.toInt(),
      (json['company_id'] as num?)?.toInt(),
      json['del_kbn'] as String?,
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['code'] = instance.code;
  val['name'] = instance.name;
  val['name_short'] = instance.name_short;
  val['jan_cd'] = instance.jan_cd;
  val['category_l'] = instance.category_l;
  val['category_m'] = instance.category_m;
  val['category_s'] = instance.category_s;
  val['size'] = instance.size;
  val['packing_type'] = instance.packing_type;
  val['packing_num'] = instance.packing_num;
  val['image1'] = instance.image1;
  val['image2'] = instance.image2;
  val['owner_id'] = instance.owner_id;
  val['company_note1'] = instance.company_note1;
  val['company_note2'] = instance.company_note2;
  val['notice_note1'] = instance.notice_note1;
  val['notice_note2'] = instance.notice_note2;
  val['stock_limit'] = instance.stock_limit;
  val['company_id'] = instance.company_id;
  val['del_kbn'] = instance.del_kbn;
  val['create_time'] = instance.create_time;
  val['create_id'] = instance.create_id;
  val['update_time'] = instance.update_time;
  val['update_id'] = instance.update_id;
  return val;
}
