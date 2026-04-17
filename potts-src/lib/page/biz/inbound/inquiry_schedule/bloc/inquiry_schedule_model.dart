import 'package:flutter/material.dart';

import '../../../../../common/config/config.dart';
import '../../../../../widget/table/bloc/wms_table_model.dart';

/**
 * 内容：入何予定照会-参数
 * 作者：赵士淞
 * 时间：2023/09/21
 */
class InquiryScheduleModel extends WmsTableModel {
  // 克隆
  factory InquiryScheduleModel.clone(InquiryScheduleModel src) {
    InquiryScheduleModel dest =
        InquiryScheduleModel(rootContext: src.rootContext);
    dest.copy(src);
    // 自定义参数 - 始
    dest.queryButtonFlag = src.queryButtonFlag;
    dest.queryInputContent = src.queryInputContent;
    dest.searchReceiveNo = src.searchReceiveNo;
    dest.searchRcvSchDateStart = src.searchRcvSchDateStart;
    dest.searchRcvSchDateEnd = src.searchRcvSchDateEnd;
    dest.searchOrderNo = src.searchOrderNo;
    dest.searchName = src.searchName;
    dest.searchProductName = src.searchProductName;
    dest.searchCsvKbn = src.searchCsvKbn;
    dest.searchImporterrorFlg = src.searchImporterrorFlg;
    dest.queryReceiveKbn = src.queryReceiveKbn;
    dest.queryReceiveNo = src.queryReceiveNo;
    dest.queryRcvSchDateStart = src.queryRcvSchDateStart;
    dest.queryRcvSchDateEnd = src.queryRcvSchDateEnd;
    dest.queryOrderNo = src.queryOrderNo;
    dest.queryName = src.queryName;
    dest.queryProductName = src.queryProductName;
    dest.queryCsvKbn = src.queryCsvKbn;
    dest.queryImporterrorFlg = src.queryImporterrorFlg;
    dest.tableTabIndex = src.tableTabIndex;
    dest.supplierList = src.supplierList;
    dest.productList = src.productList;
    dest.tableZeroNumber = src.tableZeroNumber;
    dest.tableOneNumber = src.tableOneNumber;
    dest.tableTwoNumber = src.tableTwoNumber;
    dest.tableThreeNumber = src.tableThreeNumber;
    dest.tableFourNumber = src.tableFourNumber;
    dest.tableFiveNumber = src.tableFiveNumber;
    dest.loadingFlag = src.loadingFlag;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  // 根结构树
  BuildContext rootContext;
  // 检索按钮标记
  bool queryButtonFlag = false;
  // 检索：输入框内容
  String queryInputContent = '';
  // 查询：入荷予定番号
  String searchReceiveNo = '';
  // 查询：入荷予定起始日
  String searchRcvSchDateStart = '';
  // 查询：入荷予定终了日
  String searchRcvSchDateEnd = '';
  // 查询：仕入先注文番号
  String searchOrderNo = '';
  // 查询：仕入先
  String searchName = '';
  // 查询：商品名
  String searchProductName = '';
  // 查询：連携状態
  String searchCsvKbn = '';
  // 查询：取込状態
  String searchImporterrorFlg = '';
  // 检索：入荷状態
  String queryReceiveKbn = '';
  // 检索：入荷予定番号
  String queryReceiveNo = '';
  // 检索：入荷予定起始日
  String queryRcvSchDateStart = '';
  // 检索：入荷予定终了日
  String queryRcvSchDateEnd = '';
  // 检索：仕入先注文番号
  String queryOrderNo = '';
  // 检索：仕入先
  String queryName = '';
  // 检索：商品名
  String queryProductName = '';
  // 检索：連携状態
  String queryCsvKbn = '';
  // 检索：取込状態
  String queryImporterrorFlg = '';
  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  // 供应商列表
  List<dynamic> supplierList = [];
  // 商品列表
  List<dynamic> productList = [];
  // 表格：一覧数量
  int tableZeroNumber = 0;
  // 表格：检品待ち数量
  int tableOneNumber = 0;
  // 表格：入庫待ち数量
  int tableTwoNumber = 0;
  // 表格：入庫中数量
  int tableThreeNumber = 0;
  // 表格：入荷確定待ち数量
  int tableFourNumber = 0;
  // 表格：入荷済み数量
  int tableFiveNumber = 0;
  // 加载标记
  bool loadingFlag = true;
  //排序字段
  String sortCol = 'dr_rcv_sch_date';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  InquiryScheduleModel({
    // 自定义参数 - 始
    required this.rootContext,
    this.queryButtonFlag = false,
    this.queryInputContent = '',
    this.searchReceiveNo = '',
    this.searchRcvSchDateStart = '',
    this.searchRcvSchDateEnd = '',
    this.searchOrderNo = '',
    this.searchName = '',
    this.searchProductName = '',
    this.searchCsvKbn = '',
    this.searchImporterrorFlg = '',
    this.queryReceiveKbn = '',
    this.queryReceiveNo = '',
    this.queryRcvSchDateStart = '',
    this.queryRcvSchDateEnd = '',
    this.queryOrderNo = '',
    this.queryName = '',
    this.queryProductName = '',
    this.queryCsvKbn = '',
    this.queryImporterrorFlg = '',
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.supplierList = const [],
    this.productList = const [],
    this.tableZeroNumber = 0,
    this.tableOneNumber = 0,
    this.tableTwoNumber = 0,
    this.tableThreeNumber = 0,
    this.tableFourNumber = 0,
    this.tableFiveNumber = 0,
    this.loadingFlag = true,
    this.sortCol = 'dr_rcv_sch_date',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
