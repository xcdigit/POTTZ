import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  Product(
    this.id,
    this.code,
    this.name,
    this.name_short,
    this.jan_cd,
    this.category_l,
    this.category_m,
    this.category_s,
    this.size,
    this.packing_type,
    this.packing_num,
    this.image1,
    this.image2,
    this.owner_id,
    this.company_note1,
    this.company_note2,
    this.notice_note1,
    this.notice_note2,
    this.stock_limit,
    this.company_id,
    this.del_kbn,
    this.create_time,
    this.create_id,
    this.update_time,
    this.update_id,
  );
  @JsonKey(includeIfNull: false)
  int? id;
  String? code;
  String? name;
  String? name_short;
  String? jan_cd;
  String? category_l;
  String? category_m;
  String? category_s;
  String? size;
  String? packing_type;
  int? packing_num;
  String? image1;
  String? image2;
  int? owner_id;
  String? company_note1;
  String? company_note2;
  String? notice_note1;
  String? notice_note2;
  int? stock_limit;
  int? company_id;
  String? del_kbn;
  String? create_time;
  int? create_id;
  String? update_time;
  int? update_id;


  // set方法
  Product set(String key, dynamic value) {
    Map<String, dynamic> _this = toJson();
    _this[key] = value;
    return Product.fromJson(_this);
  } 

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  // 命名构造函数
  Product.empty();

}
