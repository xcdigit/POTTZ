import 'package:flutter/cupertino.dart';

/**
 * 内容：実棚明細入力
 * 作者：王光顺
 * 时间：2023/10/07
 */
class ActualShelfModel {
  // 克隆
  factory ActualShelfModel.clone(ActualShelfModel src) {
    ActualShelfModel dest = ActualShelfModel(
        MactualId: src.MactualId,
        actualId: src.actualId,
        actualState: src.actualState,
        actualDate: src.actualDate,
        warehouse: src.warehouse,
        rootBuildContext: src.rootBuildContext);
    dest.warehouse = src.warehouse;
    dest.warehouseId = src.warehouseId;
    dest.warehouseList = src.warehouseList;
    dest.MactualId = src.MactualId;
    dest.actualId = src.actualId;
    dest.actualState = src.actualState;
    dest.actualInformation = src.actualInformation;
    dest.delKfn = src.delKfn;

    dest.actualProduct = src.actualProduct;
    dest.inputreason = src.inputreason;
    dest.difference = src.difference;

    dest.realNum = src.realNum;
    dest.progress = src.progress;
    dest.image1Network = src.image1Network;

    dest.logicNum = src.logicNum;
    dest.HlogicNum = src.HlogicNum;
    dest.loc_cd = src.loc_cd;
    dest.pro_code = src.pro_code;
    dest.productData = src.productData;
    dest.locationData = src.locationData;
    return dest;
  }
  //记录数据是否删除
  int delKfn = 1;
  String image1Network = '';
  BuildContext rootBuildContext;
  //进度
  double progress = 0;
  int MactualId = 0;
  int actualId = 0;
  int actualState = 1;
  int warehouseId = 0;

  int inputLocation = -1;

  int inputProduct = -1;
  //暂存 传入的 loc_cd
  String loc_cd = '';
  //暂存 传入的 code
  String pro_code = '';
  String inputreason = '';

  String actualDate = '';
  String warehouse = '';

  int logicNum = 0;
  int HlogicNum = 0;

  //差值
  int difference = 0;

  //输入的
  int realNum = 0;

  List warehouseList = [];
  //实棚明细location_id 和 product_id存放位置
  Map<String, dynamic> actualInformation = {};
  Map<String, dynamic> actualProduct = {};

//位置数据
  Map<String, dynamic> locationData = {};
  //商品数据
  Map<String, dynamic> productData = {};

  // 构造函数
  ActualShelfModel(
      {required this.MactualId,
      required this.actualId,
      required this.actualState,
      required this.actualDate,
      required this.warehouse,
      required this.rootBuildContext,
      this.loc_cd = '',
      this.pro_code = '',
      this.locationData = const {},
      this.productData = const {}});
}
