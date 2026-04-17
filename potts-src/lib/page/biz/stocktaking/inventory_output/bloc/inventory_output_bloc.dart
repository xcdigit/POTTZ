import 'package:bot_toast/bot_toast.dart';

import 'package:wms/common/utils/supabase_untils.dart';

import 'package:wms/widget/table/bloc/wms_record_model.dart';

import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../common/config/config.dart';
import 'inventory_output_model.dart';

/**
 * 内容：棚卸データ出力 - bloc
 * 作者：王光顺
 * 时间：2023/09/19
 */
abstract class InventoryOutputEvent extends TableListEvent {}

class InitEvent extends InventoryOutputEvent {
  // 初始化事件
  InitEvent();
}

class SetValueEvent extends InventoryOutputEvent {
  // Value
  dynamic value;
  // 设定值事件
  SetValueEvent(this.value);
}

class CurrentIndexChangeEvent extends InventoryOutputEvent {
  // 当前下标
  int currentIndex;
  // 当前下标变更事件
  CurrentIndexChangeEvent(this.currentIndex);
}

class SetCsvEvent extends InventoryOutputEvent {
  // Value
  List<int> value;
  // 设定值事件
  SetCsvEvent(this.value);
}

// 设置sort字段
class SetSortEvent extends InventoryOutputEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class InventoryOutputBloc extends WmsTableBloc<InventoryOutputModel> {
  @override
  InventoryOutputModel clone(InventoryOutputModel src) {
    return InventoryOutputModel.clone(src);
  }

  InventoryOutputBloc(InventoryOutputModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      //
      if ((state.startDate == '')) {
        state.startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

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

      //
      if (state.startDate == '') {
        state.startDate = null;
      }
      // 列表数据清空
      state.records.clear();
      // 查询出荷指示明细
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_query_warehouse_dtb_inventory', params: {
            'company_id': state.companyId,
            'csv': state.currentIndex == Config.NUMBER_ZERO
                ? ['1', '2']
                : state.currentIndex == Config.NUMBER_ONE
                    ? ['2']
                    : ['1'],
            'start_date': state.startDate
          })
          .eq('confirm_flg', '1')
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1)
          .order(state.sortCol, ascending: state.ascendingFlg);
      //
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_query_warehouse_dtb_inventory', params: {
            'company_id': state.companyId,
            'csv': state.currentIndex == Config.NUMBER_ZERO
                ? ['1', '2']
                : state.currentIndex == Config.NUMBER_ONE
                    ? ['2']
                    : ['1'],
            'start_date': state.startDate
          })
          .eq('confirm_flg', '1')
          .order(state.sortCol, ascending: state.ascendingFlg);
      //
      List<dynamic> data1 = await SupabaseUtils.getClient()
          .rpc('func_query_warehouse_dtb_inventory', params: {
            'company_id': state.companyId,
            'csv': ['2'],
            'start_date': state.startDate
          })
          .eq('confirm_flg', '1')
          .order(state.sortCol, ascending: state.ascendingFlg);
      //
      List<dynamic> data2 = await SupabaseUtils.getClient()
          .rpc('func_query_warehouse_dtb_inventory', params: {
            'company_id': state.companyId,
            'csv': ['1'],
            'start_date': state.startDate
          })
          .eq('confirm_flg', '1')
          .order(state.sortCol, ascending: state.ascendingFlg);
      //
      state.num1 = data1.length;
      state.num2 = data2.length;
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        if (data[i]['confirm_flg'] == '1') {
          data[i]['confirm_flg'] = '確定済';
        }
        if (data[i]['confirm_flg'] == '2') {
          data[i]['confirm_flg'] = '未確定';
        }
        if (data[i]['csv_kbn'] == '1') {
          data[i]['csv_kbn'] = '連携済';
        }
        if (data[i]['csv_kbn'] == '2') {
          data[i]['csv_kbn'] = '未連携';
        }
        //
        state.records.add(WmsRecordModel(i, data[i]));
      }
      //
      state.total = count.length;

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    //
    on<SetValueEvent>((event, emit) async {
      state.startDate = event.value;

      // 刷新补丁
      emit(clone(state));
    });

    // 当前下标变更事件
    on<CurrentIndexChangeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      //
      state.currentIndex = event.currentIndex;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    on<SetCsvEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      for (int i = 0; i < event.value.length; i++)
        await SupabaseUtils.getClient()
            .from('dtb_inventory')
            .update({'csv_kbn': '1'}).eq('id', event.value[i]);

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
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
