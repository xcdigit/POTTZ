// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ship_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipProduct _$ShipProductFromJson(Map<String, dynamic> json) => ShipProduct(
      (json['id'] as num?)?.toInt(),
      (json['ship_detail_id'] as num?)?.toInt(),
      (json['product_location_id'] as num?)?.toInt(),
      (json['stock'] as num?)?.toInt(),
      (json['return_stock'] as num?)?.toInt(),
      json['create_time'] as String?,
      (json['create_id'] as num?)?.toInt(),
      json['update_time'] as String?,
      (json['update_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShipProductToJson(ShipProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ship_detail_id': instance.ship_detail_id,
      'product_location_id': instance.product_location_id,
      'stock': instance.stock,
      'return_stock': instance.return_stock,
      'create_time': instance.create_time,
      'create_id': instance.create_id,
      'update_time': instance.update_time,
      'update_id': instance.update_id,
    };
