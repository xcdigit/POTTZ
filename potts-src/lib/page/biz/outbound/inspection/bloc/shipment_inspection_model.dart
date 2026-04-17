import 'package:wms/model/location.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * 内容：出荷検品 - model
 * 作者：王光顺
 * author：张博睿
 * 时间：2023/09/19
 */

class ShipmentInspectionModel extends WmsTableModel {
  factory ShipmentInspectionModel.clone(ShipmentInspectionModel src) {
    ShipmentInspectionModel dest = ShipmentInspectionModel();
    dest.copy(src);
    // 自定义参数 - 始
    dest.companyId = src.companyId;
    dest.userId = src.userId;
    dest.shipData = src.shipData;
    dest.productformation = src.productformation;
    dest.shipStart = src.shipStart;
    // 纳品书code码
    dest.shipmentNote = src.shipmentNote;
    // 出荷指示番号
    dest.shipNo = src.shipNo;
    // 得意先
    dest.customer = src.customer;
    // 納入先
    dest.delivery = src.delivery;
    // 位置
    dest.location = src.location;
    // 商品code
    dest.productCode = src.productCode;
    // 商品名
    dest.productName = src.productName;
    // 出库数
    dest.storeOutCount = src.storeOutCount;
    // 商品写真
    dest.prpductImage1 = src.prpductImage1;
    // 商品标签code
    dest.productBarCode = src.productBarCode;
    // 合计数
    dest.numCount = src.numCount;
    // dtb_ship表主键
    dest.shipId = src.shipId;
    // 出荷狀態
    dest.shipKbn = src.shipKbn;
    dest.checkKbn = src.checkKbn;
    dest.oriconBarcode = src.oriconBarcode;
    dest.locationBarCodeList = src.locationBarCodeList;
    dest.pageNum = src.pageNum;
    dest.index = src.index;
    // 赵士淞 - 始
    // 打印纳品书No
    dest.printShipNo = src.printShipNo;
    // 赵士淞 - 终
    // 自定义参数 - 终
    return dest;
  }
  // 会社Id
  int? companyId;
  // 用户Id
  int? userId;
  List<dynamic> shipData = [];
  //纳品书检索商品数据
  List<dynamic> productformation = [];
  // 纳品书code码
  String shipmentNote = '';
  // 出荷指示番号
  String shipNo = '';
  // 得意先
  String customer = '';
  // 納入先
  String delivery = '';
  // 位置
  Location location = Location.empty();
  // 商品code
  String productCode = '';
  // 商品名
  String productName = '';
  // 出库数
  String storeOutCount = '';
  // 商品写真
  String prpductImage1 = '';
  String prpductImage2 = '';
  // 商品标签code
  String productBarCode = '';
  // 合计数
  String numCount = '';
  // dtb_ship表主键
  String shipId = '';
  // 出荷狀態
  String shipKbn = '';
  String checkKbn = '';
  Location oriconBarcode = Location.empty();
  List<dynamic> locationBarCodeList = [];

  int pageNum = 0;
  //当前页码
  int index = 0;

  //干品状态
  bool shipStart = false;

  // 赵士淞 - 始
  // 打印纳品书No
  String printShipNo = '';
  // 赵士淞 - 终

  ShipmentInspectionModel({
    this.companyId,
    this.userId,
    this.shipData = const [],
    this.productformation = const [],
    // 纳品书code码
    this.shipmentNote = '',
    // 出荷指示番号
    this.shipNo = '',
    // 得意先
    this.customer = '',
    // 納入先
    this.delivery = '',
    // 商品code
    this.productCode = '',
    // 商品名
    this.productName = '',
    // 出库数
    this.storeOutCount = '',
    // 商品写真
    this.prpductImage1 = '',
    // 商品标签code
    this.productBarCode = '',
    // 合计数
    this.numCount = '',
    // dtb_ship表主键
    this.shipId = '',
    // 出荷狀態
    this.shipKbn = '',
    this.checkKbn = '',
    this.locationBarCodeList = const [],
    this.index = 0,
    this.pageNum = 0,
    // 赵士淞 - 始
    // 打印纳品书No
    this.printShipNo = '',
    // 赵士淞 - 终
  });
}
