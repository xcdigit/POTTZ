import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/check_utils.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'inventory_query_detail_model.dart';

/**
 * 内容：棚卸照会明细-BLOC
 * 作者：熊草云
 * 时间：2023/10/07
 * 作者：赵士淞
 * 时间：2023/10/26
 */
// 事件
abstract class InventoryQueryDetailEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends InventoryQueryDetailEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 保存检索按钮标记事件
class SaveQueryButtonFlag extends InventoryQueryDetailEvent {
  // 值
  bool value;
  // 保存检索按钮标记事件
  SaveQueryButtonFlag(this.value);
}

// 保存查询：位置代码事件
class SaveSearchLocationLocCdEvent extends InventoryQueryDetailEvent {
  // 值
  String value;
  bool flag;
  // 保存查询：位置代码事件
  SaveSearchLocationLocCdEvent(this.value, this.flag);
}

// 保存查询：商品代码事件
class SaveSearchProductCodeEvent extends InventoryQueryDetailEvent {
  // 值
  String value;
  bool flag;
  // 保存查询：商品代码事件
  SaveSearchProductCodeEvent(this.value, this.flag);
}

// 保存查询：商品名称事件
class SaveSearchProductNameEvent extends InventoryQueryDetailEvent {
  // 值
  String value;
  bool flag;
  // 保存查询：商品名称事件
  SaveSearchProductNameEvent(this.value, this.flag);
}

// 保存查询：差異チェック事件
class SaveSearchDetailDiffKbnEvent extends InventoryQueryDetailEvent {
  // 值
  String value;
  bool flag;
  // 保存查询：差異チェック事件
  SaveSearchDetailDiffKbnEvent(this.value, this.flag);
}

// 保存查询：完了チェック事件
class SaveSearchDetailEndKbnEvent extends InventoryQueryDetailEvent {
  // 值
  String value;
  bool flag;
  // 保存查询：完了チェック事件
  SaveSearchDetailEndKbnEvent(this.value, this.flag);
}

// 保存检索：位置代码事件
class SaveQueryLocationLocCdEvent extends InventoryQueryDetailEvent {
  // 值
  String value;
  bool flag;
  // 保存检索：位置代码事件
  SaveQueryLocationLocCdEvent(this.value, this.flag);
}

// 保存检索：商品代码事件
class SaveQueryProductCodeEvent extends InventoryQueryDetailEvent {
  // 值
  String value;
  bool flag;
  // 保存检索：商品代码事件
  SaveQueryProductCodeEvent(this.value, this.flag);
}

// 保存检索：商品名称事件
class SaveQueryProductNameEvent extends InventoryQueryDetailEvent {
  // 值
  String value;
  bool flag;
  // 保存检索：商品名称事件
  SaveQueryProductNameEvent(this.value, this.flag);
}

// 保存检索：差異チェック事件
class SaveQueryDetailDiffKbnEvent extends InventoryQueryDetailEvent {
  // 值
  String value;
  bool flag;
  // 保存检索：差異チェック事件
  SaveQueryDetailDiffKbnEvent(this.value, this.flag);
}

// 保存检索：完了チェック事件
class SaveQueryDetailEndKbnEvent extends InventoryQueryDetailEvent {
  // 值
  String value;
  bool flag;
  // 保存检索：完了チェック事件
  SaveQueryDetailEndKbnEvent(this.value, this.flag);
}

// 搜索按钮事件
class SearchButtonEvent extends InventoryQueryDetailEvent {
  // 搜索按钮事件
  SearchButtonEvent();
}

// 重置按钮事件
class ResetButtonEvent extends InventoryQueryDetailEvent {
  // 重置按钮事件
  ResetButtonEvent();
}

// 表格Tab切换事件
class TableTabSwitchEvent extends InventoryQueryDetailEvent {
  // 表格Tab下标
  int tableTabIndex;
  // 表格Tab切换事件
  TableTabSwitchEvent(this.tableTabIndex);
}

// 删除事件
class DeleteEvent extends InventoryQueryDetailEvent {
  // 删除ID
  int deleteId;
  // 删除事件
  DeleteEvent(this.deleteId);
}
// 自定义事件 - 终

class InventoryQueryDetailBloc extends WmsTableBloc<InventoryQueryDetailModel> {
  // 刷新补丁
  @override
  InventoryQueryDetailModel clone(InventoryQueryDetailModel src) {
    return InventoryQueryDetailModel.clone(src);
  }

  InventoryQueryDetailBloc(InventoryQueryDetailModel state) : super(state) {
    // 查询分页数据事件
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

      // 查询棚卸明細
      List<dynamic> data1 = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_dtb_inventory_detail', params: {
            'loc_cd': state.queryLocationLocCd != ''
                ? state.queryLocationLocCd
                : null,
            'product_code':
                state.queryProductCode != '' ? state.queryProductCode : null,
            'product_name':
                state.queryProductName != '' ? state.queryProductName : null,
            'diff_kbn': state.queryDetailDiffKbn != ''
                ? state.queryDetailDiffKbn
                : null,
            'end_kbn':
                state.queryDetailEndKbn != '' ? state.queryDetailEndKbn : null,
            'inventory_id': state.detailId,
            'del_kbn': Config.DELETE_NO,
          })
          .select('*')
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();

      // 循环棚卸明細数据
      for (int i = 0; i < data1.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data1[i]));
      }

      // 查询棚卸明細
      List<dynamic> data2 = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_dtb_inventory_detail', params: {
        'loc_cd':
            state.queryLocationLocCd != '' ? state.queryLocationLocCd : null,
        'product_code':
            state.queryProductCode != '' ? state.queryProductCode : null,
        'product_name':
            state.queryProductName != '' ? state.queryProductName : null,
        'diff_kbn':
            state.queryDetailDiffKbn != '' ? state.queryDetailDiffKbn : null,
        'end_kbn':
            state.queryDetailEndKbn != '' ? state.queryDetailEndKbn : null,
        'inventory_id': state.detailId,
        'del_kbn': Config.DELETE_NO,
      }).select('*');
      // 总页数
      state.total = data2.length;

      // 更新
      emit(clone(state));
      // 关闭加载状态
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询棚卸
      List<dynamic> inventoryData = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_item_long_dtb_inventory', params: {
        'id': state.detailId,
        'del_kbn': Config.DELETE_NO,
        'end_kbn': Config.END_KBN_1,
      }).select('*');
      // 判断棚卸数量
      if (inventoryData.length != 0) {
        // 棚卸信息
        state.inventoryInfo = inventoryData[0];
        state.inventoryInfo['progress'] =
            state.inventoryInfo['total_all_logic_num'] != 0
                ? (state.inventoryInfo['total_logic_num'] /
                        state.inventoryInfo['total_all_logic_num']) *
                    100
                : 0;
        state.inventoryInfo['confirm_name'] =
            state.inventoryInfo['confirm_flg'] == Config.CONFIRM_KBN_2
                ? WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_tab_Undetermined
                : state.inventoryInfo['confirm_flg'] == Config.CONFIRM_KBN_1
                    ? WMSLocalizations.i18n(state.rootContext)!
                        .instruction_input_tab_Determined
                    : '';
      } else {
        // 棚卸信息
        state.inventoryInfo = {
          'id': '',
          'warehouse_id': '',
          'warehouse_name': '',
          'start_date': '',
          'confirm_date': '',
          'confirm_flg': '',
          'total_real_num': 0,
          'total_logic_num': 0,
          'total_diff_num': 0,
          'total_all_logic_num': 0,
          'progress': 0,
          'confirm_name': '',
        };
      }

      // 查询位置
      List<dynamic> locationData = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id as int)
          .eq('del_kbn', Config.DELETE_NO);
      // 位置列表
      state.locationList = locationData;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索按钮标记事件
    on<SaveQueryButtonFlag>((event, emit) async {
      // 检索按钮标记
      state.queryButtonFlag = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：位置代码事件
    on<SaveSearchLocationLocCdEvent>((event, emit) async {
      // 查询：位置代码
      state.searchLocationLocCd = event.value;
      if (event.flag) {
        add(SaveQueryLocationLocCdEvent(event.value, false));
      }
      // 更新
      emit(clone(state));
    });

    // 保存查询：商品代码事件
    on<SaveSearchProductCodeEvent>((event, emit) async {
      // 查询：商品代码
      state.searchProductCode = event.value;
      if (event.flag) {
        add(SaveQueryProductCodeEvent(event.value, false));
      }
      // 更新
      emit(clone(state));
    });

    // 保存查询：商品名称事件
    on<SaveSearchProductNameEvent>((event, emit) async {
      // 查询：商品名称
      state.searchProductName = event.value;
      if (event.flag) {
        add(SaveQueryProductNameEvent(event.value, false));
      }
      // 更新
      emit(clone(state));
    });

    // 保存查询：差異チェック事件
    on<SaveSearchDetailDiffKbnEvent>((event, emit) async {
      // 查查询：差異チェック
      state.searchDetailDiffKbn = event.value;
      if (event.flag) {
        add(SaveQueryDetailDiffKbnEvent(event.value, false));
      }
      // 更新
      emit(clone(state));
    });

    // 保存查询：完了チェック事件
    on<SaveSearchDetailEndKbnEvent>((event, emit) async {
      // 查询：完了チェック
      state.searchDetailEndKbn = event.value;
      if (event.flag) {
        add(SaveQueryDetailEndKbnEvent(event.value, false));
      }
      // 更新
      emit(clone(state));
    });

    // 保存检索：位置代码事件
    on<SaveQueryLocationLocCdEvent>((event, emit) async {
      // 打开加载状态
      if (event.flag) {
        BotToast.showLoading();
      }

      // 检索：位置代码
      state.queryLocationLocCd = event.value;
      add(SaveSearchLocationLocCdEvent(event.value, false));
      if (event.flag) {
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      }
    });

    // 保存检索：商品代码事件
    on<SaveQueryProductCodeEvent>((event, emit) async {
      // 打开加载状态
      if (event.flag) {
        BotToast.showLoading();
      }
      // 检索：商品代码
      state.queryProductCode = event.value;
      add(SaveSearchProductCodeEvent(event.value, false));

      if (event.flag) {
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      }
    });

    // 保存检索：商品名称事件
    on<SaveQueryProductNameEvent>((event, emit) async {
      // 打开加载状态
      if (event.flag) {
        BotToast.showLoading();
      }
      // 检索：商品名称
      state.queryProductName = event.value;
      add(SaveSearchProductNameEvent(event.value, false));

      if (event.flag) {
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      }
    });

    // 保存检索：差異チェック事件
    on<SaveQueryDetailDiffKbnEvent>((event, emit) async {
      // 打开加载状态
      if (event.flag) {
        BotToast.showLoading();
      }
      // 检索：差異チェック
      state.queryDetailDiffKbn = event.value;
      add(SaveSearchDetailDiffKbnEvent(event.value, false));
      if (event.flag) {
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      }
    });

    // 保存检索：完了チェック事件
    on<SaveQueryDetailEndKbnEvent>((event, emit) async {
      // 打开加载状态
      if (event.flag) {
        BotToast.showLoading();
      }
      // 检索：完了チェック
      state.queryDetailEndKbn = event.value;
      add(SaveSearchDetailEndKbnEvent(event.value, false));
      if (event.flag) {
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      }
    });

    // 搜索按钮事件
    on<SearchButtonEvent>((event, emit) async {
      //
      if (state.searchProductCode != '' &&
          CheckUtils.check_Half_Alphanumeric_6_50(state.searchProductCode)) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_table_title_3 +
                WMSLocalizations.i18n(state.rootContext)!
                    .input_must_six_number_check);
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      // 检索按钮标记
      state.queryButtonFlag = false;
      // 检索：位置代码
      state.queryLocationLocCd = state.searchLocationLocCd;
      // 检索：商品代码
      state.queryProductCode = state.searchProductCode;
      // 检索：商品名称
      state.queryProductName = state.searchProductName;
      // 检索：差異チェック
      state.queryDetailDiffKbn = state.searchDetailDiffKbn;
      // 检索：完了チェック
      state.queryDetailEndKbn = state.searchDetailEndKbn;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 重置按钮事件
    on<ResetButtonEvent>((event, emit) async {
      // 查询：位置代码
      state.searchLocationLocCd = '';
      // 查询：商品代码
      state.searchProductCode = '';
      // 查询：商品名称
      state.searchProductName = '';
      // 查询：差異チェック
      state.searchDetailDiffKbn = '';
      // 查询：完了チェック
      state.searchDetailEndKbn = '';
      // 检索：位置代码
      state.queryLocationLocCd = '';
      // 检索：商品代码
      state.queryProductCode = '';
      // 检索：商品名称
      state.queryProductName = '';
      // 检索：差異チェック
      state.queryDetailDiffKbn = '';
      // 检索：完了チェック
      state.queryDetailEndKbn = '';
      // 更新
      emit(clone(state));
    });

    // 表格Tab切换事件
    on<TableTabSwitchEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 表格：Tab下标
      state.tableTabIndex = event.tableTabIndex;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 删除事件
    on<DeleteEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        // 删除
        await SupabaseUtils.getClient().from('dtb_inventory_detail').update({
          'real_num': null,
          'diff_kbn': Config.DIFF_KBN_2,
          'diff_reason': null,
          'end_kbn': Config.END_KBN_2,
        }).eq('id', event.deleteId);
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.menu_content_60_5_9 +
                WMSLocalizations.i18n(state.rootContext)!.delete_error);
        // 关闭加载状态
        BotToast.closeAllLoading();
        return;
      }

      // 成功提示
      WMSCommonBlocUtils.successTextToast(
          WMSLocalizations.i18n(state.rootContext)!.menu_content_60_5_9 +
              WMSLocalizations.i18n(state.rootContext)!.delete_success);

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(InitEvent());
    });

    add(InitEvent());
  }
}
