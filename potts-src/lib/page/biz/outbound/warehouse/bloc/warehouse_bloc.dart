import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/utils/check_utils.dart';

import 'package:wms/page/biz/outbound/warehouse/bloc/warehouse_model.dart';

import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';

import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';

/**
 * 内容：納品書-BLOC
 * 作者：王光顺
 * 时间：2023/09/18
 */
// 事件
abstract class WarehouseEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends WarehouseEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定检索条件事件
class SetShipValueEvent extends WarehouseEvent {
  // Value
  dynamic value;
  // 设定值事件
  SetShipValueEvent(this.value);
}

// 设定当前下标属性事件
class SetValueEvent extends WarehouseEvent {
  // Value
  int value;
  // 设定值事件
  SetValueEvent(this.value);
}

class ShipDateEvent extends WarehouseEvent {
  // 保存出荷指示明细表单事件
  ShipDateEvent();
}

// 保存出荷指示表单事件
class SaveShipFormEvent extends WarehouseEvent {
  // 结构树
  BuildContext context;
  // 保存出荷指示表单事件
  SaveShipFormEvent(this.context);
}

// 查询出荷指示明细事件
class QueryShipEvent extends WarehouseEvent {
  List<String> list;
  List<String> shipList;
  String searchData;
  String keyword;

  QueryShipEvent(this.list, this.shipList, this.searchData, this.keyword);
}

// 查询出荷指示明细事件
class QueryShipDetailEvent extends WarehouseEvent {
  // 出荷指示明细ID
  Map<String, dynamic> list;
  // 查询出荷指示明细事件
  QueryShipDetailEvent(this.list);
}

// 设定出荷指示明细值事件
class SetShipDetailValueEvent extends WarehouseEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetShipDetailValueEvent(this.key, this.value);
}

// 保存出荷指示明细表单事件
class SaveShipDetailFormEvent extends WarehouseEvent {
  // 结构树
  BuildContext context;
  // 保存出荷指示明细表单事件
  SaveShipDetailFormEvent(this.context);
}

// 删除出荷指示明细事件
class DeleteShipDetailEvent extends WarehouseEvent {
  // 结构树
  BuildContext context;
  // 出荷指示明细ID
  int shipDetailId;
  // 删除出荷指示明细事件
  DeleteShipDetailEvent(this.context, this.shipDetailId);
}

// 设置检索条件
class SetSearchEvent extends WarehouseEvent {
  // 初始化事件
  String key;
  String searchData;
  int searchId;
  SetSearchEvent(this.searchId, this.key, this.searchData);
}

// 更新納品書出力状态
class UpdatePdfKbnEvent extends WarehouseEvent {
  // 结构树
  BuildContext context;
  List<Map<String, dynamic>> contentList;
  UpdatePdfKbnEvent(this.context, this.contentList);
}

// 设置sort字段
class SetSortEvent extends WarehouseEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class WarehouseBloc extends WmsTableBloc<WarehouseModel> {
  // 刷新补丁
  @override
  WarehouseModel clone(WarehouseModel src) {
    return WarehouseModel.clone(src);
  }

  // 赵士淞 - 测试修复 2023/11/16 - 始
  List<String>? shipKbn = ['4', '5', '6', '7'];
  // 赵士淞 - 测试修复 2023/11/16 - 终
  List<dynamic>? pdfKbn;
  String? orderNo;
  String? shipNo;
  String? customerName;
  String? rcvSchDate1;
  String? rcvSchDate2;
  String? name;
  String? cusRevDate1;
  String? cusRevDate2;
  String? person;
  String? importerrorFlg;
  String? productName;
  String? keyword;

  WarehouseBloc(WarehouseModel state) : super(state) {
    // 查询分页数据事件

    // SetSearchEvent 检索条件
    on<SetSearchEvent>((event, emit) async {
      Map<String, dynamic> shipTemp = Map<String, dynamic>();
      shipTemp.addAll(state.customer);
      shipTemp[event.key] = event.searchData;
      if (event.searchId == 0) {
        state.customer = shipTemp;
      } else if (event.searchId == 1) {
        Map<String, dynamic> shipTemp = Map<String, dynamic>();
        shipTemp.addAll(state.customer);
        shipTemp[event.key] = event.searchData;
        state.name = shipTemp;
      } else if (event.searchId == 2) {
        state.person = shipTemp;
      } else {
        state.product = shipTemp;
      }
      emit(clone(state));
    });

    // 检索查询分页数据事件
    on<QueryShipEvent>((event, emit) async {
      // 'func_query_table_dtb_ship_inquiry_search' 10/23 因搜索架构调整已删除
      //开始检索条件解析
      if (event.keyword == '') {
        keyword = null;
        state.keyword = event.keyword;
      } else {
        state.keyword = event.keyword;
        keyword = state.keyword;
      }

      state.conditionLabelList = event.shipList;
      //清除局部变量值
      if (event.shipList.length == 0) {
        pdfKbn = null;
        orderNo = null;
        shipNo = null;
        customerName = null;
        rcvSchDate1 = null;
        rcvSchDate2 = null;
        name = null;
        cusRevDate1 = null;
        cusRevDate2 = null;
        person = null;
        importerrorFlg = null;
        productName = null;
        state.pdfKbn = [];
      } else {
        for (int i = 0; i < event.shipList.length; i++) {
          List<String> parts = event.shipList[i].split("：");
          String key = parts[0];
          String value = parts[1];

          // ignore: unnecessary_null_comparison
          if (!(state.context == null) &&
              key == WMSLocalizations.i18n(state.context)!.delivery_note_12 &&
              value != '') {
            List<String> In = [];
            List<String> partss = value.split(",");
            for (int i = 0; i < partss.length; i++) {
              if (partss[i] ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_22) {
                In.addAll(['1', '2', '3']);
              } else if (partss[i] ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_4) {
                In.addAll(['1']);
              } else if (partss[i] ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_5) {
                In.addAll(['2', '3']);
              }
            }
            List<String> Out = In.toSet().toList();

            state.pdfKbn = Out;
          } else if (key ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_13 &&
              value != '') {
            orderNo = value;
          } else if (key ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_14 &&
              value != '') {
            shipNo = value;
          } else if (key ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_15 &&
              value != '') {
            customerName = value;
          } else if (key ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_16 &&
              value != '') {
            if (value.contains('-')) {
              List<String> partsDate = value.split("-");
              rcvSchDate1 = partsDate[0];
              rcvSchDate2 = partsDate[1];
            } else {
              if (value.contains('^')) {
                rcvSchDate1 = value.replaceAll('^', '');
              } else {
                rcvSchDate2 = value;
              }
            }
          } else if (key ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_17 &&
              value != '') {
            name = value;
          } else if (key ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_18 &&
              value != '') {
            if (value.contains('-')) {
              List<String> partsDatee = value.split("-");
              cusRevDate1 = partsDatee[0];
              cusRevDate2 = partsDatee[1];
            } else {
              if (value.contains('^')) {
                cusRevDate1 = value.replaceAll('^', '');
              } else {
                cusRevDate2 = value;
              }
            }
          } else if (key ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_19 &&
              value != '') {
            person = value;
          } else if (key ==
                  WMSLocalizations.i18n(state.context)!.delivery_note_20 &&
              value != '') {
            productName = value;
          }
        }
      }
      if (state.pdfKbn.length == 0) {
        state.pdfKbn = ['1', '2', '3'];
      }
      if (event.list.length == 0) {
        pdfKbn = state.pdfKbn;
      } else {
        pdfKbn = event.list;
      }

      //载入页面数据
      /////////////////
      state.loadingFlag = false;
      // 更新
      emit(clone(state));
      add(PageQueryEvent());
    });

    // 检索条件
    on<PageQueryEvent>((event, emit) async {
      //页数据总数量统计
      // 打开加载状态
      if (state.loadingFirst) {
        BotToast.showLoading();
      }
      if (!state.loadingFlag) {
        state.pageNum = 0;
        // 加载标记
        state.loadingFlag = true;
      }
      List<dynamic> dataLength = await pageTotalNumber(state);
      state.count = dataLength.length;
      state.count1 = dataLength.where((data) => data['pdf_kbn'] == '1').length;
      state.count2 = dataLength
          .where((data) => ['2', '3'].contains(data['pdf_kbn']))
          .length;

      List<dynamic> Searchdata = await SupabaseUtils.getClient()
          .rpc('func_query_table_book_dtb_ship_inquiry', params: {
            'p_ship_kbn': shipKbn,
            'p_pdf_kbn': state.pdfKbn,
            'p_order_no': orderNo,
            'p_ship_no': shipNo,
            'p_customer_name': customerName,
            'p_rcv_sch_date1': rcvSchDate1,
            'p_rcv_sch_date2': rcvSchDate2,
            'p_name': name,
            'p_cus_rev_date1': cusRevDate1,
            'p_cus_rev_date2': cusRevDate2,
            'p_person': person,
            'p_importerror_flg': importerrorFlg,
            'p_product_name': productName,
            'p_keyword': keyword,
            'p_company_id': StoreProvider.of<WMSState>(state.context)
                .state
                .loginUser
                ?.company_id,
          })
          .in_('pdf_kbn', pdfKbn!)
          .select('*')
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);

      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < Searchdata.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, Searchdata[i]));
      }
      state.loadingFirst = true;
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_query_table_book_dtb_ship_inquiry', params: {
            'p_ship_kbn': shipKbn,
            'p_pdf_kbn': state.pdfKbn,
            'p_order_no': orderNo,
            'p_ship_no': shipNo,
            'p_customer_name': customerName,
            'p_rcv_sch_date1': rcvSchDate1,
            'p_rcv_sch_date2': rcvSchDate2,
            'p_name': name,
            'p_cus_rev_date1': cusRevDate1,
            'p_cus_rev_date2': cusRevDate2,
            'p_person': person,
            'p_importerror_flg': importerrorFlg,
            'p_product_name': productName,
            'p_keyword': keyword,
            'p_company_id': StoreProvider.of<WMSState>(state.context)
                .state
                .loginUser
                ?.company_id,
          })
          .in_('pdf_kbn', pdfKbn!)
          .select('*');
      state.total = count.length;
      // 更新
      emit(clone(state));

      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 自定义事件 - 始
      // 查询客户
      List customerNames = await SupabaseUtils.getClient()
          .from('mtb_customer')
          .select('*')
          .eq('del_kbn', '2')
          .eq('company_id', state.companyId)
          .gte('application_end_date',
              DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .lte('application_start_date',
              DateFormat('yyyy-MM-dd').format(DateTime.now()));
      // 得意先列表
      state.customerList = customerNames;
      // 纳入先列表
      List<dynamic> customerAddressData = await SupabaseUtils.getClient()
          .from('mtb_customer_address')
          .select('*')
          .eq('del_kbn', '2')
          .eq('company_id', state.companyId);
      // 纳入先列表
      state.nameList = customerAddressData;
      // 担当者
      List personData = await SupabaseUtils.getClient()
          .from('mtb_customer_address')
          .select('*')
          .eq('del_kbn', '2')
          .eq('company_id', state.companyId);
      // 仓库列表
      state.personList = personData;
      // 查询商品事件
      List<dynamic> productData = await SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq('del_kbn', '2')
          .eq('company_id', state.companyId);
      // 商品列表
      state.productList = productData;

      // 查询分页数据事件
      add(QueryShipEvent(['1', '2', '3'], [], '', state.keyword));
      // 自定义事件 - 终
    });

    // 自定义事件 - 始
    // 设定检索条件事件
    on<SetShipValueEvent>((event, emit) async {
      // 出荷指示-临时

      if (event.value != null) state.conditionLabelList = event.value;

      // 更新
      emit(clone(state));
    });

    // 自定义事件 - 始
    // 设定下标条件事件
    on<SetValueEvent>((event, emit) async {
      // 出荷指示-临时
      // ignore: unnecessary_null_comparison
      if (event.value != null) state.currentIndex = event.value;
      // 更新
      emit(clone(state));
    });

    on<ShipDateEvent>((event, emit) async {
      int shipNoint = 0;
      state.checkedRecords().forEach((record) {
        int shipNo = record.data as int;
        shipNoint = (shipNo);
      });
      state.shipId = shipNoint;
      emit(clone(state));
    });

    // 更新納品書出力状态
    on<UpdatePdfKbnEvent>((event, emit) async {
      for (int i = 0; i < event.contentList.length; i++) {
        String pdfKbn = '2';
        if (event.contentList[i]['pdf_kbn'] == '2' ||
            event.contentList[i]['pdf_kbn'] == '3') {
          pdfKbn = '3';
        }
        await SupabaseUtils.getClient()
            .from('dtb_ship')
            .update({'pdf_kbn': pdfKbn}).eq('id', event.contentList[i]['id']);
      }
    });

    // 设置sort字段
    on<SetSortEvent>((event, emit) async {
      state.sortCol = event.sortCol;
      state.ascendingFlg = event.asc;
      emit(clone(state));
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    add(InitEvent());
  }

  // 查询总数量
  Future<List<dynamic>> pageTotalNumber(WarehouseModel state) async {
    // 查询入荷予定照会总数
    List<dynamic> count;
    count = await SupabaseUtils.getClient()
        .rpc('func_query_table_book_dtb_ship_inquiry', params: {
      'p_ship_kbn': shipKbn,
      'p_pdf_kbn': state.pdfKbn,
      'p_order_no': orderNo,
      'p_ship_no': shipNo,
      'p_customer_name': customerName,
      'p_rcv_sch_date1': rcvSchDate1,
      'p_rcv_sch_date2': rcvSchDate2,
      'p_name': name,
      'p_cus_rev_date1': cusRevDate1,
      'p_cus_rev_date2': cusRevDate2,
      'p_person': person,
      'p_importerror_flg': importerrorFlg,
      'p_product_name': productName,
      'p_keyword': keyword,
      'p_company_id':
          StoreProvider.of<WMSState>(state.context).state.loginUser?.company_id,
    }).select();

    // 返回
    return count;
  }

  //检索前check处理
  bool selectBeforeCheck(BuildContext context, String orderNo, String shipNo) {
    //检索条件check
    // 得意先注文番号 半角英数
    if (orderNo != '') {
      if (CheckUtils.check_Half_Alphanumeric(orderNo)) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.delivery_note_13 +
                WMSLocalizations.i18n(context)!.input_letter_and_number_check);
        return false;
      }
    }
    // 出荷指示番号 半角英数記号
    if (shipNo != '') {
      if (CheckUtils.check_Half_Alphanumeric_Symbol(shipNo)) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.delivery_note_14 +
                WMSLocalizations.i18n(context)!
                    .input_letter_and_number_and_symbol_check);
        return false;
      }
    }

    return true;
  }
}
