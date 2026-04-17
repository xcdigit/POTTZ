import 'package:flutter/cupertino.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/widget/table/bloc/wms_table_model.dart';

/**
 * 内容：申込受付-参数
 * 作者：cuihr
 * 时间：2023/12/18
 */
class ApplicationCceptanceModel extends WmsTableModel {
  // 克隆
  factory ApplicationCceptanceModel.clone(ApplicationCceptanceModel src) {
    ApplicationCceptanceModel dest =
        ApplicationCceptanceModel(context: src.context, appId: src.appId);
    dest.copy(src);
    // 自定义参数 - 始

    dest.count = src.count;
    dest.searchInfo = src.searchInfo;
    dest.formInfo = src.formInfo;
    dest.currentIndex = src.currentIndex;
    dest.tableTabIndex = src.tableTabIndex;
    dest.useTypeList = src.useTypeList;
    dest.loadingFlag = src.loadingFlag;
    dest.conditionList = src.conditionList;
    dest.optionList = src.optionList;
    dest.payCycleList = src.payCycleList;
    dest.payStatusList = src.payStatusList;
    dest.applicationStatusList = src.applicationStatusList;
    dest.applicationStatusDetailList = src.applicationStatusDetailList;
    dest.application_status = src.application_status;
    dest.application_status_name = src.application_status_name;
    dest.userCode = src.userCode;
    dest.image1Network = src.image1Network;
    dest.sortCol = src.sortCol;
    dest.ascendingFlg = src.ascendingFlg;
    // 自定义参数 - 终
    return dest;
  }

  // 自定义参数 - 始
  BuildContext context;
  // 检索条件展示用
  List<Map<String, dynamic>> conditionList = [];
  // 检索条件
  Map<String, dynamic> searchInfo = {};
  // 会社情报
  Map<String, dynamic> formInfo = {};
  //課金管理列表
  List<Map<String, dynamic>> useTypeList = [];
  // オプション(0：標準、１：連携オプション、２：文書管理オプション、３：取引先公開オプション)
  List<Map<String, dynamic>> optionList = [];
  // お支払いサイクル(0：月払い、１：年払い)
  List<Map<String, dynamic>> payCycleList = [];
  // 支払状態(0：未支払、１：支払済み)
  List<Map<String, dynamic>> payStatusList = [];
  //  申込状態（0：未受付、１：受付済み、2：却下）
  List<Map<String, dynamic>> applicationStatusList = [];
  //  明细受付申込状態（１：受付済み、2：却下）
  List<Map<String, dynamic>> applicationStatusDetailList = [];
  //一览个数
  int count = 0;

  int currentIndex = 0;

  int appId = 0;

  // 表格：Tab下标
  int tableTabIndex = Config.NUMBER_ZERO;
  // 加载标记
  bool loadingFlag = true;
  // 申請狀態
  String application_status = '';
  String application_status_name = '';
  // code
  String? userCode;
  String image1Network = '';
  //排序字段
  String sortCol = 'create_time';
  // 升降排序
  bool ascendingFlg = false;
  // 自定义参数 - 终

  // 构造函数
  ApplicationCceptanceModel({
    // 自定义参数 - 始
    required this.context,
    required this.appId,
    this.conditionList = const [],
    this.searchInfo = const {},
    this.formInfo = const {},
    this.useTypeList = const [],
    this.loadingFlag = true,
    this.optionList = const [],
    this.payCycleList = const [],
    this.payStatusList = const [],
    this.applicationStatusList = const [],
    this.applicationStatusDetailList = const [],
    this.tableTabIndex = Config.NUMBER_ZERO,
    this.application_status = '',
    this.application_status_name = '',
    this.image1Network = '',
    this.userCode,
    this.sortCol = 'create_time',
    this.ascendingFlg = false,
    // 自定义参数 - 终
  });
}
