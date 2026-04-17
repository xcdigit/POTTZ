import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/store/revenue_and_expenditure/bloc/revenue_and_expenditure_model.dart';

import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';

/**
 * 内容：受払照会-BLOC
 * 作者：熊草云
 * 时间：2023/09/22
 */
// 事件
abstract class RevenueAndExpenditureEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends RevenueAndExpenditureEvent {
  // 初始化事件
  InitEvent();
}

// 设置检索条件
class SetSearchEvent extends RevenueAndExpenditureEvent {
  // 初始化事件
  String key;
  String searchData;
  int searchId;
  SetSearchEvent(this.searchId, this.key, this.searchData);
}

// 查询检索条件事件
class QuerySearchShipStateEvent extends RevenueAndExpenditureEvent {
  // 出荷指示
  List<String> shipList;
  BuildContext context;
  // 查询出荷指示事件
  QuerySearchShipStateEvent(this.shipList, this.context);
}

// 刪除检索条件
class ClearSearchEvent extends RevenueAndExpenditureEvent {
  int index;
  ClearSearchEvent(this.index);
}

// 删除所以数据
class ClearAllEvent extends RevenueAndExpenditureEvent {
  ClearAllEvent();
}

// 设置检索条件
class SetSearchListEvent extends RevenueAndExpenditureEvent {
  List<String> conditionList;
  SetSearchListEvent(this.conditionList);
}

// 添加检索条件
class AddSearchEvent extends RevenueAndExpenditureEvent {
  String tempContent;
  AddSearchEvent(this.tempContent);
}

// 设置sort字段
class SetSortEvent extends RevenueAndExpenditureEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终
class RevenueAndExpenditureBloc
    extends WmsTableBloc<RevenueAndExpenditureModel> {
  // 刷新补丁
  @override
  RevenueAndExpenditureModel clone(RevenueAndExpenditureModel src) {
    return RevenueAndExpenditureModel.clone(src);
  }

  RevenueAndExpenditureBloc(RevenueAndExpenditureModel state) : super(state) {
    on<PageQueryEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (!state.loadingFlag) {
        state.pageNum = 0;
        // 加载标记
        state.loadingFlag = true;
      }
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_query_table_dtb_store_history_revenue_expenditure_search',
              params: {
                'p_warehouse': state.searchwarehouse,
                'p_action_name': state.searchaction,
                'p_date': state.searchdate,
                'p_user': StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser!
                    .company_id as int,
                'p_name_short': state.searchproductName,
              })
          .select('*')
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1)
          .order(state.sortCol, ascending: state.ascendingFlg);
      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        //入出庫区分
        // 入庫
        if (data[i]['store_kbn'] == '1') {
          data[i]['store_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.goods_receipt_input_button;
        }
        // 出庫
        else if (data[i]['store_kbn'] == '2') {
          data[i]['store_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.exit_input_button_1;
        } else {
          data[i]['store_kbn_name'] = '';
        }
        // 入/出荷予定区分
        // 入荷
        if (data[i]['rev_ship_kbn'] == '1') {
          data[i]['rev_ship_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.menu_content_2;
        }
        // 出荷
        else if (data[i]['rev_ship_kbn'] == '2') {
          data[i]['rev_ship_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.menu_content_3;
        } else {
          data[i]['rev_ship_kbn_name'] = '';
        }
        state.records.add(WmsRecordModel(i, data[i]));
      }
      // 总页数
      List<dynamic> count = await SupabaseUtils.getClient().rpc(
          'func_query_table_dtb_store_history_revenue_expenditure_search',
          params: {
            'p_warehouse': state.searchwarehouse,
            'p_action_name': state.searchaction,
            'p_date': state.searchdate,
            'p_user': StoreProvider.of<WMSState>(state.context)
                .state
                .loginUser!
                .company_id as int,
            'p_name_short': state.searchproductName,
          }).select('*');
      state.total = count.length;
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<InitEvent>((event, emit) async {
      // 打开加载状态
      add(PageQueryEvent());
      // 查询商品事件
      List<dynamic> warehouseData = await SupabaseUtils.getClient()
          .from('mtb_warehouse')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser!
                  .company_id as int);
      List<dynamic> actionData =
          await SupabaseUtils.getClient().from('mtb_action').select('*');
      // 商品列表
      state.warehouseList = warehouseData;
      state.actionList = actionData;
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<SetSearchEvent>((event, emit) async {
      Map<String, dynamic> shipTemp = Map<String, dynamic>();
      shipTemp[event.key] = event.searchData;
      if (event.searchId == 0) {
        state.warehouse = shipTemp;
      } else {
        state.action = shipTemp;
      }
      emit(clone(state));
    });
    // 检索条件
    on<QuerySearchShipStateEvent>((event, emit) async {
      BotToast.showLoading();
      String? warehouse;
      String? action;
      String? productName;
      String? date;
      for (int i = 0; i < event.shipList.length; i++) {
        List<String> parts = event.shipList[i].split("：");
        String key = parts[0];
        String value = parts[1];
        if (key == WMSLocalizations.i18n(event.context)!.delivery_note_20) {
          productName = value;
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.menu_content_4_10_11) {
          date = value;
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.warehouse_master_3) {
          warehouse = value;
        } else {
          action = value;
        }
      }
      state.searchwarehouse = warehouse;
      state.searchaction = action;
      state.searchproductName = productName;
      state.searchdate = date;
      state.loadingFlag = false;
      add(PageQueryEvent());
    });

    // 设置检索条件
    on<SetSearchListEvent>((event, emit) async {
      state.conditionList = event.conditionList;
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
}
