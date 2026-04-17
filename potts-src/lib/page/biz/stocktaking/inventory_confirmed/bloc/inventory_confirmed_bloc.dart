import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/model/store_history.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'inventory_confirmed_model.dart';
import 'package:intl/intl.dart';

/**
 * 内容：棚卸確定-BLOC
 * 作者：熊草云
 * 时间：2023/10/09
 */
// 事件
abstract class InventoryConfirmedEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends InventoryConfirmedEvent {
  // 初始化事件
  InitEvent();
}

// 检索下拉事件
class SearchDropEvent extends InventoryConfirmedEvent {
  String value;
  int id;

  // 检索下拉事件
  SearchDropEvent(this.value, this.id);
}

// 检索日期事件
class SearchDateEvent extends InventoryConfirmedEvent {
  int flag;
  String value;

  // 检索日期事件
  SearchDateEvent(this.flag, this.value);
}

// 查询检索事件
class QuerySearchEvent extends InventoryConfirmedEvent {
  // 查询检索事件
  QuerySearchEvent();
}

// 检索Tab事件
class SearchTabEvent extends InventoryConfirmedEvent {
  int flag;

  // 检索Tab事件
  SearchTabEvent(this.flag);
}

// 确定事件
class ConfirmedEvent extends InventoryConfirmedEvent {
  int flag;
  Map<String, dynamic> currentData;

  // 确定事件
  ConfirmedEvent(this.flag, this.currentData);
}

// 取消事件
class CancelEvent extends InventoryConfirmedEvent {
  int flag;
  Map<String, dynamic> currentData;

  // 取消事件
  CancelEvent(this.flag, this.currentData);
}

// 设置sort字段
class SetSortEvent extends InventoryConfirmedEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终
class InventoryConfirmedBloc extends WmsTableBloc<InventoryConfirmedModel> {
  // 刷新补丁
  @override
  InventoryConfirmedModel clone(InventoryConfirmedModel src) {
    return InventoryConfirmedModel.clone(src);
  }

  InventoryConfirmedBloc(InventoryConfirmedModel state) : super(state) {
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
          .rpc('func_zhaoss_query_table_dtb_inventory', params: {
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
          })
          .select('*')
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);

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

      // 赵士淞 - 始
      // 查询棚卸
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_dtb_inventory', params: {
        'company_id': StoreProvider.of<WMSState>(state.context)
            .state
            .loginUser
            ?.company_id as int,
        'start_date': state.queryStartDate == '' ? null : state.queryStartDate,
        'over_date': state.queryOverDate == '' ? null : state.queryOverDate,
        'warehouse_id': state.queryWarehouseId == Config.NUMBER_NEGATIVE
            ? null
            : state.queryWarehouseId,
        'confirm_flg': ['1', '2'],
        'del_kbn': Config.DELETE_NO,
      }).select('*');
      // Tab1数量
      state.sum1 = count.length;
      // Tab2数量
      state.sum2 = 0;
      // Tab3数量
      state.sum3 = 0;
      // 循环棚卸
      for (int i = 0; i < count.length; i++) {
        // 判断确认状态
        if (count[i]['confirm_flg'] == '2') {
          // Tab2数量
          state.sum2 += 1;
        } else if (count[i]['confirm_flg'] == '1') {
          // Tab3数量
          state.sum3 += 1;
        }
      }
      // 判断检索确认标记长度
      if (state.queryConfirmFlg.length == 2) {
        // 总数
        state.total = state.sum1;
      } else if (state.queryConfirmFlg.length == 1) {
        // 判断检索确认标记
        if (state.queryConfirmFlg[0] == '2') {
          // 总数
          state.total = state.sum2;
        } else if (state.queryConfirmFlg[0] == '1') {
          // 总数
          state.total = state.sum3;
        }
      } else {
        // 总数
        state.total = 0;
      }
      // 赵士淞 - 终

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

      // 表格操作框高度
      state.operatePopupHeight = 134;
      // 表格操作框内容
      state.operatePopupOptions = [
        {
          'title': WMSLocalizations.i18n(state.context)!
              .Inventory_Confirmed_Table_Buttton_3,
          'callback': (_, value) {
            // 确定事件
            add(ConfirmedEvent(Config.NUMBER_TWO, value));
          }
        },
        {
          'title': WMSLocalizations.i18n(state.context)!
              .Inventory_Confirmed_Table_Buttton_4,
          'callback': (_, value) {
            // 取消事件
            add(CancelEvent(Config.NUMBER_TWO, value));
          }
        }
      ];

      // 加载标记
      state.loadingFlag = false;
      // 查询分页事件
      add(PageQueryEvent());
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
        state.queryConfirmFlg = ['1', '2'];
      } else if (event.flag == Config.NUMBER_ONE) {
        // 检索确认标记
        state.queryConfirmFlg = ['2'];
      } else if (event.flag == Config.NUMBER_TWO) {
        // 检索确认标记
        state.queryConfirmFlg = ['1'];
      }

      // 表格操作框高度
      state.operatePopupHeight = state.queryConfirmFlg.length == 2 ? 134 : 94;
      // 表格操作框内容
      state.operatePopupOptions = state.queryConfirmFlg.length == 2
          ? [
              {
                'title': WMSLocalizations.i18n(state.context)!
                    .Inventory_Confirmed_Table_Buttton_3,
                'callback': (_, value) {
                  // 确定事件
                  add(ConfirmedEvent(Config.NUMBER_TWO, value));
                }
              },
              {
                'title': WMSLocalizations.i18n(state.context)!
                    .Inventory_Confirmed_Table_Buttton_4,
                'callback': (_, value) {
                  // 取消事件
                  add(CancelEvent(Config.NUMBER_TWO, value));
                }
              }
            ]
          : state.queryConfirmFlg[0] == '2'
              ? [
                  {
                    'title': WMSLocalizations.i18n(state.context)!
                        .Inventory_Confirmed_Table_Buttton_3,
                    'callback': (_, value) {
                      // 确定事件
                      add(ConfirmedEvent(Config.NUMBER_TWO, value));
                    }
                  },
                ]
              : state.queryConfirmFlg[0] == '1'
                  ? [
                      {
                        'title': WMSLocalizations.i18n(state.context)!
                            .Inventory_Confirmed_Table_Buttton_4,
                        'callback': (_, value) {
                          // 取消事件
                          add(CancelEvent(Config.NUMBER_TWO, value));
                        }
                      }
                    ]
                  : [];

      // 加载标记
      state.loadingFlag = false;
      // 查询分页事件
      add(PageQueryEvent());
    });

    // 确定事件
    on<ConfirmedEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 提示文本
      String tipText = '';
      // 数据
      List<Map<String, dynamic>> data = [];

      // 判断标记
      if (event.flag == Config.NUMBER_ONE) {
        // 循环选中行
        state.checkedRecords().forEach((record) {
          // 行数据
          Map<String, dynamic> recordData = record.data;
          // 数据
          data.add(recordData);
        });
      } else {
        // 数据
        data.add(event.currentData);
      }

      // 判断数据数量
      if (data.length == 0) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.Inventory_Confirmed_tip_1);
        // 关闭加载状态
        BotToast.closeAllLoading();
        return;
      }

      // 循环数据
      for (int i = 0; i < data.length; i++) {
        // 判断确认状态
        if (data[i]['confirm_flg'] == Config.CONFIRM_KBN_1) {
          // 提示文本
          tipText = tipText == ''
              ? WMSLocalizations.i18n(state.context)!.Inventory_Confirmed_tip_13
              : tipText;
          continue;
        }

        // 查询棚卸明细
        List<dynamic> dataDetail = await SupabaseUtils.getClient()
            .from('dtb_inventory_detail')
            .select('*')
            .eq('inventory_id', data[i]['id'])
            .eq('del_kbn', Config.DELETE_NO);
        // 是否存在完了状态
        bool hasValueTwo =
            dataDetail.any((item) => item['end_kbn'] == Config.END_KBN_2);
        // 判断是否存在完了状态
        if (hasValueTwo) {
          // 提示文本
          tipText = tipText == ''
              ? WMSLocalizations.i18n(state.context)!.Inventory_Confirmed_tip_3
              : tipText;
          continue;
        }

        try {
          // 更新棚卸
          await SupabaseUtils.getClient().from('dtb_inventory').update({
            'confirm_date': DateTime.now().toIso8601String(),
            'confirm_flg': Config.CONFIRM_KBN_1,
          }).eq('id', data[i]['id']);
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.context)!.menu_content_5 +
                  WMSLocalizations.i18n(state.context)!.update_error);
          // 关闭加载状态
          BotToast.closeAllLoading();
          return;
        }

        // 循环棚卸明细
        for (int j = 0; j < dataDetail.length; j++) {
          // 判断差异状态
          if (dataDetail[j]['diff_kbn'] == Config.DIFF_KBN_1) {
            // 查询在库
            List<dynamic> storeList = await SupabaseUtils.getClient()
                .from('dtb_store')
                .select('*')
                .eq('product_id', dataDetail[j]['product_id'])
                .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()));

            // 赵士淞 - 始
            // 最终在库数
            var endNum = storeList[0]['stock'] +
                dataDetail[j]['real_num'] -
                dataDetail[j]['logic_num'];
            // 赵士淞 - 终

            // 判断在库数与ロック数
            if (endNum < storeList[0]['lock_stock']) {
              // 提示文本
              tipText = tipText == ''
                  ? WMSLocalizations.i18n(state.context)!
                      .inventory_confirmed_text_1
                  : tipText;
              continue;
            }

            try {
              // 更新在庫
              await SupabaseUtils.getClient()
                  .from('dtb_store')
                  .update({
                    'stock': endNum,
                    'inventory_stock': dataDetail[j]['real_num']
                  })
                  .eq('product_id', dataDetail[j]['product_id'])
                  .eq('year_month',
                      DateFormat('yyyyMM').format(DateTime.now()));
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.context)!.menu_content_4 +
                      WMSLocalizations.i18n(state.context)!.update_error);
              // 关闭加载状态
              BotToast.closeAllLoading();
              return;
            }

            // 查询商品在库
            List<dynamic> productLocationList = await SupabaseUtils.getClient()
                .from('dtb_product_location')
                .select('*')
                .eq('location_id', dataDetail[j]['location_id'])
                .eq('product_id', dataDetail[j]['product_id']);

            // 判断在库数与ロック数
            if (dataDetail[j]['real_num'] <
                productLocationList[0]['lock_stock']) {
              // 提示文本
              tipText = tipText == ''
                  ? WMSLocalizations.i18n(state.context)!
                      .inventory_confirmed_text_1
                  : tipText;
              continue;
            }

            try {
              // 更新商品在庫
              await SupabaseUtils.getClient()
                  .from('dtb_product_location')
                  .update({
                    'stock': dataDetail[j]['real_num'],
                  })
                  .eq('location_id', dataDetail[j]['location_id'])
                  .eq('product_id', dataDetail[j]['product_id']);
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.context)!
                          .outbound_adjust_query_location +
                      WMSLocalizations.i18n(state.context)!.update_error);
              // 关闭加载状态
              BotToast.closeAllLoading();
              return;
            }

            // 临时数据
            Map<String, dynamic> tempData = {
              "stock_id": storeList[0]['id'],
              "year_month": DateFormat('yyyyMM').format(DateTime.now()),
              "product_id": dataDetail[j]['product_id'],
              "location_id": dataDetail[j]['location_id'],
              "action_id": int.parse(Config.ACTION_ID_13),
              "company_id": StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int,
            };
            // 受払明細
            StoreHistory storeHistory = StoreHistory.fromJson(tempData);

            try {
              // 新增受払明細
              await SupabaseUtils.getClient()
                  .from('dtb_store_history')
                  .insert(storeHistory);
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.context)!.menu_content_4_10 +
                      WMSLocalizations.i18n(state.context)!.update_error);
              // 关闭加载状态
              BotToast.closeAllLoading();
              return;
            }
          }
        }
      }

      // 判断提示文本
      if (tipText != '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(tipText);
      } else {
        // 成功提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.Inventory_Confirmed_tip_11);
      }

      // 插入操作履历 sys_log表
      CommonUtils().createLogInfo(
          '棚卸確定' +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT5 +
              Config.OPERATION_TEXT2,
          "ConfirmedEvent()",
          StoreProvider.of<WMSState>(state.context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(state.context).state.loginUser!.id);

      // 加载标记
      state.loadingFlag = false;
      // 查询分页事件
      add(PageQueryEvent());
    });

    // 取消事件
    on<CancelEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 数据
      List<Map<String, dynamic>> data = [];

      // 判断标记
      if (event.flag == Config.NUMBER_ONE) {
        // 循环选中行
        state.checkedRecords().forEach((record) {
          // 行数据
          Map<String, dynamic> recordData = record.data;
          // 数据
          data.add(recordData);
        });
      } else {
        // 数据
        data.add(event.currentData);
      }

      // 判断数据数量
      if (data.length != 1) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.menu_content_2_5_13);
        // 关闭加载状态
        BotToast.closeAllLoading();
        return;
      }

      // 查询棚卸
      List<dynamic> inventory1 = await SupabaseUtils.getClient()
          .from('dtb_inventory')
          .select('*')
          .eq('warehouse_id', data[0]['warehouse_id'])
          .eq(
              "company_id",
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int)
          .eq('confirm_flg', Config.CHECK_KBN_2)
          .eq('del_kbn', Config.DELETE_NO);

      // 判断棚卸数量
      if (inventory1.length > 0) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.Inventory_Confirmed_tip_6);
        // 关闭加载状态
        BotToast.closeAllLoading();
        return;
      }

      // 查询棚卸
      List<dynamic> inventory2 = await SupabaseUtils.getClient()
          .from('dtb_inventory')
          .select('*')
          .eq('warehouse_id', data[0]['warehouse_id'])
          .eq(
              "company_id",
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int)
          .eq('del_kbn', Config.DELETE_NO)
          .order('start_date', ascending: false);

      // 查询棚卸时间
      String date1 = inventory2[0]['start_date'];
      // 选择棚卸时间
      String date2 = data[0]['start_date'].split('T')[0];
      // 判断查询棚卸时间与选择棚卸时间
      if (date1 != date2) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.Inventory_Confirmed_tip_7);
        // 关闭加载状态
        BotToast.closeAllLoading();
        return;
      }

      try {
        // 更新棚卸
        await SupabaseUtils.getClient().from('dtb_inventory').update({
          'confirm_date': null,
          'confirm_flg': Config.CONFIRM_KBN_2,
        }).eq('id', data[0]['id']);
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.context)!.menu_content_5 +
                WMSLocalizations.i18n(state.context)!.update_error);
        // 关闭加载状态
        BotToast.closeAllLoading();
        return;
      }

      // 查询棚卸明細
      List<dynamic> dataDetail = await SupabaseUtils.getClient()
          .from('dtb_inventory_detail')
          .select('*')
          .eq('inventory_id', data[0]['id'])
          .eq('del_kbn', Config.DELETE_NO);

      // 循环棚卸明細
      for (int i = 0; i < dataDetail.length; i++) {
        // 判断差异状态
        if (dataDetail[i]['diff_kbn'] == Config.DIFF_KBN_1) {
          // 在库列表
          List<dynamic> storeList = [];

          try {
            // 更新在庫
            storeList = await SupabaseUtils.getClient()
                .from('dtb_store')
                .update({
                  'stock': dataDetail[i]['logic_num'],
                  'inventory_stock': null
                })
                .eq('product_id', dataDetail[i]['product_id'])
                .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
                .select('*');
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.context)!.menu_content_4 +
                    WMSLocalizations.i18n(state.context)!.update_error);
            // 关闭加载状态
            BotToast.closeAllLoading();
            return;
          }

          try {
            // 更新商品在庫
            await SupabaseUtils.getClient()
                .from('dtb_product_location')
                .update({
                  'stock': dataDetail[i]['logic_num'],
                })
                .eq('location_id', dataDetail[i]['location_id'])
                .eq('product_id', dataDetail[i]['product_id']);
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.context)!
                        .outbound_adjust_query_location +
                    WMSLocalizations.i18n(state.context)!.update_error);
            // 关闭加载状态
            BotToast.closeAllLoading();
            return;
          }

          // 临时数据
          Map<String, dynamic> tempData = {
            "stock_id": storeList[0]['id'],
            "year_month": DateFormat('yyyyMM').format(DateTime.now()),
            "product_id": dataDetail[i]['product_id'],
            "location_id": dataDetail[i]['location_id'],
            "action_id": int.parse(Config.ACTION_ID_14),
            "company_id": StoreProvider.of<WMSState>(state.context)
                .state
                .loginUser
                ?.company_id as int,
          };
          // 受払明細
          StoreHistory storeHistory = StoreHistory.fromJson(tempData);

          try {
            // 新增受払明細
            await SupabaseUtils.getClient()
                .from('dtb_store_history')
                .insert(storeHistory);
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.context)!.menu_content_4_10 +
                    WMSLocalizations.i18n(state.context)!.update_error);
            // 关闭加载状态
            BotToast.closeAllLoading();
            return;
          }
        }
      }

      // 成功提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.context)!.Inventory_Confirmed_tip_8);

      // 插入操作履历 sys_log表
      CommonUtils().createLogInfo(
          '棚卸確定' +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT6 +
              Config.OPERATION_TEXT2,
          "CancelEvent()",
          StoreProvider.of<WMSState>(state.context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(state.context).state.loginUser!.id);
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
}
