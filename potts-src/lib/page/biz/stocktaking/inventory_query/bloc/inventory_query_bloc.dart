import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'inventory_query_model.dart';

/**
 * 内容：棚卸照会-BLOC
 * 作者：熊草云
 * 时间：2023/10/07
 */
// 事件
abstract class InventoryQueryEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends InventoryQueryEvent {
  // 初始化事件
  InitEvent();
}

// 检索日期事件
class SearchDateEvent extends InventoryQueryEvent {
  int flag;
  String value;

  // 检索日期事件
  SearchDateEvent(this.flag, this.value);
}

// 检索下拉事件
class SearchDropEvent extends InventoryQueryEvent {
  String value;
  int id;

  // 检索下拉事件
  SearchDropEvent(this.value, this.id);
}

// 查询检索事件
class QuerySearchEvent extends InventoryQueryEvent {
  // 查询检索事件
  QuerySearchEvent();
}

// 检索Tab事件
class SearchTabEvent extends InventoryQueryEvent {
  int flag;

  // 检索Tab事件
  SearchTabEvent(this.flag);
}

// 删除事件
class DeleteEvent extends InventoryQueryEvent {
  BuildContext context;
  Map<String, dynamic> value;

  // 删除事件
  DeleteEvent(this.context, this.value);
}

// 设置sort字段
class SetSortEvent extends InventoryQueryEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终
class InventoryQueryBloc extends WmsTableBloc<InventoryQueryModel> {
  // 刷新补丁
  @override
  InventoryQueryModel clone(InventoryQueryModel src) {
    return InventoryQueryModel.clone(src);
  }

  InventoryQueryBloc(InventoryQueryModel state) : super(state) {
    // 查询分页事件
    on<PageQueryEvent>((event, emit) async {
      // 判断加载标记
      if (state.loadingFlag) {
        // 打开加载状态
        BotToast.showLoading();
      } else {
        // 页数
        state.pageNum = 0;
        // 加载标记
        state.loadingFlag = true;
      }

      // 查询棚卸
      List<dynamic> data1 = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_long_dtb_inventory', params: {
            'company_id': StoreProvider.of<WMSState>(state.context)
                .state
                .loginUser
                ?.company_id as int,
            'start_date':
                state.queryStartDate == '' ? null : state.queryStartDate,
            'over_date': state.queryOverDate == '' ? null : state.queryOverDate,
            'warehouse_id': state.queryWarehouseId == Config.NUMBER_NEGATIVE
                ? null
                : state.queryWarehouseId,
            'confirm_flg': state.queryConfirmFlg,
            'del_kbn': Config.DELETE_NO,
            'end_kbn': Config.END_KBN_1,
          })
          .select('*')
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1)
          .order(state.sortCol, ascending: state.ascendingFlg);
      // 列表数据清空
      state.records.clear();
      // 循环棚卸数据
      for (int i = 0; i < data1.length; i++) {
        // 数据处理
        if (data1[i]['confirm_flg'] == Config.CONFIRM_KBN_2)
          data1[i]['confirm_name'] = WMSLocalizations.i18n(state.context)!
              .instruction_input_tab_Undetermined;
        if (data1[i]['confirm_flg'] == Config.CONFIRM_KBN_1)
          data1[i]['confirm_name'] = WMSLocalizations.i18n(state.context)!
              .instruction_input_tab_Determined;
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data1[i]));
      }

      // 查询总数量
      List<dynamic> data2 = await pageTotalNumber(state.queryConfirmFlg);
      // 总数
      state.total = data2.length;

      List<dynamic> totalDataList1 = await pageTotalNumber(['2']);
      // Tab1数量
      state.sum1 = totalDataList1.length;
      // 查询总数量
      List<dynamic> totalDataList2 = await pageTotalNumber(['1']);
      // Tab2数量
      state.sum2 = totalDataList2.length;
      // 查询总数量
      List<dynamic> totalDataList3 = await pageTotalNumber(['1', '2']);
      // Tab3数量
      state.sum3 = totalDataList3.length;

      // 刷新补丁
      emit(clone(state));
      // 关闭加载状态
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询仓库
      List<dynamic> warehouseData = await SupabaseUtils.getClient()
          .from('mtb_warehouse')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int);
      // 仓库列表
      state.warehouseList = warehouseData;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页事件
      add(PageQueryEvent());
    });

    // 检索日期事件
    on<SearchDateEvent>((event, emit) async {
      // 判断标记
      if (event.flag == Config.NUMBER_ONE) {
        // 检索开始日期
        state.queryStartDate = event.value;
      } else if (event.flag == Config.NUMBER_TWO) {
        // 检索结束日期
        state.queryOverDate = event.value;
      }

      // 刷新补丁
      emit(clone(state));
    });

    // 检索下拉事件
    on<SearchDropEvent>((event, emit) async {
      // 检索仓库值
      state.queryWarehouseValue = event.value;
      // 检索仓库ID
      state.queryWarehouseId = event.id;

      // 刷新补丁
      emit(clone(state));
    });

    // 检索条件
    on<QuerySearchEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 加载标记
      state.loadingFlag = false;
      // 查询分页事件
      add(PageQueryEvent());
    });

    // 检索Tab事件
    on<SearchTabEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 表格：Tab下标
      state.tableTabIndex = event.flag;

      // 判断标记
      if (event.flag == Config.NUMBER_ZERO) {
        // 检索确认标记
        state.queryConfirmFlg = ['2'];
      } else if (event.flag == Config.NUMBER_ONE) {
        // 检索确认标记
        state.queryConfirmFlg = ['1'];
      } else if (event.flag == Config.NUMBER_TWO) {
        // 检索确认标记
        state.queryConfirmFlg = ['1', '2'];
      }

      // 加载标记
      state.loadingFlag = false;
      // 查询分页事件
      add(PageQueryEvent());
    });

    // 删除事件
    on<DeleteEvent>((event, emit) async {
      // 判断确认状态
      if (event.value['confirm_flg'] == Config.CONFIRM_KBN_1) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.inventory_query_tip_1);
        // 关闭弹窗
        Navigator.pop(event.context);
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      try {
        // 删除棚卸
        await SupabaseUtils.getClient().from('dtb_inventory').update({
          'del_kbn': Config.DELETE_YES,
        }).eq('id', event.value['id']);
        // 删除棚卸明细
        await SupabaseUtils.getClient().from('dtb_inventory_detail').update({
          'del_kbn': Config.DELETE_YES,
        }).eq('inventory_id', event.value['id']);
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.context)!.menu_content_5 +
                WMSLocalizations.i18n(state.context)!.delete_error);
        // 关闭加载状态
        BotToast.closeAllLoading();
        // 关闭弹窗
        Navigator.pop(event.context);
        return;
      }

      // 成功提示
      WMSCommonBlocUtils.successTextToast(
          WMSLocalizations.i18n(state.context)!.menu_content_5 +
              WMSLocalizations.i18n(state.context)!.delete_success);
      // 关闭弹窗
      Navigator.pop(event.context);

      // 加载标记
      state.loadingFlag = false;
      // 查询分页事件
      add(PageQueryEvent());
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
  Future<List<dynamic>> pageTotalNumber(List<dynamic> confirmFlgList) async {
    // 查询棚卸
    List<dynamic> count = await SupabaseUtils.getClient()
        .rpc('func_zhaoss_query_table_long_dtb_inventory', params: {
      'company_id': StoreProvider.of<WMSState>(state.context)
          .state
          .loginUser
          ?.company_id as int,
      'start_date': state.queryStartDate == '' ? null : state.queryStartDate,
      'over_date': state.queryOverDate == '' ? null : state.queryOverDate,
      'warehouse_id': state.queryWarehouseId == Config.NUMBER_NEGATIVE
          ? null
          : state.queryWarehouseId,
      'confirm_flg': confirmFlgList,
      'del_kbn': Config.DELETE_NO,
      'end_kbn': Config.END_KBN_1,
    }).select('*');

    // 返回
    return count;
  }
}
